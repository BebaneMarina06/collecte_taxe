"""
Routes pour la gestion des demandes citoyens
VERSION COMPLÈTE CORRIGÉE
"""

from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session, joinedload
from typing import List, Optional
from database.database import get_db
from database.models import DemandeCitoyen, Contribuable, Utilisateur, StatutDemandeEnum
from schemas.demande_citoyen import (
    DemandeCitoyenCreate,
    DemandeCitoyenUpdate,
    DemandeCitoyenResponse,
    StatutDemandeEnum as StatutDemandeEnumSchema
)
from datetime import datetime
from auth.security import get_current_user_or_citoyen

router = APIRouter(
    prefix="/api/demandes",
    tags=["demandes-citoyens"],
    dependencies=[Depends(get_current_user_or_citoyen)],
)


@router.get("/", response_model=List[DemandeCitoyenResponse])
def get_demandes(
    contribuable_id: Optional[int] = Query(None, description="Filtrer par contribuable"),
    statut: Optional[StatutDemandeEnumSchema] = Query(None, description="Filtrer par statut"),
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=1000),
    db: Session = Depends(get_db)
):
    """Récupère la liste des demandes citoyens"""
    query = db.query(DemandeCitoyen).options(
        joinedload(DemandeCitoyen.contribuable),
        joinedload(DemandeCitoyen.traite_par)
    )
    
    if contribuable_id:
        query = query.filter(DemandeCitoyen.contribuable_id == contribuable_id)
    
    if statut:
        query = query.filter(DemandeCitoyen.statut == StatutDemandeEnum(statut.value))
    
    demandes = query.order_by(DemandeCitoyen.created_at.desc()).offset(skip).limit(limit).all()
    
    result = []
    for demande in demandes:
        demande_dict = {
            **demande.__dict__,
            "contribuable_nom": demande.contribuable.nom if demande.contribuable else None,
            "contribuable_prenom": demande.contribuable.prenom if demande.contribuable else None,
            "traite_par_nom": demande.traite_par.nom if demande.traite_par else None,
        }
        result.append(DemandeCitoyenResponse(**demande_dict))
    
    return result


@router.get("/{demande_id}", response_model=DemandeCitoyenResponse)
def get_demande(
    demande_id: int,
    db: Session = Depends(get_db)
):
    """Récupère une demande citoyen par son ID"""
    demande = db.query(DemandeCitoyen).options(
        joinedload(DemandeCitoyen.contribuable),
        joinedload(DemandeCitoyen.traite_par)
    ).filter(DemandeCitoyen.id == demande_id).first()
    
    if not demande:
        raise HTTPException(status_code=404, detail="Demande non trouvée")
    
    demande_dict = {
        **demande.__dict__,
        "contribuable_nom": demande.contribuable.nom if demande.contribuable else None,
        "contribuable_prenom": demande.contribuable.prenom if demande.contribuable else None,
        "traite_par_nom": demande.traite_par.nom if demande.traite_par else None,
    }
    return DemandeCitoyenResponse(**demande_dict)


@router.post("/", response_model=DemandeCitoyenResponse, status_code=201)
def create_demande(
    demande: DemandeCitoyenCreate,
    db: Session = Depends(get_db)
):
    """Crée une nouvelle demande citoyen"""
    # Vérifier que le contribuable existe
    contribuable = db.query(Contribuable).filter(Contribuable.id == demande.contribuable_id).first()
    if not contribuable:
        raise HTTPException(status_code=404, detail="Contribuable non trouvé")
    
    db_demande = DemandeCitoyen(
        contribuable_id=demande.contribuable_id,
        type_demande=demande.type_demande,
        sujet=demande.sujet,
        description=demande.description,
        pieces_jointes=demande.pieces_jointes,
        statut=StatutDemandeEnum.ENVOYEE
    )
    
    db.add(db_demande)
    db.commit()
    db.refresh(db_demande)
    
    # Recharger avec les relations
    db_demande = db.query(DemandeCitoyen).options(
        joinedload(DemandeCitoyen.contribuable),
        joinedload(DemandeCitoyen.traite_par)
    ).filter(DemandeCitoyen.id == db_demande.id).first()
    
    demande_dict = {
        **db_demande.__dict__,
        "contribuable_nom": db_demande.contribuable.nom if db_demande.contribuable else None,
        "contribuable_prenom": db_demande.contribuable.prenom if db_demande.contribuable else None,
        "traite_par_nom": db_demande.traite_par.nom if db_demande.traite_par else None,
    }
    return DemandeCitoyenResponse(**demande_dict)


@router.put("/{demande_id}", response_model=DemandeCitoyenResponse)
def update_demande(
    demande_id: int,
    demande_update: DemandeCitoyenUpdate,
    current_user = Depends(get_current_user_or_citoyen),
    db: Session = Depends(get_db)
):
    """Met à jour une demande citoyen (changement de statut, réponse, etc.)"""
    db_demande = db.query(DemandeCitoyen).filter(DemandeCitoyen.id == demande_id).first()
    if not db_demande:
        raise HTTPException(status_code=404, detail="Demande non trouvée")
    
    update_data = demande_update.dict(exclude_unset=True)
    
    # Gérer le statut
    if "statut" in update_data:
        try:
            update_data["statut"] = StatutDemandeEnum(update_data["statut"])
        except ValueError:
            raise HTTPException(status_code=400, detail="Statut invalide")
        
        # Si le statut change vers "en_traitement", "complete" ou "rejetee"
        if update_data["statut"] in [StatutDemandeEnum.EN_TRAITEMENT, StatutDemandeEnum.COMPLETE, StatutDemandeEnum.REJETEE]:
            if not db_demande.date_traitement:
                update_data["date_traitement"] = datetime.utcnow()
            # Vérifier si c'est un Utilisateur (et non un Contribuable)
            if not db_demande.traite_par_id and isinstance(current_user, Utilisateur):
                update_data["traite_par_id"] = current_user.id
    
    for field, value in update_data.items():
        setattr(db_demande, field, value)
    
    db_demande.updated_at = datetime.utcnow()
    db.commit()
    db.refresh(db_demande)
    
    # Recharger avec les relations
    db_demande = db.query(DemandeCitoyen).options(
        joinedload(DemandeCitoyen.contribuable),
        joinedload(DemandeCitoyen.traite_par)
    ).filter(DemandeCitoyen.id == demande_id).first()
    
    demande_dict = {
        **db_demande.__dict__,
        "contribuable_nom": db_demande.contribuable.nom if db_demande.contribuable else None,
        "contribuable_prenom": db_demande.contribuable.prenom if db_demande.contribuable else None,
        "traite_par_nom": db_demande.traite_par.nom if db_demande.traite_par else None,
    }
    return DemandeCitoyenResponse(**demande_dict)


@router.delete("/{demande_id}", status_code=204)
def delete_demande(
    demande_id: int,
    db: Session = Depends(get_db)
):
    """Supprime une demande citoyen"""
    db_demande = db.query(DemandeCitoyen).filter(DemandeCitoyen.id == demande_id).first()
    if not db_demande:
        raise HTTPException(status_code=404, detail="Demande non trouvée")
    
    db.delete(db_demande)
    db.commit()
    return None