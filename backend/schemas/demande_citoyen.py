"""
Schémas Pydantic pour les demandes citoyens
"""

from pydantic import BaseModel, Field
from typing import Optional, List
from datetime import datetime
from enum import Enum


class StatutDemandeEnum(str, Enum):
    """Statut d'une demande citoyen"""
    ENVOYEE = "envoyee"
    EN_TRAITEMENT = "en_traitement"
    COMPLETE = "complete"
    REJETEE = "rejetee"


class DemandeCitoyenBase(BaseModel):
    """Schéma de base pour une demande citoyen"""
    type_demande: str = Field(..., description="Type de demande")
    sujet: str = Field(..., description="Sujet de la demande")
    description: str = Field(..., description="Description détaillée")
    pieces_jointes: Optional[List[str]] = Field(None, description="URLs des pièces jointes")


class DemandeCitoyenCreate(DemandeCitoyenBase):
    """Schéma pour créer une demande citoyen"""
    contribuable_id: int = Field(..., description="ID du contribuable")


class DemandeCitoyenUpdate(BaseModel):
    """Schéma pour mettre à jour une demande citoyen"""
    statut: Optional[StatutDemandeEnum] = None
    reponse: Optional[str] = None
    
    class Config:
        use_enum_values = True


class DemandeCitoyenResponse(DemandeCitoyenBase):
    """Schéma de réponse pour une demande citoyen"""
    id: int
    contribuable_id: int
    statut: StatutDemandeEnum
    reponse: Optional[str] = None
    traite_par_id: Optional[int] = None
    date_traitement: Optional[datetime] = None
    created_at: datetime
    updated_at: Optional[datetime] = None
    
    # Champs relationnels
    contribuable_nom: Optional[str] = None
    contribuable_prenom: Optional[str] = None
    traite_par_nom: Optional[str] = None
    
    class Config:
        from_attributes = True  # Pour SQLAlchemy 2.0+ (anciennement orm_mode = True)
        use_enum_values = True