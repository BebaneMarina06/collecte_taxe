"""
Schémas Pydantic pour les collecteurs
"""

from pydantic import BaseModel, Field, EmailStr
from typing import Optional, Dict, Any
from datetime import datetime


class CollecteurBase(BaseModel):
    nom: str = Field(..., max_length=100)
    prenom: str = Field(..., max_length=100)
    email: EmailStr
    telephone: str = Field(..., max_length=20)
    matricule: str = Field(..., max_length=50)
    zone_id: Optional[int] = None
    latitude: Optional[float] = None
    longitude: Optional[float] = None
    heure_cloture: Optional[str] = Field(None, pattern=r'^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$')
    
    class Config:
        from_attributes = True


class CollecteurCreate(CollecteurBase):
    pass


class CollecteurUpdate(BaseModel):
    nom: Optional[str] = None
    prenom: Optional[str] = None
    email: Optional[EmailStr] = None
    telephone: Optional[str] = None
    zone_id: Optional[int] = None
    latitude: Optional[float] = None
    longitude: Optional[float] = None
    heure_cloture: Optional[str] = None
    statut: Optional[str] = None  # "active", "desactive"
    actif: Optional[bool] = None


class CollecteurResponse(CollecteurBase):
    id: int
    statut: str
    etat: str
    date_derniere_connexion: Optional[datetime] = None
    date_derniere_deconnexion: Optional[datetime] = None
    actif: bool
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True


class AppareilCollecteurBase(BaseModel):
    device_id: str = Field(..., max_length=255, description="Identifiant unique de l'appareil")
    plateforme: Optional[str] = Field(None, max_length=50, description="Plateforme: android, ios, web, etc.")


class AppareilCollecteurCreate(AppareilCollecteurBase):
    # On accepte des champs supplémentaires venant du mobile (infos appareil)
    info: Dict[str, Any] = Field(default_factory=dict, description="Informations détaillées sur l'appareil")

    class Config:
        extra = "allow"


class AppareilCollecteurResponse(AppareilCollecteurBase):
    id: int
    authorized: bool
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True

