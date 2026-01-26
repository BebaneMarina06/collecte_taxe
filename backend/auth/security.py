"""
Ajoutez ces fonctions à la fin de votre fichier auth/security.py
"""

from database.models import Contribuable
from typing import Union

# OAuth2 scheme pour les citoyens (optionnel, peut utiliser le même)
oauth2_scheme_citoyen = OAuth2PasswordBearer(tokenUrl="/api/citoyen/login")


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