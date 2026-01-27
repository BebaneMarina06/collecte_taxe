# Documentation des endpoints pour QR Code, Géolocalisation et Notifications

## 📋 Table des matières

1. [Endpoints QR Code](#endpoints-qr-code)
2. [Endpoints Géolocalisation](#endpoints-géolocalisation)
3. [Endpoints Notifications](#endpoints-notifications)
4. [Exemples d'implémentation](#exemples-dimplémentation)

---

## 📷 Endpoints QR Code

### 1. Récupérer un contribuable par QR code

**Endpoint:** `GET /api/contribuables/qr/{qr_code}`

**Description:** Récupère les informations d'un contribuable à partir de son QR code.

**Paramètres:**
- `qr_code` (path, string, requis) : Le QR code du contribuable

**Headers:**
```
Authorization: Bearer {token}
Content-Type: application/json
```

**Réponse succès (200):**
```json
{
  "id": 1,
  "nom": "DUPONT",
  "prenom": "Jean",
  "telephone": "+24101234567",
  "email": "jean.dupont@example.com",
  "adresse": "Avenue de la République, Libreville",
  "date_naissance": "1985-05-15",
  "lieu_naissance": "Libreville",
  "profession": "Commerçant",
  "qr_code": "CONTRIB_123456789",
  "actif": true,
  "created_at": "2024-01-15T10:30:00Z",
  "updated_at": "2024-01-15T10:30:00Z"
}
```

**Réponse erreur (404):**
```json
{
  "detail": "Contribuable non trouvé pour ce QR code"
}
```

**Réponse erreur (401):**
```json
{
  "detail": "Non autorisé"
}
```

**Exemple d'implémentation FastAPI:**
```python
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.database import get_db
from app.models import Contribuable
from app.schemas import ContribuableResponse
from app.auth import get_current_user

router = APIRouter(prefix="/api/contribuables", tags=["Contribuables"])

@router.get("/qr/{qr_code}", response_model=ContribuableResponse)
async def get_contribuable_by_qr(
    qr_code: str,
    db: Session = Depends(get_db),
    current_user = Depends(get_current_user)
):
    """
    Récupérer un contribuable par son QR code
    """
    contribuable = db.query(Contribuable).filter(
        Contribuable.qr_code == qr_code,
        Contribuable.actif == True
    ).first()
    
    if not contribuable:
        raise HTTPException(status_code=404, detail="Contribuable non trouvé pour ce QR code")
    
    return contribuable
```

---

### 2. Vérifier un reçu par QR code

**Endpoint:** `GET /api/collectes/qr/{qr_code}`

**Description:** Vérifie et récupère les informations d'une collecte à partir du QR code du reçu.

**Paramètres:**
- `qr_code` (path, string, requis) : Le QR code du reçu (format JSON encodé)

**Headers:**
```
Authorization: Bearer {token}
Content-Type: application/json
```

**Format du QR code du reçu:**
Le QR code contient un JSON encodé avec la structure suivante :
```json
{
  "type": "receipt",
  "collecte_id": 123,
  "reference": "REF-2024-001",
  "timestamp": "2024-01-15T10:30:00Z"
}
```

**Réponse succès (200):**
```json
{
  "id": 123,
  "reference": "REF-2024-001",
  "montant": 50000.00,
  "commission": 2500.00,
  "type_paiement": "cash",
  "statut": "completed",
  "date_collecte": "2024-01-15T10:30:00Z",
  "contribuable": {
    "id": 1,
    "nom": "DUPONT",
    "prenom": "Jean",
    "telephone": "+24101234567"
  },
  "taxe": {
    "id": 1,
    "nom": "Taxe de marché",
    "montant": 50000.00
  },
  "collecteur": {
    "id": 1,
    "nom": "MARTIN",
    "prenom": "Pierre",
    "matricule": "COL-001"
  },
  "created_at": "2024-01-15T10:30:00Z"
}
```

**Réponse erreur (404):**
```json
{
  "detail": "Reçu non trouvé pour ce QR code"
}
```

**Exemple d'implémentation FastAPI:**
```python
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.database import get_db
from app.models import Collecte
from app.schemas import CollecteResponse
from app.auth import get_current_user
import json

router = APIRouter(prefix="/api/collectes", tags=["Collectes"])

@router.get("/qr/{qr_code}")
async def verify_receipt_qr(
    qr_code: str,
    db: Session = Depends(get_db),
    current_user = Depends(get_current_user)
):
    """
    Vérifier un reçu par QR code
    """
    try:
        # Décoder le QR code (JSON)
        qr_data = json.loads(qr_code)
        
        if qr_data.get("type") != "receipt":
            raise HTTPException(status_code=400, detail="QR code invalide")
        
        collecte_id = qr_data.get("collecte_id")
        reference = qr_data.get("reference")
        
        # Récupérer la collecte
        collecte = db.query(Collecte).filter(
            Collecte.id == collecte_id,
            Collecte.reference == reference,
            Collecte.statut == "completed"
        ).first()
        
        if not collecte:
            raise HTTPException(status_code=404, detail="Reçu non trouvé pour ce QR code")
        
        return collecte
        
    except json.JSONDecodeError:
        raise HTTPException(status_code=400, detail="Format de QR code invalide")
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Erreur lors de la vérification: {str(e)}")
```

---

## 📍 Endpoints Géolocalisation

### 1. Enregistrer la position GPS d'une collecte

**Endpoint:** `POST /api/collectes/{collecte_id}/location`

**Description:** Enregistre la position GPS où une collecte a été effectuée.

**Paramètres:**
- `collecte_id` (path, integer, requis) : ID de la collecte

**Body (JSON):**
```json
{
  "latitude": 0.4162,
  "longitude": 9.4673,
  "accuracy": 10.5,
  "altitude": 15.0,
  "heading": 45.0,
  "speed": 0.0,
  "timestamp": "2024-01-15T10:30:00Z"
}
```

**Headers:**
```
Authorization: Bearer {token}
Content-Type: application/json
```

**Réponse succès (200 ou 201):**
```json
{
  "id": 1,
  "collecte_id": 123,
  "latitude": 0.4162,
  "longitude": 9.4673,
  "accuracy": 10.5,
  "altitude": 15.0,
  "heading": 45.0,
  "speed": 0.0,
  "timestamp": "2024-01-15T10:30:00Z",
  "created_at": "2024-01-15T10:30:00Z"
}
```

**Réponse erreur (404):**
```json
{
  "detail": "Collecte non trouvée"
}
```

**Exemple d'implémentation FastAPI:**
```python
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.database import get_db
from app.models import Collecte, CollecteLocation
from app.schemas import LocationCreate, LocationResponse
from app.auth import get_current_user
from datetime import datetime

router = APIRouter(prefix="/api/collectes", tags=["Collectes"])

@router.post("/{collecte_id}/location", response_model=LocationResponse)
async def save_collecte_location(
    collecte_id: int,
    location_data: LocationCreate,
    db: Session = Depends(get_db),
    current_user = Depends(get_current_user)
):
    """
    Enregistrer la position GPS d'une collecte
    """
    # Vérifier que la collecte existe
    collecte = db.query(Collecte).filter(Collecte.id == collecte_id).first()
    if not collecte:
        raise HTTPException(status_code=404, detail="Collecte non trouvée")
    
    # Vérifier que l'utilisateur a le droit d'enregistrer la position
    if collecte.collecteur_id != current_user.id:
        raise HTTPException(status_code=403, detail="Non autorisé")
    
    # Créer ou mettre à jour la position
    existing_location = db.query(CollecteLocation).filter(
        CollecteLocation.collecte_id == collecte_id
    ).first()
    
    if existing_location:
        # Mettre à jour
        existing_location.latitude = location_data.latitude
        existing_location.longitude = location_data.longitude
        existing_location.accuracy = location_data.accuracy
        existing_location.altitude = location_data.altitude
        existing_location.heading = location_data.heading
        existing_location.speed = location_data.speed
        existing_location.timestamp = location_data.timestamp or datetime.utcnow()
        db.commit()
        db.refresh(existing_location)
        return existing_location
    else:
        # Créer
        new_location = CollecteLocation(
            collecte_id=collecte_id,
            latitude=location_data.latitude,
            longitude=location_data.longitude,
            accuracy=location_data.accuracy,
            altitude=location_data.altitude,
            heading=location_data.heading,
            speed=location_data.speed,
            timestamp=location_data.timestamp or datetime.utcnow()
        )
        db.add(new_location)
        db.commit()
        db.refresh(new_location)
        return new_location
```

**Schéma SQL pour la table `collecte_location`:**
```sql
CREATE TABLE collecte_location (
    id SERIAL PRIMARY KEY,
    collecte_id INTEGER NOT NULL REFERENCES collectes(id) ON DELETE CASCADE,
    latitude DOUBLE PRECISION NOT NULL,
    longitude DOUBLE PRECISION NOT NULL,
    accuracy DOUBLE PRECISION,
    altitude DOUBLE PRECISION,
    heading DOUBLE PRECISION,
    speed DOUBLE PRECISION,
    timestamp TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(collecte_id)
);

CREATE INDEX idx_collecte_location_collecte_id ON collecte_location(collecte_id);
CREATE INDEX idx_collecte_location_coordinates ON collecte_location USING GIST(
    ST_MakePoint(longitude, latitude)
);
```

---

### 2. Récupérer la position d'une collecte

**Endpoint:** `GET /api/collectes/{collecte_id}/location`

**Description:** Récupère la position GPS enregistrée pour une collecte.

**Paramètres:**
- `collecte_id` (path, integer, requis) : ID de la collecte

**Headers:**
```
Authorization: Bearer {token}
Content-Type: application/json
```

**Réponse succès (200):**
```json
{
  "id": 1,
  "collecte_id": 123,
  "latitude": 0.4162,
  "longitude": 9.4673,
  "accuracy": 10.5,
  "altitude": 15.0,
  "heading": 45.0,
  "speed": 0.0,
  "timestamp": "2024-01-15T10:30:00Z",
  "created_at": "2024-01-15T10:30:00Z"
}
```

**Réponse erreur (404):**
```json
{
  "detail": "Position non trouvée pour cette collecte"
}
```

**Exemple d'implémentation FastAPI:**
```python
@router.get("/{collecte_id}/location", response_model=LocationResponse)
async def get_collecte_location(
    collecte_id: int,
    db: Session = Depends(get_db),
    current_user = Depends(get_current_user)
):
    """
    Récupérer la position GPS d'une collecte
    """
    location = db.query(CollecteLocation).filter(
        CollecteLocation.collecte_id == collecte_id
    ).first()
    
    if not location:
        raise HTTPException(status_code=404, detail="Position non trouvée pour cette collecte")
    
    return location
```

---

### 3. Récupérer les zones autorisées d'un collecteur

**Endpoint:** `GET /api/collecteurs/{collecteur_id}/zones`

**Description:** Récupère les zones géographiques autorisées pour un collecteur.

**Paramètres:**
- `collecteur_id` (path, integer, requis) : ID du collecteur

**Headers:**
```
Authorization: Bearer {token}
Content-Type: application/json
```

**Réponse succès (200):**
```json
[
  {
    "id": 1,
    "collecteur_id": 1,
    "nom": "Zone Centre-ville",
    "latitude": 0.4162,
    "longitude": 9.4673,
    "radius": 5000.0,
    "description": "Zone de collecte du centre-ville de Libreville",
    "actif": true,
    "created_at": "2024-01-15T10:30:00Z"
  },
  {
    "id": 2,
    "collecteur_id": 1,
    "nom": "Zone Port",
    "latitude": 0.4200,
    "longitude": 9.4700,
    "radius": 3000.0,
    "description": "Zone de collecte du port",
    "actif": true,
    "created_at": "2024-01-15T10:30:00Z"
  }
]
```

**Réponse vide (200):**
```json
[]
```

**Exemple d'implémentation FastAPI:**
```python
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.database import get_db
from app.models import CollecteurZone
from app.schemas import ZoneResponse
from app.auth import get_current_user

router = APIRouter(prefix="/api/collecteurs", tags=["Collecteurs"])

@router.get("/{collecteur_id}/zones", response_model=list[ZoneResponse])
async def get_collecteur_zones(
    collecteur_id: int,
    db: Session = Depends(get_db),
    current_user = Depends(get_current_user)
):
    """
    Récupérer les zones autorisées d'un collecteur
    """
    zones = db.query(CollecteurZone).filter(
        CollecteurZone.collecteur_id == collecteur_id,
        CollecteurZone.actif == True
    ).all()
    
    return zones
```

**Schéma SQL pour la table `collecteur_zone`:**
```sql
CREATE TABLE collecteur_zone (
    id SERIAL PRIMARY KEY,
    collecteur_id INTEGER NOT NULL REFERENCES collecteurs(id) ON DELETE CASCADE,
    nom VARCHAR(255) NOT NULL,
    latitude DOUBLE PRECISION NOT NULL,
    longitude DOUBLE PRECISION NOT NULL,
    radius DOUBLE PRECISION NOT NULL DEFAULT 1000.0,
    description TEXT,
    actif BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_collecteur_zone_collecteur_id ON collecteur_zone(collecteur_id);
CREATE INDEX idx_collecteur_zone_coordinates ON collecteur_zone USING GIST(
    ST_MakePoint(longitude, latitude)
);
```

---

## 🔔 Endpoints Notifications

### 1. Enregistrer le token FCM

**Endpoint:** `POST /api/notifications/register`

**Description:** Enregistre le token Firebase Cloud Messaging (FCM) pour recevoir les notifications push.

**Body (JSON):**
```json
{
  "token": "fGhJkLmNoPqRsTuVwXyZ123456789",
  "platform": "mobile"
}
```

**Headers:**
```
Authorization: Bearer {token}
Content-Type: application/json
```

**Réponse succès (200 ou 201):**
```json
{
  "id": 1,
  "user_id": 1,
  "token": "fGhJkLmNoPqRsTuVwXyZ123456789",
  "platform": "mobile",
  "created_at": "2024-01-15T10:30:00Z",
  "updated_at": "2024-01-15T10:30:00Z"
}
```

**Exemple d'implémentation FastAPI:**
```python
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.database import get_db
from app.models import NotificationToken
from app.schemas import TokenRegister, TokenResponse
from app.auth import get_current_user
from datetime import datetime

router = APIRouter(prefix="/api/notifications", tags=["Notifications"])

@router.post("/register", response_model=TokenResponse)
async def register_notification_token(
    token_data: TokenRegister,
    db: Session = Depends(get_db),
    current_user = Depends(get_current_user)
):
    """
    Enregistrer le token FCM pour les notifications push
    """
    # Vérifier si le token existe déjà
    existing_token = db.query(NotificationToken).filter(
        NotificationToken.token == token_data.token,
        NotificationToken.user_id == current_user.id
    ).first()
    
    if existing_token:
        # Mettre à jour
        existing_token.platform = token_data.platform
        existing_token.updated_at = datetime.utcnow()
        db.commit()
        db.refresh(existing_token)
        return existing_token
    else:
        # Créer
        new_token = NotificationToken(
            user_id=current_user.id,
            token=token_data.token,
            platform=token_data.platform
        )
        db.add(new_token)
        db.commit()
        db.refresh(new_token)
        return new_token
```

**Schéma SQL pour la table `notification_token`:**
```sql
CREATE TABLE notification_token (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES utilisateurs(id) ON DELETE CASCADE,
    token VARCHAR(500) NOT NULL,
    platform VARCHAR(50) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, token)
);

CREATE INDEX idx_notification_token_user_id ON notification_token(user_id);
CREATE INDEX idx_notification_token_token ON notification_token(token);
```

---

### 2. Récupérer les notifications

**Endpoint:** `GET /api/notifications`

**Description:** Récupère la liste des notifications de l'utilisateur connecté.

**Query Parameters:**
- `unread_only` (boolean, optionnel) : Filtrer uniquement les notifications non lues
- `skip` (integer, optionnel, défaut: 0) : Nombre d'éléments à sauter (pagination)
- `limit` (integer, optionnel, défaut: 50) : Nombre maximum d'éléments à retourner

**Headers:**
```
Authorization: Bearer {token}
Content-Type: application/json
```

**Réponse succès (200):**
```json
[
  {
    "id": 1,
    "user_id": 1,
    "type": "collecte",
    "title": "Nouvelle collecte validée",
    "message": "Votre collecte REF-2024-001 a été validée avec succès",
    "read": false,
    "data": {
      "collecte_id": 123,
      "reference": "REF-2024-001",
      "montant": 50000.00
    },
    "created_at": "2024-01-15T10:30:00Z"
  },
  {
    "id": 2,
    "user_id": 1,
    "type": "cloture",
    "title": "Rappel de clôture",
    "message": "N'oubliez pas de clôturer votre journée dans 30 minutes",
    "read": false,
    "data": null,
    "created_at": "2024-01-15T16:00:00Z"
  },
  {
    "id": 3,
    "user_id": 1,
    "type": "alerte",
    "title": "Solde de caisse faible",
    "message": "Votre solde de caisse est inférieur à 100 000 XAF",
    "read": true,
    "data": {
      "solde": 75000.00
    },
    "created_at": "2024-01-15T09:00:00Z"
  }
]
```

**Exemple d'implémentation FastAPI:**
```python
from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session
from app.database import get_db
from app.models import Notification
from app.schemas import NotificationResponse
from app.auth import get_current_user

router = APIRouter(prefix="/api/notifications", tags=["Notifications"])

@router.get("", response_model=list[NotificationResponse])
async def get_notifications(
    unread_only: bool = Query(None),
    skip: int = Query(0, ge=0),
    limit: int = Query(50, ge=1, le=100),
    db: Session = Depends(get_db),
    current_user = Depends(get_current_user)
):
    """
    Récupérer les notifications de l'utilisateur
    """
    query = db.query(Notification).filter(
        Notification.user_id == current_user.id
    )
    
    if unread_only:
        query = query.filter(Notification.read == False)
    
    notifications = query.order_by(
        Notification.created_at.desc()
    ).offset(skip).limit(limit).all()
    
    return notifications
```

**Schéma SQL pour la table `notification`:**
```sql
CREATE TABLE notification (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES utilisateurs(id) ON DELETE CASCADE,
    type VARCHAR(50) NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    read BOOLEAN DEFAULT FALSE,
    data JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_notification_user_id ON notification(user_id);
CREATE INDEX idx_notification_read ON notification(user_id, read);
CREATE INDEX idx_notification_created_at ON notification(created_at DESC);
```

---

### 3. Marquer une notification comme lue

**Endpoint:** `PUT /api/notifications/{notification_id}/read`

**Description:** Marque une notification comme lue.

**Paramètres:**
- `notification_id` (path, integer, requis) : ID de la notification

**Headers:**
```
Authorization: Bearer {token}
Content-Type: application/json
```

**Réponse succès (200):**
```json
{
  "id": 1,
  "read": true,
  "updated_at": "2024-01-15T10:35:00Z"
}
```

**Réponse erreur (404):**
```json
{
  "detail": "Notification non trouvée"
}
```

**Exemple d'implémentation FastAPI:**
```python
@router.put("/{notification_id}/read")
async def mark_notification_as_read(
    notification_id: int,
    db: Session = Depends(get_db),
    current_user = Depends(get_current_user)
):
    """
    Marquer une notification comme lue
    """
    notification = db.query(Notification).filter(
        Notification.id == notification_id,
        Notification.user_id == current_user.id
    ).first()
    
    if not notification:
        raise HTTPException(status_code=404, detail="Notification non trouvée")
    
    notification.read = True
    notification.updated_at = datetime.utcnow()
    db.commit()
    db.refresh(notification)
    
    return {"id": notification.id, "read": notification.read, "updated_at": notification.updated_at}
```

---

### 4. Supprimer une notification

**Endpoint:** `DELETE /api/notifications/{notification_id}`

**Description:** Supprime une notification.

**Paramètres:**
- `notification_id` (path, integer, requis) : ID de la notification

**Headers:**
```
Authorization: Bearer {token}
Content-Type: application/json
```

**Réponse succès (200 ou 204):**
```json
{
  "message": "Notification supprimée avec succès"
}
```

**Réponse erreur (404):**
```json
{
  "detail": "Notification non trouvée"
}
```

**Exemple d'implémentation FastAPI:**
```python
@router.delete("/{notification_id}")
async def delete_notification(
    notification_id: int,
    db: Session = Depends(get_db),
    current_user = Depends(get_current_user)
):
    """
    Supprimer une notification
    """
    notification = db.query(Notification).filter(
        Notification.id == notification_id,
        Notification.user_id == current_user.id
    ).first()
    
    if not notification:
        raise HTTPException(status_code=404, detail="Notification non trouvée")
    
    db.delete(notification)
    db.commit()
    
    return {"message": "Notification supprimée avec succès"}
```

---

### 5. Obtenir le nombre de notifications non lues

**Endpoint:** `GET /api/notifications/count`

**Description:** Retourne le nombre de notifications non lues pour l'utilisateur connecté.

**Headers:**
```
Authorization: Bearer {token}
Content-Type: application/json
```

**Réponse succès (200):**
```json
{
  "count": 5
}
```

**Exemple d'implémentation FastAPI:**
```python
@router.get("/count")
async def get_unread_count(
    db: Session = Depends(get_db),
    current_user = Depends(get_current_user)
):
    """
    Obtenir le nombre de notifications non lues
    """
    count = db.query(Notification).filter(
        Notification.user_id == current_user.id,
        Notification.read == False
    ).count()
    
    return {"count": count}
```

---

## 📝 Schémas Pydantic (FastAPI)

### Schémas pour QR Code

```python
from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class ContribuableResponse(BaseModel):
    id: int
    nom: str
    prenom: str
    telephone: Optional[str]
    email: Optional[str]
    adresse: Optional[str]
    date_naissance: Optional[datetime]
    lieu_naissance: Optional[str]
    profession: Optional[str]
    qr_code: Optional[str]
    actif: bool
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True

class CollecteResponse(BaseModel):
    id: int
    reference: str
    montant: float
    commission: float
    type_paiement: str
    statut: str
    date_collecte: datetime
    contribuable: Optional[dict]
    taxe: Optional[dict]
    collecteur: Optional[dict]
    created_at: datetime

    class Config:
        from_attributes = True
```

### Schémas pour Géolocalisation

```python
from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class LocationCreate(BaseModel):
    latitude: float
    longitude: float
    accuracy: Optional[float] = None
    altitude: Optional[float] = None
    heading: Optional[float] = None
    speed: Optional[float] = None
    timestamp: Optional[datetime] = None

class LocationResponse(BaseModel):
    id: int
    collecte_id: int
    latitude: float
    longitude: float
    accuracy: Optional[float]
    altitude: Optional[float]
    heading: Optional[float]
    speed: Optional[float]
    timestamp: Optional[datetime]
    created_at: datetime

    class Config:
        from_attributes = True

class ZoneResponse(BaseModel):
    id: int
    collecteur_id: int
    nom: str
    latitude: float
    longitude: float
    radius: float
    description: Optional[str]
    actif: bool
    created_at: datetime

    class Config:
        from_attributes = True
```

### Schémas pour Notifications

```python
from pydantic import BaseModel
from typing import Optional, Dict, Any
from datetime import datetime

class TokenRegister(BaseModel):
    token: str
    platform: str

class TokenResponse(BaseModel):
    id: int
    user_id: int
    token: str
    platform: str
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True

class NotificationResponse(BaseModel):
    id: int
    user_id: int
    type: str
    title: str
    message: str
    read: bool
    data: Optional[Dict[str, Any]]
    created_at: datetime

    class Config:
        from_attributes = True
```

---

## 🔧 Configuration Firebase Cloud Messaging

Pour envoyer des notifications push depuis le backend, vous devez :

1. **Installer les dépendances Python:**
```bash
pip install firebase-admin
```

2. **Télécharger la clé de service Firebase:**
   - Aller dans Firebase Console → Project Settings → Service Accounts
   - Générer une nouvelle clé privée
   - Télécharger le fichier JSON

3. **Initialiser Firebase Admin dans votre backend:**
```python
import firebase_admin
from firebase_admin import credentials, messaging

# Initialiser Firebase Admin
cred = credentials.Certificate("path/to/serviceAccountKey.json")
firebase_admin.initialize_app(cred)

# Fonction pour envoyer une notification
async def send_notification_to_user(user_id: int, title: str, message: str, data: dict = None):
    # Récupérer le token FCM de l'utilisateur
    token = db.query(NotificationToken).filter(
        NotificationToken.user_id == user_id
    ).first()
    
    if not token:
        return False
    
    # Créer le message
    notification = messaging.Notification(
        title=title,
        body=message
    )
    
    message_data = messaging.Message(
        notification=notification,
        token=token.token,
        data=data or {}
    )
    
    # Envoyer
    try:
        response = messaging.send(message_data)
        print(f"Notification envoyée: {response}")
        return True
    except Exception as e:
        print(f"Erreur lors de l'envoi: {e}")
        return False
```

---

## ✅ Checklist d'implémentation

### QR Code
- [ ] Créer la colonne `qr_code` dans la table `contribuables` (si elle n'existe pas)
- [ ] Implémenter `GET /api/contribuables/qr/{qr_code}`
- [ ] Implémenter `GET /api/collectes/qr/{qr_code}`
- [ ] Tester le scan de QR code de contribuable
- [ ] Tester la vérification de QR code de reçu

### Géolocalisation
- [ ] Créer la table `collecte_location`
- [ ] Créer la table `collecteur_zone` (optionnel)
- [ ] Implémenter `POST /api/collectes/{id}/location`
- [ ] Implémenter `GET /api/collectes/{id}/location`
- [ ] Implémenter `GET /api/collecteurs/{id}/zones`
- [ ] Tester l'enregistrement de position
- [ ] Tester la récupération de position
- [ ] Tester l'affichage sur la carte

### Notifications
- [ ] Créer la table `notification`
- [ ] Créer la table `notification_token`
- [ ] Implémenter `POST /api/notifications/register`
- [ ] Implémenter `GET /api/notifications`
- [ ] Implémenter `PUT /api/notifications/{id}/read`
- [ ] Implémenter `DELETE /api/notifications/{id}`
- [ ] Implémenter `GET /api/notifications/count`
- [ ] Configurer Firebase Cloud Messaging
- [ ] Créer un système d'envoi de notifications (ex: après validation de collecte)
- [ ] Tester la réception de notifications push

---

## 📚 Ressources supplémentaires

- [Documentation Firebase Cloud Messaging](https://firebase.google.com/docs/cloud-messaging)
- [Documentation FastAPI](https://fastapi.tiangolo.com/)
- [Documentation PostgreSQL PostGIS](https://postgis.net/documentation/) (pour les requêtes géospatiales avancées)

