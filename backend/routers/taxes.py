"""
Routes pour la gestion des taxes
"""

from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from sqlalchemy import func
from typing import List, Optional
from database.database import get_db
from database.models import Taxe, AffectationTaxe, InfoCollecte, Contribuable, StatutCollecteEnum
from schemas.taxe import TaxeCreate, TaxeUpdate, TaxeResponse
from datetime import datetime
from decimal import Decimal
from auth.security import get_current_active_user

router = APIRouter(
    prefix="/api/taxes",
    tags=["taxes"],
    dependencies=[Depends(get_current_active_user)],
)


@router.get("/", response_model=List[TaxeResponse])
def get_taxes(
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=1000),
    actif: Optional[bool] = None,
    type_taxe_id: Optional[int] = None,
    service_id: Optional[int] = None,
    db: Session = Depends(get_db)
):
    """Récupère la liste des taxes avec filtres"""
    query = db.query(Taxe)
    
    if actif is not None:
        query = query.filter(Taxe.actif == actif)
    if type_taxe_id:
        query = query.filter(Taxe.type_taxe_id == type_taxe_id)
    if service_id:
        query = query.filter(Taxe.service_id == service_id)
    
    taxes = query.offset(skip).limit(limit).all()
    return taxes


@router.get("/{taxe_id}", response_model=TaxeResponse)
def get_taxe(taxe_id: int, db: Session = Depends(get_db)):
    """Récupère une taxe par son ID"""
    taxe = db.query(Taxe).filter(Taxe.id == taxe_id).first()
    if not taxe:
        raise HTTPException(status_code=404, detail="Taxe non trouvée")
    return taxe


@router.post("/", response_model=TaxeResponse, status_code=201)
def create_taxe(taxe: TaxeCreate, db: Session = Depends(get_db)):
    """Crée une nouvelle taxe"""
    # Vérifier si le code existe déjà
    existing = db.query(Taxe).filter(Taxe.code == taxe.code).first()
    if existing:
        raise HTTPException(status_code=400, detail="Une taxe avec ce code existe déjà")
    
    db_taxe = Taxe(**taxe.dict())
    db.add(db_taxe)
    db.commit()
    db.refresh(db_taxe)
    return db_taxe


@router.put("/{taxe_id}", response_model=TaxeResponse)
def update_taxe(taxe_id: int, taxe_update: TaxeUpdate, db: Session = Depends(get_db)):
    """Met à jour une taxe"""
    db_taxe = db.query(Taxe).filter(Taxe.id == taxe_id).first()
    if not db_taxe:
        raise HTTPException(status_code=404, detail="Taxe non trouvée")
    
    update_data = taxe_update.dict(exclude_unset=True)
    for field, value in update_data.items():
        setattr(db_taxe, field, value)
    
    db_taxe.updated_at = datetime.utcnow()
    db.commit()
    db.refresh(db_taxe)
    return db_taxe


@router.delete("/{taxe_id}", status_code=204)
def delete_taxe(taxe_id: int, db: Session = Depends(get_db)):
    """Supprime une taxe (soft delete)"""
    db_taxe = db.query(Taxe).filter(Taxe.id == taxe_id).first()
    if not db_taxe:
        raise HTTPException(status_code=404, detail="Taxe non trouvée")
    
    db_taxe.actif = False
    db_taxe.updated_at = datetime.utcnow()
    db.commit()
    return None


@router.get("/statistiques/paiements", response_model=dict)
def get_statistiques_paiements(
    db: Session = Depends(get_db)
):
    """
    Récupère les statistiques de paiement des taxes :
    - Montant espéré (quantité due en fonction du nombre de contribuables)
    - Montant collecté
    - Montant restant dû
    """
    # Calculer le montant total espéré (somme de toutes les taxes dues par tous les contribuables actifs)
    affectations_actives = db.query(AffectationTaxe).filter(
        AffectationTaxe.actif == True,
        AffectationTaxe.date_debut <= datetime.utcnow(),
        (
            (AffectationTaxe.date_fin.is_(None)) |
            (AffectationTaxe.date_fin >= datetime.utcnow())
        )
    ).all()
    
    montant_espere = Decimal("0")
    nombre_contribuables_avec_taxes = 0
    
    for affectation in affectations_actives:
        # Utiliser montant_custom si disponible, sinon montant de la taxe
        montant_taxe = affectation.montant_custom if affectation.montant_custom else affectation.taxe.montant
        montant_espere += montant_taxe
        nombre_contribuables_avec_taxes += 1
    
    # Calculer le montant total collecté (somme de toutes les collectes validées)
    montant_collecte = db.query(func.sum(InfoCollecte.montant)).filter(
        InfoCollecte.statut == StatutCollecteEnum.COMPLETED,
        InfoCollecte.annule == False
    ).scalar() or Decimal("0")
    
    # Calculer le montant restant dû
    montant_restant_du = max(montant_espere - montant_collecte, Decimal("0"))
    
    # Statistiques par taxe
    stats_par_taxe = []
    taxes_actives = db.query(Taxe).filter(Taxe.actif == True).all()
    
    for taxe in taxes_actives:
        # Nombre de contribuables avec cette taxe
        nb_contribuables = db.query(AffectationTaxe).filter(
            AffectationTaxe.taxe_id == taxe.id,
            AffectationTaxe.actif == True,
            AffectationTaxe.date_debut <= datetime.utcnow(),
            (
                (AffectationTaxe.date_fin.is_(None)) |
                (AffectationTaxe.date_fin >= datetime.utcnow())
            )
        ).count()
        
        # Montant espéré pour cette taxe
        montant_espere_taxe = Decimal("0")
        affectations_taxe = db.query(AffectationTaxe).filter(
            AffectationTaxe.taxe_id == taxe.id,
            AffectationTaxe.actif == True,
            AffectationTaxe.date_debut <= datetime.utcnow(),
            (
                (AffectationTaxe.date_fin.is_(None)) |
                (AffectationTaxe.date_fin >= datetime.utcnow())
            )
        ).all()
        
        for aff in affectations_taxe:
            montant = aff.montant_custom if aff.montant_custom else taxe.montant
            montant_espere_taxe += montant
        
        # Montant collecté pour cette taxe
        montant_collecte_taxe = db.query(func.sum(InfoCollecte.montant)).filter(
            InfoCollecte.taxe_id == taxe.id,
            InfoCollecte.statut == StatutCollecteEnum.COMPLETED,
            InfoCollecte.annule == False
        ).scalar() or Decimal("0")
        
        # Montant restant dû pour cette taxe
        montant_restant_du_taxe = max(montant_espere_taxe - montant_collecte_taxe, Decimal("0"))
        
        stats_par_taxe.append({
            "taxe_id": taxe.id,
            "taxe_nom": taxe.nom,
            "nombre_contribuables": nb_contribuables,
            "montant_espere": float(montant_espere_taxe),
            "montant_collecte": float(montant_collecte_taxe),
            "montant_restant_du": float(montant_restant_du_taxe),
            "taux_collecte": float((montant_collecte_taxe / montant_espere_taxe * 100) if montant_espere_taxe > 0 else 0)
        })
    
    return {
        "global": {
            "montant_espere": float(montant_espere),
            "montant_collecte": float(montant_collecte),
            "montant_restant_du": float(montant_restant_du),
            "taux_collecte": float((montant_collecte / montant_espere * 100) if montant_espere > 0 else 0),
            "nombre_contribuables_avec_taxes": nombre_contribuables_avec_taxes
        },
        "par_taxe": stats_par_taxe
    }

