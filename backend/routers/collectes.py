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
@router.get("", response_model=List[InfoCollecteResponse])
def get_collectes(
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=50000),  # Augmenté pour charger toutes les collectes
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

    print(f"🔍 Recherche taxes pour contribuable ID: {contribuable_id}")

    # Récupérer les affectations de taxes actives
    from sqlalchemy import or_

    affectations = db.query(AffectationTaxe).options(
        joinedload(AffectationTaxe.taxe).joinedload(Taxe.type_taxe),
        joinedload(AffectationTaxe.taxe).joinedload(Taxe.service)
    ).filter(
        AffectationTaxe.contribuable_id == contribuable_id,
        AffectationTaxe.actif == True,
        # Taxes sans date de fin OU avec date de fin dans le futur
        or_(
            AffectationTaxe.date_fin.is_(None),
            AffectationTaxe.date_fin > datetime.utcnow()
        )
    ).all()

    print(f"📋 Affectations trouvées: {len(affectations)}")
    for aff in affectations:
        print(f"   - Affectation ID {aff.id}: taxe_id={aff.taxe_id}, actif={aff.actif}, date_fin={aff.date_fin}")

    # Formater les taxes pour le frontend
    taxes_disponibles = []
    for affectation in affectations:
        taxe = affectation.taxe
        if taxe:
            print(f"   ✓ Taxe {taxe.id} ({taxe.nom}): actif={taxe.actif}")
            if taxe.actif:
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
            else:
                print(f"   ✗ Taxe {taxe.id} ignorée (inactive)")
        else:
            print(f"   ✗ Affectation {affectation.id}: pas de taxe associée")

    print(f"✅ Retour de {len(taxes_disponibles)} taxes disponibles")

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


# ==================== ENDPOINT ÉTATS DES COLLECTEURS ====================

class CollecteurEtatResponse(BaseModel):
    """Schéma pour l'état d'un collecteur par jour"""
    collecteur_id: int
    nom_collecteur: str
    date: date
    montant_cash: Decimal
    montant_numerique: Decimal
    montant_total: Decimal
    nombre_contribuables: int
    contribuables: List[dict]  # [{id, nom, prenom, montant}]
    
    class Config:
        from_attributes = True


@router.get("/etat/par-collecteur")
@router.get("/etat/par-collecteur/")
def get_etat_collecteurs(
    date_debut: Optional[date] = Query(None),
    date_fin: Optional[date] = Query(None),
    date_specifique: Optional[date] = Query(None),
    collecteur_id: Optional[int] = Query(None),
    db: Session = Depends(get_db)
):
    """
    Récupère l'état des collecteurs par jour avec montants et contribuables.
    
    Paramètres:
    - date_debut: Date de début (incluse)
    - date_fin: Date de fin (incluse)
    - date_specifique: Filtrer par un jour spécifique
    - collecteur_id: Filtrer par collecteur
    """
    from sqlalchemy import func, and_
    from database.models import Collecteur, TypePaiementEnum
    
    print(f"[collectes.get_etat_collecteurs] date_debut={date_debut} date_fin={date_fin} date_specifique={date_specifique} collecteur_id={collecteur_id}")
    # Déterminer les dates
    if date_specifique:
        date_debut = date_specifique
        date_fin = date_specifique
    elif not date_debut:
        # Par défaut: aujourd'hui
        date_debut = datetime.now().date()
        date_fin = date_debut
    elif not date_fin:
        date_fin = date_debut
    
    # Récupérer les collectes de la période
    query = db.query(
        InfoCollecte.collecteur_id,
        func.date(InfoCollecte.date_collecte).label('date'),
        InfoCollecte.type_paiement,
        func.sum(InfoCollecte.montant).label('total_montant')
    ).filter(
        and_(
            func.date(InfoCollecte.date_collecte) >= date_debut,
            func.date(InfoCollecte.date_collecte) <= date_fin,
            InfoCollecte.statut == StatutCollecteEnum.COMPLETED
        )
    )
    
    if collecteur_id:
        query = query.filter(InfoCollecte.collecteur_id == collecteur_id)
    
    collectes = query.group_by(
        InfoCollecte.collecteur_id,
        'date',
        InfoCollecte.type_paiement
    ).all()
    
    # Organiser les données par collecteur et date
    etats = {}
    for collecteur_id_val, date_val, type_paiement, montant in collectes:
        key = f"{collecteur_id_val}_{date_val}"
        
        if key not in etats:
            # Récupérer le nom du collecteur
            collecteur = db.query(Collecteur).filter(
                Collecteur.id == collecteur_id_val
            ).first()
            
            etats[key] = {
                'collecteur_id': collecteur_id_val,
                'nom_collecteur': collecteur.nom if collecteur else 'Inconnu',
                'date': date_val,
                'montant_cash': Decimal('0.00'),
                'montant_numerique': Decimal('0.00'),
                'montant_total': Decimal('0.00'),
                'contribuables': {}  # Dictionnaire pour éviter les doublons
            }
        
        # Ajouter le montant selon le type de paiement
        montant_dec = Decimal(str(montant)) if montant else Decimal('0.00')
        if type_paiement == 'especes':
            etats[key]['montant_cash'] += montant_dec
        else:  # mobile_money, carte, etc.
            etats[key]['montant_numerique'] += montant_dec
        
        etats[key]['montant_total'] += montant_dec
    
    # Récupérer les contribuables pour chaque collecte
    collectes_details = db.query(
        InfoCollecte.collecteur_id,
        func.date(InfoCollecte.date_collecte).label('date'),
        Contribuable.id.label('contribuable_id'),
        Contribuable.nom,
        Contribuable.prenom,
        func.sum(InfoCollecte.montant).label('montant_collecte')
    ).filter(
        and_(
            func.date(InfoCollecte.date_collecte) >= date_debut,
            func.date(InfoCollecte.date_collecte) <= date_fin,
            InfoCollecte.statut == StatutCollecteEnum.COMPLETED
        )
    ).join(Contribuable, InfoCollecte.contribuable_id == Contribuable.id)
    
    if collecteur_id:
        collectes_details = collectes_details.filter(InfoCollecte.collecteur_id == collecteur_id)
    
    collectes_details = collectes_details.group_by(
        InfoCollecte.collecteur_id,
        'date',
        Contribuable.id,
        Contribuable.nom,
        Contribuable.prenom
    ).all()
    
    # Ajouter les contribuables à chaque état
    for collecteur_id_val, date_val, contrib_id, nom, prenom, montant in collectes_details:
        key = f"{collecteur_id_val}_{date_val}"
        if key in etats:
            if contrib_id not in etats[key]['contribuables']:
                etats[key]['contribuables'][contrib_id] = {
                    'id': contrib_id,
                    'nom': nom,
                    'prenom': prenom,
                    'montant': float(montant) if montant else 0.0
                }
    
    # Convertir le dictionnaire de contribuables en liste
    result = []
    for etat_data in etats.values():
        contribuables_list = list(etat_data['contribuables'].values())
        result.append({
            'collecteur_id': etat_data['collecteur_id'],
            'nom_collecteur': etat_data['nom_collecteur'],
            'date': etat_data['date'],
            'montant_cash': etat_data['montant_cash'],
            'montant_numerique': etat_data['montant_numerique'],
            'montant_total': etat_data['montant_total'],
            'nombre_contribuables': len(contribuables_list),
            'contribuables': contribuables_list
        })
    
    # Trier par date décroissante puis par nom du collecteur
    result.sort(key=lambda x: (x['date'], x['nom_collecteur']), reverse=True)
    
    return result
