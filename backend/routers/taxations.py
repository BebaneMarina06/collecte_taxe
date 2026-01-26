"""
Router pour la gestion des affectations de taxes (taxations)
Endpoints: /api/taxations
"""

from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy import func, and_, or_, desc
from sqlalchemy.orm import Session, joinedload
from decimal import Decimal
from datetime import datetime
from database.database import get_db
from database.models import AffectationTaxe, Contribuable, Taxe, InfoCollecte
from typing import List, Optional
from pydantic import BaseModel

router = APIRouter(
    prefix="/api/taxations",
    tags=["Taxations"]
)

# ==================== SCHEMAS ====================

class TaxationResponse(BaseModel):
    """Schéma de réponse pour une taxation"""
    id: int
    contribuable_id: int
    contribuable: Optional[dict] = None  # {id, nom, prenom, telephone, email}
    taxe_id: int
    taxe: Optional[dict] = None  # {id, nom, taux, montant_base}
    date_debut: datetime
    date_fin: Optional[datetime]
    montant_custom: Optional[Decimal]
    actif: bool
    montant_attendu: Decimal = Decimal("0.00")
    montant_paye: Decimal = Decimal("0.00")
    montant_restant: Decimal = Decimal("0.00")
    statut: str  # PAYE, PARTIEL, IMPAYE, RETARD
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True

class CreateTaxationRequest(BaseModel):
    """Schéma pour créer une taxation"""
    contribuable_id: int
    taxe_id: int
    date_debut: datetime
    date_fin: Optional[datetime] = None
    montant_custom: Optional[Decimal] = None
    actif: bool = True

class UpdateTaxationRequest(BaseModel):
    """Schéma pour mettre à jour une taxation"""
    date_fin: Optional[datetime] = None
    montant_custom: Optional[Decimal] = None
    actif: Optional[bool] = None

class TaxationStatsResponse(BaseModel):
    """Schéma pour les statistiques des taxations"""
    total_taxations: int
    taxations_payees: int
    taxations_partielles: int
    taxations_impayees: int
    taxations_retard: int
    montant_attendu_total: Decimal
    montant_paye_total: Decimal
    montant_impaye_total: Decimal
    pourcentage_recouvrement: float

# ==================== FONCTIONS HELPERS ====================

def calculate_taxation_stats(affectation: AffectationTaxe, db: Session) -> tuple[Decimal, Decimal, str]:
    """
    Calcule le montant attendu, payé et le statut d'une affectation
    
    Returns:
        (montant_attendu, montant_paye, statut)
    """
    # Récupérer le montant base de la taxe
    taxe = db.query(Taxe).filter(Taxe.id == affectation.taxe_id).first()
    if not taxe:
        return Decimal("0.00"), Decimal("0.00"), "IMPAYE"
    
    # Utiliser montant_custom si disponible, sinon le montant de la taxe
    montant_attendu = affectation.montant_custom or Decimal(taxe.montant)
    
    # Récupérer les collectes payées pour cette affectation
    collectes = db.query(func.sum(InfoCollecte.montant)).filter(
        and_(
            InfoCollecte.contribuable_id == affectation.contribuable_id,
            InfoCollecte.taxe_id == affectation.taxe_id
        )
    ).scalar()
    
    montant_paye = Decimal(collectes) if collectes else Decimal("0.00")
    
    # Déterminer le statut
    if montant_paye >= montant_attendu:
        statut = "PAYE"
    elif montant_paye > 0:
        statut = "PARTIEL"
    else:
        statut = "IMPAYE"
    
    # Vérifier si en retard (date_fin dépassée et non payée)
    if affectation.date_fin and affectation.date_fin < datetime.utcnow() and montant_paye < montant_attendu:
        statut = "RETARD"
    
    return montant_attendu, montant_paye, statut

def format_taxation_response(affectation: AffectationTaxe, db: Session) -> TaxationResponse:
    """Formate une affectation pour la réponse API"""
    montant_attendu, montant_paye, statut = calculate_taxation_stats(affectation, db)
    montant_restant = montant_attendu - montant_paye
    
    # Charger les relations
    contribuable = db.query(Contribuable).filter(Contribuable.id == affectation.contribuable_id).first()
    taxe = db.query(Taxe).filter(Taxe.id == affectation.taxe_id).first()
    
    return TaxationResponse(
        id=affectation.id,
        contribuable_id=affectation.contribuable_id,
        contribuable={
            "id": contribuable.id,
            "nom": contribuable.nom,
            "prenom": contribuable.prenom,
            "telephone": contribuable.telephone,
            "email": contribuable.email
        } if contribuable else None,
        taxe_id=affectation.taxe_id,
        taxe={
            "id": taxe.id,
            "nom": taxe.nom,
            "taux": float(taxe.taux) if taxe.taux else 0,
            "montant": float(taxe.montant) if taxe.montant else 0
        } if taxe else None,
        date_debut=affectation.date_debut,
        date_fin=affectation.date_fin,
        montant_custom=affectation.montant_custom,
        actif=affectation.actif,
        montant_attendu=montant_attendu,
        montant_paye=montant_paye,
        montant_restant=montant_restant,
        statut=statut,
        created_at=affectation.created_at,
        updated_at=affectation.updated_at
    )

# ==================== ENDPOINTS ====================

@router.get("", response_model=List[TaxationResponse])
@router.get("/", response_model=List[TaxationResponse])
def list_taxations(
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=1000),
    contribuable_id: Optional[int] = None,
    taxe_id: Optional[int] = None,
    statut: Optional[str] = None,
    annee: Optional[int] = None,
    mois: Optional[int] = None,
    en_retard: bool = False,
    actif: Optional[bool] = None,
    db: Session = Depends(get_db)
):
    """Récupère la liste des affectations de taxes (taxations) avec filtres"""
    
    query = db.query(AffectationTaxe)
    
    # Filtres
    if contribuable_id:
        query = query.filter(AffectationTaxe.contribuable_id == contribuable_id)
    if taxe_id:
        query = query.filter(AffectationTaxe.taxe_id == taxe_id)
    if actif is not None:
        query = query.filter(AffectationTaxe.actif == actif)
    
    # Récupérer tous les résultats
    affectations = query.offset(skip).limit(limit).all()
    
    # Formater chaque affectation avec calculs
    results = []
    for aff in affectations:
        response = format_taxation_response(aff, db)
        
        # Filtrer par statut
        if statut and response.statut != statut:
            continue
        
        # Filtrer par retard
        if en_retard and response.statut != "RETARD":
            continue
        
        # Filtrer par année (basé sur date_debut)
        if annee and aff.date_debut.year != annee:
            continue
        
        # Filtrer par mois
        if mois and aff.date_debut.month != mois:
            continue
        
        results.append(response)
    
    return results

@router.get("/{taxation_id}", response_model=TaxationResponse)
def get_taxation(
    taxation_id: int,
    db: Session = Depends(get_db)
):
    """Récupère une affectation de taxe spécifique"""
    
    affectation = db.query(AffectationTaxe).filter(
        AffectationTaxe.id == taxation_id
    ).first()
    
    if not affectation:
        raise HTTPException(status_code=404, detail="Taxation non trouvée")
    
    return format_taxation_response(affectation, db)

@router.post("", response_model=TaxationResponse)
def create_taxation(
    request: CreateTaxationRequest,
    db: Session = Depends(get_db)
):
    """Crée une nouvelle affectation de taxe"""
    
    # Vérifier que le contribuable existe
    contribuable = db.query(Contribuable).filter(
        Contribuable.id == request.contribuable_id
    ).first()
    if not contribuable:
        raise HTTPException(status_code=404, detail="Contribuable non trouvé")
    
    # Vérifier que la taxe existe
    taxe = db.query(Taxe).filter(Taxe.id == request.taxe_id).first()
    if not taxe:
        raise HTTPException(status_code=404, detail="Taxe non trouvée")
    
    # Vérifier qu'il n'existe pas déjà une affectation active
    existing = db.query(AffectationTaxe).filter(
        and_(
            AffectationTaxe.contribuable_id == request.contribuable_id,
            AffectationTaxe.taxe_id == request.taxe_id,
            AffectationTaxe.actif == True,
            or_(
                AffectationTaxe.date_fin == None,
                AffectationTaxe.date_fin > datetime.utcnow()
            )
        )
    ).first()
    
    if existing:
        raise HTTPException(
            status_code=400,
            detail="Cette taxe est déjà affectée à ce contribuable"
        )
    
    # Créer l'affectation
    affectation = AffectationTaxe(
        contribuable_id=request.contribuable_id,
        taxe_id=request.taxe_id,
        date_debut=request.date_debut,
        date_fin=request.date_fin,
        montant_custom=request.montant_custom,
        actif=request.actif
    )
    
    db.add(affectation)
    db.commit()
    db.refresh(affectation)
    
    return format_taxation_response(affectation, db)

@router.put("/{taxation_id}", response_model=TaxationResponse)
def update_taxation(
    taxation_id: int,
    request: UpdateTaxationRequest,
    db: Session = Depends(get_db)
):
    """Met à jour une affectation de taxe"""
    
    affectation = db.query(AffectationTaxe).filter(
        AffectationTaxe.id == taxation_id
    ).first()
    
    if not affectation:
        raise HTTPException(status_code=404, detail="Taxation non trouvée")
    
    # Mettre à jour les champs
    if request.date_fin is not None:
        affectation.date_fin = request.date_fin
    if request.montant_custom is not None:
        affectation.montant_custom = request.montant_custom
    if request.actif is not None:
        affectation.actif = request.actif
    
    affectation.updated_at = datetime.utcnow()
    db.commit()
    db.refresh(affectation)
    
    return format_taxation_response(affectation, db)

@router.delete("/{taxation_id}")
def delete_taxation(
    taxation_id: int,
    db: Session = Depends(get_db)
):
    """Supprime une affectation de taxe"""
    
    affectation = db.query(AffectationTaxe).filter(
        AffectationTaxe.id == taxation_id
    ).first()
    
    if not affectation:
        raise HTTPException(status_code=404, detail="Taxation non trouvée")
    
    db.delete(affectation)
    db.commit()
    
    return {"detail": "Taxation supprimée avec succès"}

@router.get("/stats/summary", response_model=TaxationStatsResponse)
def get_taxation_stats(
    db: Session = Depends(get_db)
):
    """Récupère les statistiques globales des taxations"""
    
    # Récupérer toutes les affectations actives
    affectations = db.query(AffectationTaxe).filter(
        AffectationTaxe.actif == True
    ).all()
    
    total_taxations = len(affectations)
    taxations_payees = 0
    taxations_partielles = 0
    taxations_impayees = 0
    taxations_retard = 0
    montant_attendu_total = Decimal("0.00")
    montant_paye_total = Decimal("0.00")
    
    for aff in affectations:
        montant_attendu, montant_paye, statut = calculate_taxation_stats(aff, db)
        
        montant_attendu_total += montant_attendu
        montant_paye_total += montant_paye
        
        if statut == "PAYE":
            taxations_payees += 1
        elif statut == "PARTIEL":
            taxations_partielles += 1
        elif statut == "RETARD":
            taxations_retard += 1
        else:  # IMPAYE
            taxations_impayees += 1
    
    montant_impaye_total = montant_attendu_total - montant_paye_total
    
    # Calculer le pourcentage de recouvrement
    pourcentage_recouvrement = 0.0
    if montant_attendu_total > 0:
        pourcentage_recouvrement = float(montant_paye_total / montant_attendu_total * 100)
    
    return TaxationStatsResponse(
        total_taxations=total_taxations,
        taxations_payees=taxations_payees,
        taxations_partielles=taxations_partielles,
        taxations_impayees=taxations_impayees,
        taxations_retard=taxations_retard,
        montant_attendu_total=montant_attendu_total,
        montant_paye_total=montant_paye_total,
        montant_impaye_total=montant_impaye_total,
        pourcentage_recouvrement=pourcentage_recouvrement
    )
