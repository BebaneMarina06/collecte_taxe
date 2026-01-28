"""
Sécurité et authentification JWT - VERSION CORRIGÉE
Ajout de get_current_collecteur_id pour résoudre le problème de lien utilisateur/collecteur
"""

from datetime import datetime, timedelta
from typing import Optional, Union
from jose import JWTError, jwt
import bcrypt
from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from sqlalchemy.orm import Session
from database.database import get_db
from database.models import Utilisateur, Contribuable, Collecteur

# Configuration JWT
import os
SECRET_KEY = os.getenv("SECRET_KEY", "votre-secret-key-tres-securisee-changez-moi-en-production")
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30 * 24 * 60  # 30 jours

# OAuth2 scheme
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/api/auth/login")


def verify_password(plain_password: str, hashed_password: str) -> bool:
    """Vérifie un mot de passe en utilisant bcrypt directement"""
    try:
        password_bytes = plain_password.encode('utf-8')
        hash_bytes = hashed_password.encode('utf-8')
        return bcrypt.checkpw(password_bytes, hash_bytes)
    except Exception as e:
        print(f"Erreur lors de la vérification du mot de passe: {e}")
        return False


def get_password_hash(password: str) -> str:
    """Hash un mot de passe en utilisant bcrypt directement"""
    password_bytes = password.encode('utf-8')
    salt = bcrypt.gensalt(rounds=12)
    hashed = bcrypt.hashpw(password_bytes, salt)
    return hashed.decode('utf-8')


def create_access_token(data: dict, expires_delta: Optional[timedelta] = None):
    """Crée un token JWT"""
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt


def verify_token(token: str, credentials_exception):
    """Vérifie et décode un token JWT"""
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        user_id_str: str = payload.get("sub")
        if user_id_str is None:
            raise credentials_exception
        user_id: int = int(user_id_str)
        return user_id
    except (JWTError, ValueError):
        raise credentials_exception


async def get_current_user(
    token: str = Depends(oauth2_scheme),
    db: Session = Depends(get_db)
):
    """Récupère l'utilisateur actuel depuis le token"""
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Impossible de valider les identifiants",
        headers={"WWW-Authenticate": "Bearer"},
    )
    
    user_id = verify_token(token, credentials_exception)
    user = db.query(Utilisateur).filter(Utilisateur.id == user_id).first()
    
    if user is None:
        raise credentials_exception
    
    if not user.actif:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Utilisateur désactivé"
        )
    
    return user


async def get_current_active_user(
    current_user: Utilisateur = Depends(get_current_user)
):
    """Vérifie que l'utilisateur est actif"""
    if not current_user.actif:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Utilisateur inactif"
        )
    return current_user


def require_role(allowed_roles: list):
    """Décorateur pour vérifier les rôles"""
    async def role_checker(current_user: Utilisateur = Depends(get_current_active_user)):
        if current_user.role not in allowed_roles:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Permissions insuffisantes"
            )
        return current_user
    return role_checker


# ==================== NOUVEAU: RÉCUPÉRATION DU COLLECTEUR ====================

async def get_current_collecteur(
    current_user: Utilisateur = Depends(get_current_active_user),
    db: Session = Depends(get_db)
) -> Collecteur:
    """
    Récupère le collecteur associé à l'utilisateur connecté.
    Utilise utilisateur_id en priorité, sinon fallback sur l'email.
    """
    # Méthode 1: Via utilisateur_id (préféré)
    collecteur = db.query(Collecteur).filter(
        Collecteur.utilisateur_id == current_user.id
    ).first()
    
    if collecteur:
        return collecteur
    
    # Méthode 2 (fallback): Via l'email
    collecteur = db.query(Collecteur).filter(
        Collecteur.email == current_user.email
    ).first()
    
    if not collecteur:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Aucun collecteur associé à l'utilisateur {current_user.email}. "
                   f"Veuillez contacter l'administrateur."
        )
    
    # Créer automatiquement le lien s'il n'existe pas
    if collecteur.utilisateur_id is None:
        print(f"⚠️ Création automatique du lien: utilisateur {current_user.id} -> collecteur {collecteur.id}")
        collecteur.utilisateur_id = current_user.id
        db.commit()
        db.refresh(collecteur)
    
    return collecteur


async def get_current_collecteur_id(
    collecteur: Collecteur = Depends(get_current_collecteur)
) -> int:
    """
    Récupère l'ID du collecteur associé à l'utilisateur connecté.
    À utiliser dans les routes qui nécessitent un collecteur_id.
    
    Exemple d'utilisation:
        @router.post("/collectes")
        def create_collecte(
            collecteur_id: int = Depends(get_current_collecteur_id),
            db: Session = Depends(get_db)
        ):
            # collecteur_id est maintenant le bon ID de la table collecteur
            ...
    """
    return collecteur.id


# ==================== AUTHENTIFICATION CITOYENS ====================

async def get_current_citoyen(
    token: str = Depends(oauth2_scheme),
    db: Session = Depends(get_db)
):
    """
    Récupère le contribuable connecté à partir du JWT.
    Utilisé pour les routes du portail citoyen.
    """
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Impossible de valider les identifiants",
        headers={"WWW-Authenticate": "Bearer"},
    )
    
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        user_id_str: str = payload.get("sub")
        role: str = payload.get("role")
        
        if user_id_str is None:
            raise credentials_exception
        
        # Vérifier que c'est bien un citoyen
        if role != "citoyen":
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Accès réservé aux citoyens"
            )
        
        user_id: int = int(user_id_str)
    except (JWTError, ValueError):
        raise credentials_exception
    
    # Chercher dans la table Contribuable
    contribuable = db.query(Contribuable).filter(Contribuable.id == user_id).first()
    
    if contribuable is None:
        raise credentials_exception
    
    if not contribuable.actif:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Compte désactivé"
        )
    
    return contribuable


async def get_current_active_citoyen(
    current_citoyen: Contribuable = Depends(get_current_citoyen)
):
    """Vérifie que le contribuable est actif"""
    if not current_citoyen.actif:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Compte inactif"
        )
    return current_citoyen


async def get_current_user_or_citoyen(
    token: str = Depends(oauth2_scheme),
    db: Session = Depends(get_db)
) -> Union[Utilisateur, Contribuable]:
    """
    Récupère soit un utilisateur administratif soit un contribuable.
    Utilisé pour les routes accessibles aux deux types d'utilisateurs.
    """
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Impossible de valider les identifiants",
        headers={"WWW-Authenticate": "Bearer"},
    )
    
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        user_id_str: str = payload.get("sub")
        role: str = payload.get("role")
        
        if user_id_str is None:
            raise credentials_exception
        
        user_id: int = int(user_id_str)
        
        # Si c'est un citoyen, chercher dans Contribuable
        if role == "citoyen":
            contribuable = db.query(Contribuable).filter(Contribuable.id == user_id).first()
            if contribuable is None:
                raise credentials_exception
            if not contribuable.actif:
                raise HTTPException(
                    status_code=status.HTTP_403_FORBIDDEN,
                    detail="Compte désactivé"
                )
            return contribuable
        
        # Sinon, chercher dans Utilisateur
        else:
            utilisateur = db.query(Utilisateur).filter(Utilisateur.id == user_id).first()
            if utilisateur is None:
                raise credentials_exception
            if not utilisateur.actif:
                raise HTTPException(
                    status_code=status.HTTP_403_FORBIDDEN,
                    detail="Utilisateur désactivé"
                )
            return utilisateur
            
    except (JWTError, ValueError):
        raise credentials_exception