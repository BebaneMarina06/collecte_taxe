# 📱 Créer un Collecteur via l'API REST

Puisque les connexions externes à la base de données Render sont bloquées (sécurité), vous pouvez créer un collecteur directement via l'API REST.

---

## 🎯 Méthode 1 : Via la Documentation Swagger (Recommandé)

### 1. Accéder à la documentation API

Ouvrez votre navigateur et allez à :
```
https://votre-app.onrender.com/docs
```

### 2. S'authentifier

1. Cliquez sur **"POST /api/auth/login"**
2. Cliquez sur **"Try it out"**
3. Entrez vos identifiants :
```json
{
  "email": "votre_email@example.com",
  "password": "votre_mot_de_passe"
}
```
4. Cliquez sur **"Execute"**
5. **Copiez le token** dans la réponse (champ `access_token`)

### 3. Autoriser l'API

1. Cliquez sur le bouton **"Authorize"** (en haut à droite)
2. Collez le token dans le champ
3. Cliquez sur **"Authorize"** puis **"Close"**

### 4. Créer le collecteur

1. Cliquez sur **"POST /api/collecteurs"**
2. Cliquez sur **"Try it out"**
3. Modifiez le JSON avec les informations du collecteur :

```json
{
  "nom": "Dupont",
  "prenom": "Jean",
  "email": "jean.dupont@example.com",
  "telephone": "+24101234567",
  "matricule": "COL-2024-001",
  "zone_id": 1,
  "latitude": 0.3901,
  "longitude": 9.4544,
  "heure_cloture": "18:00"
}
```

4. Cliquez sur **"Execute"**
5. Le collecteur sera créé ! ✅

---

## 🎯 Méthode 2 : Via cURL (Ligne de commande)

### Étape 1 : Obtenir un token d'authentification

```bash
curl -X POST "https://votre-app.onrender.com/api/auth/login" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "votre_email@example.com",
    "password": "votre_mot_de_passe"
  }'
```

**Réponse :**
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "token_type": "bearer"
}
```

**Copiez le `access_token`** pour l'étape suivante.

### Étape 2 : Créer le collecteur

Remplacez `VOTRE_TOKEN` par le token obtenu à l'étape 1 :

```bash
curl -X POST "https://votre-app.onrender.com/api/collecteurs" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer VOTRE_TOKEN" \
  -d '{
    "nom": "Dupont",
    "prenom": "Jean",
    "email": "jean.dupont@example.com",
    "telephone": "+24101234567",
    "matricule": "COL-2024-001",
    "zone_id": 1,
    "latitude": 0.3901,
    "longitude": 9.4544,
    "heure_cloture": "18:00"
  }'
```

---

## 🎯 Méthode 3 : Via PowerShell (Windows)

### Étape 1 : Obtenir un token

```powershell
$loginBody = @{
    email = "votre_email@example.com"
    password = "votre_mot_de_passe"
} | ConvertTo-Json

$response = Invoke-RestMethod -Uri "https://votre-app.onrender.com/api/auth/login" `
    -Method POST `
    -ContentType "application/json" `
    -Body $loginBody

$token = $response.access_token
Write-Host "Token: $token"
```

### Étape 2 : Créer le collecteur

```powershell
$collecteurBody = @{
    nom = "Dupont"
    prenom = "Jean"
    email = "jean.dupont@example.com"
    telephone = "+24101234567"
    matricule = "COL-2024-001"
    zone_id = 1
    latitude = 0.3901
    longitude = 9.4544
    heure_cloture = "18:00"
} | ConvertTo-Json

$headers = @{
    "Authorization" = "Bearer $token"
    "Content-Type" = "application/json"
}

$result = Invoke-RestMethod -Uri "https://votre-app.onrender.com/api/collecteurs" `
    -Method POST `
    -Headers $headers `
    -Body $collecteurBody

$result | ConvertTo-Json -Depth 10
```

---

## 📋 Champs requis pour créer un collecteur

| Champ | Type | Requis | Description |
|-------|------|--------|-------------|
| `nom` | string | ✅ Oui | Nom du collecteur |
| `prenom` | string | ✅ Oui | Prénom du collecteur |
| `email` | string | ✅ Oui | Email unique |
| `telephone` | string | ✅ Oui | Téléphone unique |
| `matricule` | string | ✅ Oui | Matricule unique |
| `zone_id` | integer | ❌ Non | ID de la zone géographique |
| `latitude` | float | ❌ Non | Latitude GPS |
| `longitude` | float | ❌ Non | Longitude GPS |
| `heure_cloture` | string | ❌ Non | Heure de clôture (format HH:MM) |

---

## 🔍 Vérifier les zones disponibles

Pour obtenir la liste des zones disponibles (pour `zone_id`) :

```bash
curl -X GET "https://votre-app.onrender.com/api/references/zones" \
  -H "Authorization: Bearer VOTRE_TOKEN"
```

---

## ✅ Vérifier que le collecteur a été créé

```bash
curl -X GET "https://votre-app.onrender.com/api/collecteurs" \
  -H "Authorization: Bearer VOTRE_TOKEN"
```

Ou pour un collecteur spécifique :

```bash
curl -X GET "https://votre-app.onrender.com/api/collecteurs/1" \
  -H "Authorization: Bearer VOTRE_TOKEN"
```

---

## 🆘 Problèmes courants

### Erreur 401 : Unauthorized
→ Vérifiez que votre token est valide et que vous l'avez bien inclus dans le header `Authorization: Bearer ...`

### Erreur 400 : "Un collecteur avec ce matricule existe déjà"
→ Le matricule doit être unique. Choisissez un autre matricule.

### Erreur 400 : "Un collecteur avec cet email existe déjà"
→ L'email doit être unique. Utilisez un autre email.

### Erreur 404 : "Zone non trouvée"
→ Vérifiez que le `zone_id` existe. Utilisez l'endpoint `/api/references/zones` pour voir les zones disponibles.

---

## 💡 Astuce : Créer plusieurs collecteurs

Vous pouvez créer plusieurs collecteurs en répétant la requête POST avec des données différentes. Assurez-vous que chaque collecteur a :
- Un `matricule` unique
- Un `email` unique
- Un `telephone` unique

---

## 📱 Pour l'application mobile

Une fois le collecteur créé, il pourra se connecter à l'application mobile avec :
- **Email** : L'email que vous avez défini
- **Mot de passe** : (À définir via l'endpoint de création d'utilisateur si nécessaire)

---

Pour plus d'informations, consultez la documentation Swagger : `https://votre-app.onrender.com/docs`

