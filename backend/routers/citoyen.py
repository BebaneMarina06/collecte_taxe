"""
Routes pour l'authentification et les services citoyens
"""

from fastapi import APIRouter, Depends, HTTPException, status, Query
from fastapi.security import OAuth2PasswordRequestForm
from sqlalchemy.orm import Session, joinedload
from sqlalchemy import func
from datetime import datetime, timedelta
from typing import List, Optional
from database.database import get_db
from database.models import Contribuable, AffectationTaxe, Taxe, OtpCitoyen, DemandeCitoyen, StatutDemandeEnum
from auth.security import verify_password, create_access_token, ACCESS_TOKEN_EXPIRE_MINUTES, get_password_hash
from auth.schemas import OtpRequest, OtpVerify
from pydantic import BaseModel, EmailStr
import random
import os
import smtplib
from email.message import EmailMessage
import logging

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/api/citoyen", tags=["citoyen"])


# Schémas pour les requêtes de login
class LoginEmailRequest(BaseModel):
    email: EmailStr
    password: str

class LoginPhoneRequest(BaseModel):
    telephone: str
    password: str


@router.post("/login")
def login_citoyen(
    login_data: LoginPhoneRequest,
    db: Session = Depends(get_db)
):
    """
    Authentification d'un citoyen (contribuable) par téléphone et mot de passe
    """
    # Chercher le contribuable par téléphone avec son type
    contribuable = db.query(Contribuable).options(
        joinedload(Contribuable.type_contribuable)
    ).filter(
        Contribuable.telephone == login_data.telephone
    ).first()
    
    if not contribuable:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Téléphone ou mot de passe incorrect",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    # Vérifier le mot de passe
    if not contribuable.mot_de_passe_hash:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Compte non configuré. Veuillez contacter la mairie pour activer votre compte.",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    if not verify_password(login_data.password, contribuable.mot_de_passe_hash):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Téléphone ou mot de passe incorrect",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    if not contribuable.actif:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Compte désactivé"
        )
    
    # Créer le token
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={"sub": str(contribuable.id), "telephone": contribuable.telephone, "role": "citoyen"},
        expires_delta=access_token_expires
    )
    
    return {
        "access_token": access_token,
        "token_type": "bearer",
        "contribuable": {
            "id": contribuable.id,
            "nom": contribuable.nom,
            "prenom": contribuable.prenom,
            "telephone": contribuable.telephone,
            "email": contribuable.email,
            "adresse": contribuable.adresse,
            "matricule": contribuable.matricule,
            "type_contribuable": {
                "id": contribuable.type_contribuable.id,
                "nom": contribuable.type_contribuable.nom,
                "code": contribuable.type_contribuable.code
            } if contribuable.type_contribuable else None
        }
    }


@router.post("/login-email")
def login_citoyen_email(
    login_data: LoginEmailRequest,
    db: Session = Depends(get_db)
):
    """
    Authentification d'un citoyen par email et mot de passe
    """
    # Chercher le contribuable par email avec son type
    contribuable = db.query(Contribuable).options(
        joinedload(Contribuable.type_contribuable)
    ).filter(
        Contribuable.email == login_data.email
    ).first()
    
    if not contribuable:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Email ou mot de passe incorrect",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    # Vérifier le mot de passe
    if not contribuable.mot_de_passe_hash:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Compte non configuré. Veuillez contacter la mairie pour activer votre compte.",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    if not verify_password(login_data.password, contribuable.mot_de_passe_hash):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Email ou mot de passe incorrect",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    if not contribuable.actif:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Compte désactivé"
        )
    
    # Créer le token
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={"sub": str(contribuable.id), "email": contribuable.email, "role": "citoyen"},
        expires_delta=access_token_expires
    )
    
    return {
        "access_token": access_token,
        "token_type": "bearer",
        "contribuable": {
            "id": contribuable.id,
            "nom": contribuable.nom,
            "prenom": contribuable.prenom,
            "telephone": contribuable.telephone,
            "email": contribuable.email,
            "adresse": contribuable.adresse,
            "matricule": contribuable.matricule,
            "type_contribuable": {
                "id": contribuable.type_contribuable.id,
                "nom": contribuable.type_contribuable.nom,
                "code": contribuable.type_contribuable.code
            } if contribuable.type_contribuable else None
        }
    }


def send_email_otp(email: str, code: str):
    """
    Envoie un OTP par email via SMTP simple.
    """
    smtp_host = os.getenv("SMTP_HOST")
    smtp_port = int(os.getenv("SMTP_PORT", "587"))
    smtp_user = os.getenv("SMTP_USER")
    smtp_password = os.getenv("SMTP_PASSWORD")
    smtp_from = os.getenv("SMTP_FROM", smtp_user)

    if not smtp_host or not smtp_user or not smtp_password:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Configuration SMTP manquante pour l'envoi d'OTP."
        )

    msg = EmailMessage()
    msg["Subject"] = "Code de connexion - Portail citoyen"
    msg["From"] = smtp_from
    msg["To"] = email
    msg.set_content(
        f"Bonjour,\n\nVoici votre code de connexion : {code}\nIl expire dans 10 minutes.\n\nMairie de Libreville"
    )

    try:
        with smtplib.SMTP(smtp_host, smtp_port) as server:
            server.starttls()
            server.login(smtp_user, smtp_password)
            server.send_message(msg)
    except Exception as exc:
        logger.exception("Erreur lors de l'envoi de l'OTP par email")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Impossible d'envoyer l'OTP par email."
        ) from exc


@router.post("/otp/request", status_code=204)
def request_otp(payload: OtpRequest, db: Session = Depends(get_db)):
    """
    Génère et envoie un OTP par email pour un contribuable.
    """
    contribuable = db.query(Contribuable).filter(
        Contribuable.email == payload.email,
        Contribuable.actif == True
    ).first()

    if not contribuable:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Contribuable introuvable ou inactif."
        )

    # Nettoyer les anciens OTP expirés
    db.query(OtpCitoyen).filter(
        OtpCitoyen.contribuable_id == contribuable.id,
        OtpCitoyen.expires_at < datetime.utcnow()
    ).delete()

    code = f"{random.randint(0, 999999):06d}"
    code_hash = get_password_hash(code)
    expires_at = datetime.utcnow() + timedelta(minutes=10)

    otp_entry = OtpCitoyen(
        contribuable_id=contribuable.id,
        code_hash=code_hash,
        expires_at=expires_at,
        channel="email",
        used=False
    )
    db.add(otp_entry)
    db.commit()

    send_email_otp(contribuable.email, code)

    return None


@router.post("/otp/verify")
def verify_otp(payload: OtpVerify, db: Session = Depends(get_db)):
    """
    Vérifie un OTP et retourne un JWT pour le portail citoyen.
    """
    contribuable = db.query(Contribuable).options(
        joinedload(Contribuable.type_contribuable)
    ).filter(
        Contribuable.email == payload.email,
        Contribuable.actif == True
    ).first()

    if not contribuable:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Contribuable introuvable ou inactif."
        )

    otp = db.query(OtpCitoyen).filter(
        OtpCitoyen.contribuable_id == contribuable.id,
        OtpCitoyen.used == False,
        OtpCitoyen.expires_at >= datetime.utcnow()
    ).order_by(OtpCitoyen.created_at.desc()).first()

    if not otp or not verify_password(payload.code, otp.code_hash):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Code OTP invalide ou expiré."
        )

    otp.used = True
    db.commit()

    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={"sub": str(contribuable.id), "email": contribuable.email, "role": "citoyen"},
        expires_delta=access_token_expires
    )

    return {
        "access_token": access_token,
        "token_type": "bearer",
        "contribuable": {
            "id": contribuable.id,
            "nom": contribuable.nom,
            "prenom": contribuable.prenom,
            "telephone": contribuable.telephone,
            "email": contribuable.email,
            "adresse": contribuable.adresse,
            "matricule": contribuable.matricule,
            "type_contribuable": {
                "id": contribuable.type_contribuable.id,
                "nom": contribuable.type_contribuable.nom,
                "code": contribuable.type_contribuable.code
            } if contribuable.type_contribuable else None
        }
    }


@router.get("/taxes", response_model=List[dict])
def get_taxes_contribuable(
    contribuable_id: int = Query(..., description="ID du contribuable"),
    db: Session = Depends(get_db)
):
    """
    Récupère toutes les taxes affectées à un contribuable avec leur statut
    """
    affectations = db.query(AffectationTaxe).filter(
        AffectationTaxe.contribuable_id == contribuable_id
    ).all()
    
    result = []
    for affectation in affectations:
        taxe = db.query(Taxe).filter(Taxe.id == affectation.taxe_id).first()
        if not taxe:
            continue
        
        # Calculer le montant dû
        montant_du = affectation.montant_custom if affectation.montant_custom else taxe.montant
        
        # Calculer le montant payé (somme des collectes complétées)
        from database.models import InfoCollecte, StatutCollecteEnum
        montant_paye = db.query(func.coalesce(func.sum(InfoCollecte.montant), 0)).filter(
            InfoCollecte.contribuable_id == contribuable_id,
            InfoCollecte.taxe_id == taxe.id,
            InfoCollecte.statut == StatutCollecteEnum.COMPLETED,
            InfoCollecte.annule == False
        ).scalar() or 0
        
        # Déterminer le statut
        if montant_paye >= montant_du:
            statut = "a_jour"
        elif montant_paye > 0:
            statut = "partiellement_paye"
        else:
            statut = "en_retard" if affectation.date_fin and datetime.utcnow().date() > affectation.date_fin else "a_jour"
        
        result.append({
            "id": affectation.id,
            "taxe": {
                "id": taxe.id,
                "nom": taxe.nom,
                "description": taxe.description,
                "montant": float(taxe.montant),
                "periodicite": taxe.periodicite,
                "service": taxe.service.nom if taxe.service else None
            },
            "date_debut": affectation.date_debut.isoformat() if affectation.date_debut else None,
            "date_fin": affectation.date_fin.isoformat() if affectation.date_fin else None,
            "montant_custom": float(affectation.montant_custom) if affectation.montant_custom else None,
            "montant_du": float(montant_du),
            "montant_paye": float(montant_paye),
            "echeance": affectation.date_fin.isoformat() if affectation.date_fin else None,
            "statut": statut
        })
    
    return result


@router.get("/demandes", response_model=List[dict])
def get_demandes_citoyen(
    contribuable_id: int = Query(..., description="ID du contribuable"),
    db: Session = Depends(get_db)
):
    """
    Récupère toutes les demandes d'un citoyen
    """
    demandes = db.query(DemandeCitoyen).filter(
        DemandeCitoyen.contribuable_id == contribuable_id
    ).order_by(DemandeCitoyen.created_at.desc()).all()
    
    result = []
    for demande in demandes:
        result.append({
            "id": demande.id,
            "type_demande": demande.type_demande,
            "sujet": demande.sujet,
            "description": demande.description,
            "statut": demande.statut.value if demande.statut else None,
            "reponse": demande.reponse,
            "pieces_jointes": demande.pieces_jointes,
            "date_traitement": demande.date_traitement.isoformat() if demande.date_traitement else None,
            "created_at": demande.created_at.isoformat() if demande.created_at else None,
            "updated_at": demande.updated_at.isoformat() if demande.updated_at else None
        })
    
    return result


@router.get("/demandes/{demande_id}", response_model=dict)
def get_demande_citoyen(
    demande_id: int,
    contribuable_id: int = Query(..., description="ID du contribuable"),
    db: Session = Depends(get_db)
):
    """
    Récupère une demande spécifique d'un citoyen
    """
    demande = db.query(DemandeCitoyen).filter(
        DemandeCitoyen.id == demande_id,
        DemandeCitoyen.contribuable_id == contribuable_id
    ).first()
    
    if not demande:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Demande non trouvée"
        )
    
    return {
        "id": demande.id,
        "type_demande": demande.type_demande,
        "sujet": demande.sujet,
        "description": demande.description,
        "statut": demande.statut.value if demande.statut else None,
        "reponse": demande.reponse,
        "pieces_jointes": demande.pieces_jointes,
        "date_traitement": demande.date_traitement.isoformat() if demande.date_traitement else None,
        "created_at": demande.created_at.isoformat() if demande.created_at else None,
        "updated_at": demande.updated_at.isoformat() if demande.updated_at else None
    }


@router.post("/demandes", response_model=dict, status_code=201)
def create_demande_citoyen(
    demande: dict,
    db: Session = Depends(get_db)
):
    """
    Crée une nouvelle demande pour un citoyen
    """
    # Vérifier que le contribuable existe
    contribuable = db.query(Contribuable).filter(
        Contribuable.id == demande.get("contribuable_id")
    ).first()
    
    if not contribuable:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Contribuable non trouvé"
        )
    
    db_demande = DemandeCitoyen(
        contribuable_id=demande.get("contribuable_id"),
        type_demande=demande.get("type_demande"),
        sujet=demande.get("sujet"),
        description=demande.get("description"),
        pieces_jointes=demande.get("pieces_jointes"),
        statut=StatutDemandeEnum.ENVOYEE
    )
    
    db.add(db_demande)
    db.commit()
    db.refresh(db_demande)
    
    return {
        "id": db_demande.id,
        "type_demande": db_demande.type_demande,
        "sujet": db_demande.sujet,
        "description": db_demande.description,
        "statut": db_demande.statut.value if db_demande.statut else None,
        "pieces_jointes": db_demande.pieces_jointes,
        "created_at": db_demande.created_at.isoformat() if db_demande.created_at else None
    }