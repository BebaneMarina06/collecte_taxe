"""
Routes pour la gestion des collectes
"""

from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import List, Optional
from database.database import get_db
from database.models import InfoCollecte, Taxe, StatutCollecteEnum, AffectationTaxe, Contribuable
from schemas.info_collecte import InfoCollecteCreate, InfoCollecteUpdate, InfoCollecteResponse
from datetime import datetime, date
from decimal import Decimal
from pydantic import BaseModel, Field
from auth.security import get_current_active_user

router = APIRouter(
    prefix="/api/collectes",
    tags=["collectes"],
    dependencies=[Depends(get_current_active_user)],
)


class CollecteAnnulationRequest(BaseModel):
    raison: str = Field(..., min_length=3, description="Raison de l'annulation")


class CollecteItem(BaseModel):
    """Item de collecte avec taxe et montant"""
    taxe_id: int
    montant: Decimal = Field(..., ge=0)


class CollecteBulkCreate(BaseModel):
    """Création de plusieurs collectes en une seule requête"""
    contribuable_id: int
    collecteur_id: int
    type_paiement: str  # "especes", "mobile_money", "carte"
    billetage: Optional[str] = None  # JSON string
    date_collecte: Optional[datetime] = None
    items: List[CollecteItem] = Field(..., min_items=1, description="Liste des taxes à collecter")


@router.get("/", response_model=List[InfoCollecteResponse])
def get_collectes(
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=1000),
    collecteur_id: Optional[int] = None,
    contribuable_id: Optional[int] = None,
    taxe_id: Optional[int] = None,
    statut: Optional[str] = None,
    date_debut: Optional[date] = None,
    date_fin: Optional[date] = None,
    telephone: Optional[str] = None,
    db: Session = Depends(get_db)
):
    """Récupère la liste des collectes avec filtres et relations"""
    from sqlalchemy.orm import joinedload
    from database.models import Contribuable
    
    from database.models import CollecteLocation
    
    query = db.query(InfoCollecte).options(
        joinedload(InfoCollecte.contribuable),
        joinedload(InfoCollecte.taxe),
        joinedload(InfoCollecte.collecteur),
        joinedload(InfoCollecte.location)
    )
    
    if collecteur_id:
        query = query.filter(InfoCollecte.collecteur_id == collecteur_id)
    if contribuable_id:
        query = query.filter(InfoCollecte.contribuable_id == contribuable_id)
    if taxe_id:
        query = query.filter(InfoCollecte.taxe_id == taxe_id)
    if statut:
        try:
            statut_enum = StatutCollecteEnum(statut)
            query = query.filter(InfoCollecte.statut == statut_enum)
        except ValueError:
            raise HTTPException(status_code=400, detail="Statut invalide")
    if date_debut:
        query = query.filter(InfoCollecte.date_collecte >= datetime.combine(date_debut, datetime.min.time()))
    if date_fin:
        query = query.filter(InfoCollecte.date_collecte <= datetime.combine(date_fin, datetime.max.time()))
    if telephone:
        # Filtrer par téléphone du contribuable
        query = query.join(Contribuable).filter(Contribuable.telephone.ilike(f"%{telephone}%"))
    
    collectes = query.order_by(InfoCollecte.date_collecte.desc()).offset(skip).limit(limit).all()
    return collectes


@router.get("/{collecte_id}", response_model=InfoCollecteResponse)
def get_collecte(collecte_id: int, db: Session = Depends(get_db)):
    """Récupère une collecte par son ID avec toutes les relations"""
    from sqlalchemy.orm import joinedload

    from database.models import CollecteLocation

    collecte = db.query(InfoCollecte).options(
        joinedload(InfoCollecte.contribuable),
        joinedload(InfoCollecte.taxe),
        joinedload(InfoCollecte.collecteur),
        joinedload(InfoCollecte.location)
    ).filter(InfoCollecte.id == collecte_id).first()

    if not collecte:
        raise HTTPException(status_code=404, detail="Collecte non trouvée")
    return collecte


@router.get("/contribuable/{contribuable_id}/taxes")
def get_contribuable_taxes(contribuable_id: int, db: Session = Depends(get_db)):
    """
    Récupère toutes les taxes actives assignées à un contribuable.
    Retourne les informations nécessaires pour créer une collecte.
    Compatible avec le système de taxations/affectations de taxes.
    """
    from sqlalchemy.orm import joinedload

    # Vérifier que le contribuable existe
    contribuable = db.query(Contribuable).filter(Contribuable.id == contribuable_id).first()
    if not contribuable:
        raise HTTPException(status_code=404, detail="Contribuable non trouvé")

    # Récupérer les affectations de taxes actives
    affectations = db.query(AffectationTaxe).options(
        joinedload(AffectationTaxe.taxe).joinedload(Taxe.type_taxe),
        joinedload(AffectationTaxe.taxe).joinedload(Taxe.service)
    ).filter(
        AffectationTaxe.contribuable_id == contribuable_id,
        AffectationTaxe.actif == True,
        AffectationTaxe.date_fin.is_(None)  # Taxes sans date de fin (toujours actives)
    ).all()

    # Formater les taxes pour le frontend
    taxes_disponibles = []
    for affectation in affectations:
        taxe = affectation.taxe
        if taxe and taxe.actif:
            # Calculer le montant effectif (custom ou standard)
            montant_effectif = float(affectation.montant_custom) if affectation.montant_custom else float(taxe.montant)

            taxes_disponibles.append({
                "affectation_id": affectation.id,
                "taxe_id": taxe.id,
                "taxe_nom": taxe.nom,
                "taxe_code": taxe.code,
                "montant": montant_effectif,
                "montant_custom": float(affectation.montant_custom) if affectation.montant_custom else None,
                "periodicite": taxe.periodicite.value if hasattr(taxe.periodicite, 'value') else str(taxe.periodicite),
                "description": taxe.description or "",
                "commission_pourcentage": float(taxe.commission_pourcentage),
                "type_taxe": taxe.type_taxe.nom if taxe.type_taxe else None,
                "service": taxe.service.nom if taxe.service else None,
                "selected": False  # Par défaut non sélectionnée (pour le frontend)
            })

    return {
        "success": True,
        "contribuable_id": contribuable_id,
        "contribuable_nom": f"{contribuable.nom} {contribuable.prenom or ''}".strip(),
        "contribuable_telephone": contribuable.telephone,
        "contribuable_email": contribuable.email,
        "contribuable_adresse": contribuable.adresse,
        "collecteur_id": contribuable.collecteur_id,
        "quartier": contribuable.quartier.nom if contribuable.quartier else None,
        "zone": contribuable.quartier.zone.nom if contribuable.quartier and contribuable.quartier.zone else None,
        "taxes": taxes_disponibles,
        "total_taxes": len(taxes_disponibles)
    }


@router.post("/", response_model=InfoCollecteResponse, status_code=201)
def create_collecte(collecte: InfoCollecteCreate, db: Session = Depends(get_db)):
    """Crée une nouvelle collecte"""
    # Récupérer la taxe pour calculer la commission
    taxe = db.query(Taxe).filter(Taxe.id == collecte.taxe_id).first()
    if not taxe:
        raise HTTPException(status_code=404, detail="Taxe non trouvée")

    # Calculer la commission
    commission = float(collecte.montant) * (float(taxe.commission_pourcentage) / 100)

    # Générer une référence unique
    reference = f"COL-{datetime.utcnow().strftime('%Y%m%d')}-{db.query(InfoCollecte).count() + 1:04d}"

    db_collecte = InfoCollecte(
        **collecte.dict(),
        commission=Decimal(str(commission)),
        reference=reference,
        statut=StatutCollecteEnum.PENDING
    )
    db.add(db_collecte)
    db.commit()
    db.refresh(db_collecte)
    return db_collecte


@router.post("/bulk", status_code=201)
def create_collecte_bulk(collecte_data: CollecteBulkCreate, db: Session = Depends(get_db)):
    """
    Crée plusieurs collectes en une seule requête (une par taxe)
    Utilisé par le frontend pour créer plusieurs collectes en même temps
    """
    # Vérifier que le contribuable existe
    contribuable = db.query(Contribuable).filter(Contribuable.id == collecte_data.contribuable_id).first()
    if not contribuable:
        raise HTTPException(status_code=404, detail="Contribuable non trouvé")

    # Normaliser le type de paiement
    type_paiement_normalized = collecte_data.type_paiement.strip().lower()
    mapping = {
        "cash": "especes",
        "espece": "especes",
        "especes": "especes",
        "mobile": "mobile_money",
        "mobile_money": "mobile_money",
        "mobile-money": "mobile_money",
        "bamboo": "mobile_money",
        "bamboopay": "mobile_money",
        "carte": "carte",
        "card": "carte",
    }
    type_paiement = mapping.get(type_paiement_normalized, "especes")

    # Date de collecte par défaut
    date_collecte = collecte_data.date_collecte or datetime.utcnow()

    collectes_created = []

    try:
        for item in collecte_data.items:
            # Récupérer la taxe pour calculer la commission
            taxe = db.query(Taxe).filter(Taxe.id == item.taxe_id).first()
            if not taxe:
                raise HTTPException(status_code=404, detail=f"Taxe {item.taxe_id} non trouvée")

            # Calculer la commission
            commission = float(item.montant) * (float(taxe.commission_pourcentage) / 100)

            # Générer une référence unique
            count = db.query(InfoCollecte).count() + len(collectes_created) + 1
            reference = f"COL-{datetime.utcnow().strftime('%Y%m%d')}-{count:04d}"

            # Créer la collecte
            db_collecte = InfoCollecte(
                contribuable_id=collecte_data.contribuable_id,
                taxe_id=item.taxe_id,
                collecteur_id=collecte_data.collecteur_id,
                montant=item.montant,
                type_paiement=type_paiement,
                billetage=collecte_data.billetage,
                date_collecte=date_collecte,
                commission=Decimal(str(commission)),
                reference=reference,
                statut=StatutCollecteEnum.COMPLETED  # Collecte validée immédiatement
            )

            db.add(db_collecte)
            collectes_created.append({
                "taxe_id": item.taxe_id,
                "taxe_nom": taxe.nom,
                "montant": float(item.montant),
                "commission": commission,
                "reference": reference
            })

        db.commit()

        return {
            "success": True,
            "message": f"{len(collectes_created)} collecte(s) créée(s) avec succès",
            "contribuable_id": collecte_data.contribuable_id,
            "collecteur_id": collecte_data.collecteur_id,
            "collectes": collectes_created,
            "montant_total": sum(c["montant"] for c in collectes_created),
            "commission_totale": sum(c["commission"] for c in collectes_created)
        }

    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"Erreur lors de la création des collectes: {str(e)}")


@router.put("/{collecte_id}", response_model=InfoCollecteResponse)
def update_collecte(collecte_id: int, collecte_update: InfoCollecteUpdate, db: Session = Depends(get_db)):
    """Met à jour une collecte"""
    db_collecte = db.query(InfoCollecte).filter(InfoCollecte.id == collecte_id).first()
    if not db_collecte:
        raise HTTPException(status_code=404, detail="Collecte non trouvée")
    
    update_data = collecte_update.dict(exclude_unset=True)
    
    # Gérer le statut
    if "statut" in update_data:
        try:
            update_data["statut"] = StatutCollecteEnum(update_data["statut"])
        except ValueError:
            raise HTTPException(status_code=400, detail="Statut invalide")
    
    for field, value in update_data.items():
        setattr(db_collecte, field, value)
    
    db_collecte.updated_at = datetime.utcnow()
    db.commit()
    db.refresh(db_collecte)
    return db_collecte


@router.patch("/{collecte_id}/annuler", response_model=InfoCollecteResponse)
def annuler_collecte(
    collecte_id: int,
    payload: CollecteAnnulationRequest,
    db: Session = Depends(get_db)
):
    """Annule une collecte"""
    db_collecte = db.query(InfoCollecte).filter(InfoCollecte.id == collecte_id).first()
    if not db_collecte:
        raise HTTPException(status_code=404, detail="Collecte non trouvée")
    
    db_collecte.annule = True
    db_collecte.raison_annulation = payload.raison
    db_collecte.statut = StatutCollecteEnum.CANCELLED
    db_collecte.updated_at = datetime.utcnow()
    db.commit()
    db.refresh(db_collecte)
    return db_collecte


@router.patch("/{collecte_id}/valider", response_model=InfoCollecteResponse)
def valider_collecte(collecte_id: int, db: Session = Depends(get_db)):
    """Valide une collecte et met à jour son statut"""
    db_collecte = db.query(InfoCollecte).filter(InfoCollecte.id == collecte_id).first()
    if not db_collecte:
        raise HTTPException(status_code=404, detail="Collecte non trouvée")

    if db_collecte.annule:
        raise HTTPException(status_code=400, detail="Impossible de valider une collecte annulée")

    db_collecte.statut = StatutCollecteEnum.COMPLETED
    db_collecte.date_cloture = datetime.utcnow()
    db_collecte.updated_at = datetime.utcnow()
    db.commit()
    db.refresh(db_collecte)
    return db_collecte


@router.delete("/{collecte_id}", status_code=204)
def delete_collecte(collecte_id: int, db: Session = Depends(get_db)):
    """Supprime une collecte"""
    db_collecte = db.query(InfoCollecte).filter(InfoCollecte.id == collecte_id).first()
    if not db_collecte:
        raise HTTPException(status_code=404, detail="Collecte non trouvée")
    
    db.delete(db_collecte)
    db.commit()
    return None

