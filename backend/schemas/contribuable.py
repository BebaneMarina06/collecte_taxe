"""
Schémas Pydantic pour les contribuables
"""

from pydantic import BaseModel, Field, EmailStr
from typing import Optional, List
from datetime import datetime
from decimal import Decimal
from schemas.type_contribuable import TypeContribuableBase
from schemas.quartier import QuartierBase
from schemas.collecteur import CollecteurBase


# ==================== SCHÉMAS POUR LES TAXES ====================
class TaxeSimpleResponse(BaseModel):
    """Taxe simple pour la réponse login"""
    id: int
    nom: str
    code: str
    description: Optional[str] = None
    montant: Decimal
    periodicite: str

    class Config:
        from_attributes = True


class AffectationTaxeResponse(BaseModel):
    """Affectation taxe avec détails de la taxe et du collecteur"""
    id: int
    taxe: TaxeSimpleResponse
    montant_custom: Optional[Decimal] = None  # Montant personnalisé si variable
    date_debut: datetime
    date_fin: Optional[datetime] = None
    actif: bool

    class Config:
        from_attributes = True


class ContribuableLoginResponse(BaseModel):
    """Réponse complète pour la connexion d'un contribuable"""
    id: int
    nom: str
    prenom: Optional[str] = None
    telephone: str
    email: Optional[str] = None
    adresse: Optional[str] = None
    matricule: Optional[str] = None
    type_contribuable: Optional[TypeContribuableBase] = None
    taxes: List[AffectationTaxeResponse] = []

    class Config:
        from_attributes = True


class ContribuableBase(BaseModel):
    nom: str = Field(..., max_length=100)
    prenom: Optional[str] = Field(None, max_length=100)
    email: Optional[EmailStr] = None
    telephone: str = Field(..., max_length=20)
    type_contribuable_id: int
    quartier_id: int
    collecteur_id: int
    adresse: Optional[str] = None
    latitude: Optional[Decimal] = None
    longitude: Optional[Decimal] = None
    nom_activite: Optional[str] = Field(None, max_length=200)
    photo_url: Optional[str] = Field(None, max_length=500)
    numero_identification: Optional[str] = None
    qr_code: Optional[str] = Field(None, max_length=100)
    actif: bool = True


class ContribuableCreate(ContribuableBase):
    taxes_ids: Optional[List[int]] = Field(default=None, description="Liste des IDs des taxes à attribuer au contribuable")


class ContribuableUpdate(BaseModel):
    nom: Optional[str] = None
    prenom: Optional[str] = None
    email: Optional[EmailStr] = None
    telephone: Optional[str] = None
    type_contribuable_id: Optional[int] = None
    quartier_id: Optional[int] = None
    collecteur_id: Optional[int] = None
    adresse: Optional[str] = None
    latitude: Optional[Decimal] = None
    longitude: Optional[Decimal] = None
    nom_activite: Optional[str] = None
    photo_url: Optional[str] = None
    numero_identification: Optional[str] = None
    qr_code: Optional[str] = None
    actif: Optional[bool] = None


class ContribuableResponse(ContribuableBase):
    id: int
    type_contribuable: Optional[TypeContribuableBase] = None
    quartier: Optional[QuartierBase] = None
    collecteur: Optional[CollecteurBase] = None
    distance_quartier_m: Optional[Decimal] = None
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True


class ContribuablesListResponse(BaseModel):
    """Réponse avec pagination pour la liste des contribuables"""
    items: List[ContribuableResponse]
    total: int
    skip: int
    limit: int
