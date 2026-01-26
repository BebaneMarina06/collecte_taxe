"""
Routes pour les services de la mairie
"""

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from database.database import get_db
from database.models import Service

router = APIRouter(prefix="/api/services", tags=["services"])


@router.get("/", response_model=List[dict])
def get_services(
    db: Session = Depends(get_db)
):
    """
    Récupère la liste de tous les services de la mairie
    """
    services = db.query(Service).filter(Service.actif == True).order_by(Service.nom).all()
    
    return [
        {
            "id": service.id,
            "nom": service.nom,
            "description": service.description or "",
            "icone": None,  # À ajouter si nécessaire dans le modèle
            "couleur": None  # À ajouter si nécessaire dans le modèle
        }
        for service in services
    ]

