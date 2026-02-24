# 📱 Guide de Déploiement sur Heroku

## Prérequis

1. **Compte Heroku** - https://www.heroku.com/
2. **Heroku CLI** - https://devcenter.heroku.com/articles/heroku-cli
3. **Git** - Initialisé dans votre projet
4. **Docker** (optionnel, pour test local)

## ⚠️ Important: Coûts Heroku

Heroku est **payant** depuis novembre 2022. Les coûts estimés:
- **Dyno Standard-1X**: ~$50/mois (backend)
- **Dyno Standard-1X**: ~$50/mois (frontend)
- **PostgreSQL Standard-0**: ~$9/mois
- **Total estimé**: ~$110/mois

Alternative gratuite: **Render.com**, **Fly.io**, **Railway.app**

---

## 🚀 Installation Heroku CLI

```powershell
# Windows - Installer depuis le site
# https://cli-assets.heroku.com/branches/stable/heroku-windows-x64.exe

# OU via Scoop
scoop install heroku

# Vérifier l'installation
heroku --version

# Se connecter
heroku login
# S'ouvrira dans le navigateur pour authentification
```

---

## 📋 Étape 1: Créer les Applications Heroku

### 1.1 Application Backend

```powershell
# Créer une app pour le backend
heroku create taxe-backend
# Retorn: https://taxe-backend.herokuapp.com/

# Ajouter PostgreSQL avec PostGIS
heroku addons:create heroku-postgresql:standard-0 --app taxe-backend

# Vérifier l'addon
heroku addons --app taxe-backend
```

### 1.2 Application Frontend

```powershell
# Créer une app pour le frontend
heroku create taxe-frontend

# Retorn: https://taxe-frontend.herokuapp.com/
```

---

## 🔐 Étape 2: Configurer les Variables d'Environnement

### 2.1 Backend

```powershell
# Générer une clé secrète sécurisée
# Utilisez un outil comme: https://www.uuidgenerator.net/ ou
$secret = -join ((65..90) + (97..122) + (48..57) | Get-Random -Count 32 | ForEach-Object {[char]$_})
Write-Output $secret

# Configurer les variables
heroku config:set `
  SECRET_KEY="$secret" `
  ENVIRONMENT=production `
  DEBUG=False `
  CORS_ORIGINS="https://taxe-frontend.herokuapp.com,https://votre-domaine.com" `
  BAMBOOPAY_MERCHANT_ID="6008889" `
  BAMBOOPAY_MERCHANT_SECRET="votre-secret" `
  BAMBOOPAY_MERCHANT_USERNAME="6008889" `
  BAMBOOPAY_DEBUG=false `
  SMTP_HOST="smtp.gmail.com" `
  SMTP_PORT="587" `
  SMTP_USER="votre-email@gmail.com" `
  SMTP_PASSWORD="votre-app-password" `
  SMTP_FROM="votre-email@gmail.com" `
  --app taxe-backend

# Vérifier
heroku config --app taxe-backend
```

### 2.2 Frontend

```powershell
# Créer un fichier .env TypeScript pour le frontend
# Ce fichier sera inclus lors du build

heroku config:set `
  API_BASE_URL="https://taxe-backend.herokuapp.com/api" `
  KEYCLOAK_URL="https://your-keycloak.com" `
  KEYCLOAK_REALM="taxe" `
  --app taxe-frontend
```

---

## 📦 Étape 3: Préparer le Déploiement

### 3.1 Vérifier la structure du projet

```
collecte_taxe/
├── backend/
│   ├── Dockerfile (ou Dockerfile.heroku)
│   ├── Procfile
│   ├── heroku.yml (optionnel)
│   ├── requirements.txt
│   ├── main.py
│   └── ... (reste du code)
│
├── frontend/
│   └── frontend/
│       ├── Dockerfile.heroku
│       ├── Procfile
│       ├── server.js
│       ├── package.json
│       └── ... (reste du code)
│
└── .env.heroku.example
```

### 3.2 Initialiser Git si nécessaire

```powershell
cd c:\Users\021924\Documents\projet_ventis\taxe\collecte_taxe

# Vérifier si git est initialisé
git status

# Si non, initialiser
git init
git add .
git commit -m "Initial commit - Préparation Heroku"
```

---

## 🚀 Étape 4: Déployer le Backend

### 4.1 Depuis le dossier backend

```powershell
# Se positionner dans le dossier backend
cd backend

# Créer un dossier .heroku
mkdir .heroku
Copy-Item Procfile .heroku/Procfile

# Ajouter le remote Heroku
heroku git:remote -a taxe-backend

# Déployer
git push heroku main
# ou si votre branche est 'master'
git push heroku master

# Suivre les logs
heroku logs -f --app taxe-backend
```

### 4.2 Vérifier le déploiement

```powershell
# Vérifier l'URL
heroku open --app taxe-backend

# Tester l'API
Invoke-WebRequest https://taxe-backend.herokuapp.com/health

# Voir les logs
heroku logs --app taxe-backend -n 50
```

---

## 🎨 Étape 5: Déployer le Frontend

### 5.1 Configurer Angular pour la build

**Fichier: `frontend/frontend/angular.json`**

```json
{
  "projects": {
    "collecte-taxe-frontend": {
      "architect": {
        "build": {
          "configurations": {
            "production": {
              "outputPath": "dist/collecte-taxe-frontend/browser",
              "budgets": [...]
            }
          }
        }
      }
    }
  }
}
```

### 5.2 Ajouter express au package.json

```powershell
cd frontend/frontend

npm install express compression --save

# Vérifier server.js existe
ls server.js
```

### 5.3 Déployer

```powershell
# Se positionner dans le dossier frontend
cd frontend/frontend

# Ajouter le remote Heroku
heroku git:remote -a taxe-frontend

# Important: le dossier doit être à la racine du git
# Soit vous déployez depuis la racine avec un heroku.yml qui spécifie le chemin
# Soit vous pouvez utiliser un subtree

# Option: Utiliser git subtree
cd ..  # Retour à collecte_taxe
heroku git:remote -a taxe-frontend -n heroku-frontend

git push heroku-frontend `git subtree split --prefix frontend/frontend main`:main --force

# Ou: Déployer directement
cd frontend/frontend
git push heroku-frontend main
```

### 5.4 Configurer l'URL API

**Fichier: `frontend/frontend/src/environments/environment.prod.ts`**

```typescript
export const environment = {
  production: true,
  apiUrl: 'https://taxe-backend.herokuapp.com/api'
};
```

---

## 🔄 Étape 6: Initialiser la Base de Données

### 6.1 Exécuter les migrations

```powershell
# Exécuter les scripts d'init
heroku run python database/init_db.py --app taxe-backend
heroku run python database/run_seeders.py --app taxe-backend
```

### 6.2 Importer les données (optionnel)

```powershell
# Si vous avez un dump SQL
heroku pg:psql --app taxe-backend < donnees_taxe.sql
```

### 6.3 Vérifier la DB

```powershell
# Accéder à la console PostgreSQL
heroku pg:psql --app taxe-backend

# Exemple de requête
SELECT * FROM utilisateur LIMIT 5;
\q
```

---

## 🔗 Étape 7: Configurer CORS et URLs

### 7.1 Mapper les domaines personnalisés (optionnel)

```powershell
# Ajouter un domaine personnalisé
heroku domains:add api.votre-domaine.com --app taxe-backend
heroku domains:add app.votre-domaine.com --app taxe-frontend

# Pour fonctionner, configurer les DNS de votre registrar
# CNAME vers taxe-backend.herokuapp.com et taxe-frontend.herokuapp.com
```

### 7.2 Mettre à jour les CORS

```powershell
heroku config:set `
  CORS_ORIGINS="https://app.votre-domaine.com,https://taxe-frontend.herokuapp.com" `
  --app taxe-backend
```

---

## 📊 Étape 8: Monitoring et Maintenance

### 8.1 Logs en temps réel

```powershell
# Backend
heroku logs -f --app taxe-backend

# Frontend
heroku logs -f --app taxe-frontend
```

### 8.2 Métriques

```powershell
# Utilisation des ressources
heroku ps --app taxe-backend
heroku ps --app taxe-frontend

# Stats détaillées
heroku logs --tail --app taxe-backend
```

### 8.3 Backups PostgreSQL

```powershell
# Créer un backup manuel
heroku pg:backups:capture --app taxe-backend

# Lister les backups
heroku pg:backups --app taxe-backend

# Télécharger un backup
heroku pg:backups:download b001 --app taxe-backend
```

---

## 🔄 Mises à Jour et Déploiements

### Après modifications du code

```powershell
# Commit des changements
git add .
git commit -m "Bug fix: description"

# Redéployer (depuis chaque dossier)
cd backend
git push heroku main

# OU frontend
cd frontend/frontend
git push heroku-frontend main
```

### Migrations de schéma

```powershell
# Créer une migration
heroku run python -m alembic revision --autogenerate -m "description" --app taxe-backend

# Appliquer
heroku run python -m alembic upgrade head --app taxe-backend
```

---

## 🚨 Dépannage

### 1. Erreur de port

```
Address already in use
```

**Solution**: Heroku définit `$PORT` automatiquement. Vérifier que le Procfile le respecte:

```
web: uvicorn main:app --host 0.0.0.0 --port $PORT
```

### 2. Erreur PostgreSQL

```
could not connect to database
```

**Solution**:

```powershell
# Vérifier la variable DATABASE_URL
heroku config:get DATABASE_URL --app taxe-backend

# Si manquante, l'addon l'ajoute automatiquement
heroku addons:create heroku-postgresql:standard-0 --app taxe-backend
```

### 3. Erreur build Angular

```
Exit code: 1
```

**Solution**:

```powershell
# Vérifier les dépendances
npm ci
npm run build

# Vérifier package-lock.json existe
ls package-lock.json
```

### 4. CORS issues

```
Access to XMLHttpRequest blocked by CORS
```

**Solution**: Ajouter le domaine du frontend à CORS_ORIGINS sur le backend:

```powershell
heroku config:set CORS_ORIGINS="https://taxe-frontend.herokuapp.com" --app taxe-backend
```

---

## 📱 Fichiers Supplémentaires Créés

- **`Procfile`** (backend) - Instruction de démarrage
- **`Dockerfile.heroku`** (backend) - Image Docker optimisée
- **`Dockerfile.heroku`** (frontend) - Build multi-stage Angular
- **`server.js`** (frontend) - Serveur Express pour SPA
- **`app.json`** - Configuration Heroku Button
- **`HEROKU_DEPLOY_GUIDE.md`** - Ce guide

---

## ✅ Checklist de Déploiement

- [ ] Heroku CLI installée et authentifiée
- [ ] Apps créées: taxe-backend et taxe-frontend
- [ ] PostgreSQL + PostGIS addon ajouté
- [ ] Variables d'environnement configurées
- [ ] Git repository initialisé et committable
- [ ] Dockerfile.heroku et Procfile en place
- [ ] Backend déployé et testé (/health)
- [ ] Frontend déployé et accessible
- [ ] Base de données initialisée
- [ ] CORS configurés correctement
- [ ] Domaines DNS mappés (optionnel)
- [ ] Backups automatiques configurés

---

## 🎯 Prochaines Étapes

1. **Monitoring**: Utiliser Heroku Metrics ou DataDog
2. **Logs**: Utiliser Heroku Logs ou Papertrail
3. **HTTPS**: Heroku fourni automatiquement
4. **CI/CD**: Configuration GitHub Actions pour auto-deploy
5. **Scaling**: Augmenter les dynos si besoin

---

**Support**: https://devcenter.heroku.com/articles/getting-started-with-python
