"""
Routes pour la gestion des collectes
"""

from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session, joinedload
from typing import List, Optional
from database.database import get_db
from database.models import InfoCollecte, Taxe, StatutCollecteEnum, Contribuable, AffectationTaxe
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


@router.get("/contribuable/{contribuable_id}/taxes", response_model=dict)
def get_contribuable_taxes(contribuable_id: int, db: Session = Depends(get_db)):
    """Récupère les taxes actives d'un contribuable pour la sélection lors de la création d'une collecte"""
    # Vérifier que le contribuable existe
    contribuable = db.query(Contribuable).filter(Contribuable.id == contribuable_id).first()
    if not contribuable:
        raise HTTPException(status_code=404, detail="Contribuable non trouvé")
    
    # Récupérer les affectations de taxes actives
    affectations = db.query(AffectationTaxe).options(
        joinedload(AffectationTaxe.taxe)
    ).filter(
        AffectationTaxe.contribuable_id == contribuable_id,
        AffectationTaxe.actif == True
    ).all()
    
    # Construire la réponse
    taxes = []
    for affectation in affectations:
        taxe = affectation.taxe
        taxes.append({
            "affectation_id": affectation.id,
            "taxe_id": taxe.id,
            "taxe_nom": taxe.nom,
            "taxe_code": taxe.code,
            "montant": float(taxe.montant),
            "montant_custom": float(affectation.montant_custom) if affectation.montant_custom else None,
            "periodicite": taxe.periodicite.value if hasattr(taxe.periodicite, 'value') else taxe.periodicite,
            "description": taxe.description
        })
    
    return {
        "contribuable_id": contribuable_id,
        "contribuable_nom": contribuable.nom,
        "contribuable_prenom": contribuable.prenom,
        "telephone": contribuable.telephone,
        "collecteur_id": contribuable.collecteur_id,
        "taxes": taxes
    }


class CollecteAnnulationRequest(BaseModel):
    raison: str = Field(..., min_length=3, description="Raison de l'annulation")


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
    from database.models import CollecteItem, CollecteLocation
    
    query = db.query(InfoCollecte).options(
        joinedload(InfoCollecte.contribuable),
        joinedload(InfoCollecte.collecteur),
        joinedload(InfoCollecte.items_collecte),
        joinedload(InfoCollecte.location)
    )
    
    if collecteur_id:
        query = query.filter(InfoCollecte.collecteur_id == collecteur_id)
    if contribuable_id:
        query = query.filter(InfoCollecte.contribuable_id == contribuable_id)
    if taxe_id:
        # Filtrer par taxe en cherchant dans collecte_item
        query = query.join(CollecteItem).filter(CollecteItem.taxe_id == taxe_id)
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
    from database.models import CollecteLocation
    
    collecte = db.query(InfoCollecte).options(
        joinedload(InfoCollecte.contribuable),
        joinedload(InfoCollecte.collecteur),
        joinedload(InfoCollecte.items_collecte),
        joinedload(InfoCollecte.location)
    ).filter(InfoCollecte.id == collecte_id).first()
    
    if not collecte:
        raise HTTPException(status_code=404, detail="Collecte non trouvée")
    return collecte


@router.post("/", response_model=InfoCollecteResponse, status_code=201)
def create_collecte(collecte: InfoCollecteCreate, db: Session = Depends(get_db)):
    """Crée une nouvelle collecte avec plusieurs taxes"""
    from database.models import CollecteItem
    
    # Vérifier que le contribuable existe
    contribuable = db.query(Contribuable).filter(Contribuable.id == collecte.contribuable_id).first()
    if not contribuable:
        raise HTTPException(status_code=404, detail="Contribuable non trouvé")
    
    # Vérifier que le collecteur existe
    from database.models import Collecteur
    collecteur = db.query(Collecteur).filter(Collecteur.id == collecte.collecteur_id).first()
    if not collecteur:
        raise HTTPException(status_code=404, detail="Collecteur non trouvé")
    
    # Vérifier que toutes les taxes existent et calculer le montant total et commission
    montant_total = Decimal('0')
    commission_total = Decimal('0')
    items_to_create = []
    
    for item in collecte.items:
        taxe = db.query(Taxe).filter(Taxe.id == item.taxe_id).first()
        if not taxe:
            raise HTTPException(status_code=404, detail=f"Taxe avec ID {item.taxe_id} non trouvée")
        
        # Calculer la commission pour cet article
        commission = item.montant * (Decimal(str(taxe.commission_pourcentage)) / Decimal('100'))
        
        montant_total += item.montant
        commission_total += commission
        
        items_to_create.append({
            'taxe_id': item.taxe_id,
            'montant': item.montant,
            'commission': commission
        })
    
    # Générer une référence unique
    reference = f"COL-{datetime.utcnow().strftime('%Y%m%d')}-{db.query(InfoCollecte).count() + 1:04d}"
    
    # Créer la collecte
    db_collecte = InfoCollecte(
        contribuable_id=collecte.contribuable_id,
        collecteur_id=collecte.collecteur_id,
        montant_total=montant_total,
        commission_total=commission_total,
        type_paiement=collecte.type_paiement,
        billetage=collecte.billetage,
        date_collecte=collecte.date_collecte,
        reference=reference,
        statut=StatutCollecteEnum.PENDING
    )
    db.add(db_collecte)
    db.flush()  # Flush pour obtenir l'ID sans commit
    
    # Créer les articles de collecte
    for item_data in items_to_create:
        db_item = CollecteItem(
            collecte_id=db_collecte.id,
            taxe_id=item_data['taxe_id'],
            montant=item_data['montant'],
            commission=item_data['commission']
        )
        db.add(db_item)
    
    db.commit()
    db.refresh(db_collecte)
    return db_collecte


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

