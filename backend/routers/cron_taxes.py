"""
Routes pour déclencher manuellement les tâches CRON de génération de dettes
"""

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from database.database import get_db
from database.models import PeriodiciteEnum
from services.cron_taxes import generer_dettes_mensuelles, generer_dettes_pour_periodicite
from auth.security import get_current_active_user

router = APIRouter(
    prefix="/api/cron",
    tags=["cron"],
    dependencies=[Depends(get_current_active_user)],
)


@router.post("/generer-dettes-mensuelles", response_model=dict)
def declencher_generation_dettes_mensuelles(
    db: Session = Depends(get_db)
):
    """
    Déclenche manuellement la génération mensuelle des dettes de taxe.
    Normalement, cette tâche est exécutée automatiquement via un scheduler.
    """
    try:
        resultat = generer_dettes_mensuelles(db)
        return resultat
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Erreur lors de la génération des dettes: {str(e)}")


@router.post("/generer-dettes/{periodicite}", response_model=dict)
def declencher_generation_dettes_periodicite(
    periodicite: str,
    db: Session = Depends(get_db)
):
    """
    Déclenche manuellement la génération des dettes pour une périodicité spécifique.
    Périodicités disponibles: mensuelle, hebdomadaire, trimestrielle, journaliere
    """
    try:
        # Convertir la chaîne en enum
        periodicite_enum = PeriodiciteEnum(periodicite.lower())
        resultat = generer_dettes_pour_periodicite(db, periodicite_enum)
        return resultat
    except ValueError:
        raise HTTPException(status_code=400, detail=f"Périodicité invalide: {periodicite}")
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Erreur lors de la génération des dettes: {str(e)}")

