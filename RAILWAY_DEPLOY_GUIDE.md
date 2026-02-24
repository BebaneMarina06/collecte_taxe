# 🚀 Déploiement Railway.app - Guide Complet

## ⚡ Vue d'ensemble

Railway.app c'est:
- ✅ **$5 de crédit gratuit** (valide 1-2 mois)
- ✅ **PostgreSQL + PostGIS gratuit**
- ✅ **Déploiement en 5 min** (GitHub integration)
- ✅ **Pas de dormancy** (toujours actif)
- ✅ **Interface super simple**
- ✅ **Coût après crédit: ~$5-10/mois**

---

## 📋 Prérequis

1. **Compte GitHub** (gratuit) - https://github.com
2. **Compte Railway.app** (gratuit) - https://railway.app
3. **Git** installé localement
4. **Votre code** poussé sur GitHub

---

## 🎯 Plan (20 minutes)

1. **Créer/connecter GitHub** (2 min)
2. **S'inscrire sur Railway** (2 min)
3. **Connecter GitHub à Railway** (2 min)
4. **Déployer Backend** (5 min)
5. **Déployer Frontend** (5 min)
6. **Initialiser la BD** (3 min)
7. **Tester** (1 min)

---

## ✅ Étape 1: Préparer GitHub

### 1.1 Si vous n'avez pas un repo GitHub

```powershell
cd c:\Users\021924\Documents\projet_ventis\taxe\collecte_taxe

# Initialiser git (si pas déjà fait)
git init
git add .
git commit -m "Initial commit - Prêt pour Railway"

# Créer un repo sur GitHub: https://github.com/new
# Puis pousser:
git branch -M main
git remote add origin https://github.com/VOTRE_USER/collecte-taxe.git
git push -u origin main
```

### 1.2 Si vous avez déjà un repo GitHub

```powershell
cd c:\Users\021924\Documents\projet_ventis\taxe\collecte_taxe

# Vérifier le remote
git remote -v

# Mettre à jour
git add .
git commit -m "Préparation Railway"
git push origin main
```

---

## 🚂 Étape 2: S'Inscrire sur Railway

1. Allez sur https://railway.app
2. Cliquez **"Start Free"** ou **"Sign Up"**
3. Connectez-vous avec **GitHub** (plus simple)
4. Autorisez l'accès
5. Validez l'email
6. C'est fait! ✅

---

## 🔗 Étape 3: Créer un Nouveau Projet

### Option A: Depuis l'interface Railway (Simple)

1. https://railway.app/dashboard
2. Cliquez **"New Project"**
3. Choisissez **"Deploy from GitHub repo"**
4. Sélectionnez votre repo `collecte-taxe`
5. Railway détecte automatiquement le Dockerfile
6. Cliquez **"Deploy"**

### Option B: Via lien Direct

```
https://railway.app/new?repo=YOUR_GITHUB_USERNAME/collecte-taxe
```

---

## 🏗️ Étape 4: Déployer le Backend

### 4.1 Configuration du Service Backend

Dans le dashboard Railway:

1. **Créer un nouveau service**
   - Cliquez **"+ New"** → **"Database"** → **"PostgreSQL"**
   - Railway le configure automatiquement (gratuit!)

2. **Ajouter le backend FastAPI**
   - Cliquez **"+ New"** → **"GitHub Repo"**
   - Sélectionnez votre repo `collecte-taxe`
   - Railway trouve le `Dockerfile`
   - Configure le service

### 4.2 Variables d'Environnement Backend

Dans le Railway dashboard pour le service backend:

Allez dans **Variables** et ajoutez:

```
SECRET_KEY=your-super-secret-key-generated-here
ENVIRONMENT=production
DEBUG=False
CORS_ORIGINS=https://frontend.railway.app
BAMBOOPAY_MERCHANT_ID=6008889
BAMBOOPAY_MERCHANT_SECRET=your-secret
BAMBOOPAY_MERCHANT_USERNAME=6008889
BAMBOOPAY_DEBUG=false
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your-email@gmail.com
SMTP_PASSWORD=your-app-password
SMTP_FROM=your-email@gmail.com
```

**Important**: La variable `DATABASE_URL` est **automatiquement créée** par Railway quand vous ajoutez PostgreSQL!

### 4.3 Dockerfile à Utiliser

Railway détecte automatiquement le `Dockerfile` à la racine du dossier  `backend/`:

```dockerfile
FROM python:3.11-slim
# ... (déjà créé pour vous)
```

Railway va:
✅ Trouver le Dockerfile  
✅ Build l'image  
✅ Déployer et exposer le service  

---

## 🎨 Étape 5: Déployer le Frontend

### 5.1 Créer un Service Separate pour le Frontend

1. Dans le dashboard Railway du même projet
2. Cliquez **"+ New"**
3. Choisissez **"GitHub Repo"**
4. Sélectionnez le même repo
5. **C'est important**: Configurez le **Root Directory** vers `frontend/frontend/`

### 5.2 Configuration du Dockerfile Frontend

Railway va chercher le Dockerfile dans le dossier spécifié:

```dockerfile
FROM node:18-alpine AS builder
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM node:18-alpine
WORKDIR /app
RUN npm install -g serve
COPY --from=builder /app/dist ./dist
COPY server.js ./
EXPOSE 3000
CMD ["node", "server.js"]
```

### 5.3 Variables d'Environnement Frontend

Dans Railway pour le service frontend:

```
API_BASE_URL=https://backend.railway.app/api
NODE_ENV=production
PORT=3000
```

Railway va **remplacer automatiquement** `backend.railway.app` par le vrai domaine!

---

## 🗄️ Étape 6: PostgreSQL automatique

Railway crée **automatiquement** une instance PostgreSQL quand vous ajoutez l'addon!

Ce qui se passe:
✅ PostgreSQL 15+ créé  
✅ PostGIS installé (pour la géolocalisation)  
✅ `DATABASE_URL` injecté automatiquement  
✅ Connexion sécurisée SSL  
✅ Gratuit inclus  

Vous n'avez rien à faire!

---

## 💾 Étape 7: Initialiser la Base de Données

Une fois le backend déployé:

### Option A: Via Railway Shell (Recommandé)

1. Dans le dashboard Railway
2. Allez sur le service **backend**
3. Cliquez sur l'onglet **"Shell"** ou **"Console"**
4. Exécutez:

```bash
# Initialiser les tables
python database/init_db.py

# Charger les seeders (données d'exemple)
python database/run_seeders.py

# Vérifier la connexion
python -c "from database.database import SessionLocal; s = SessionLocal(); print('✅ Connecté à la BD')"
```

### Option B: Via Railway CLI

```powershell
# Installer le CLI (optionnel)
npm install -g @railway/cli

# Se connecter
railway login

# Exécuter des commandes
railway run python database/init_db.py

# Voir les logs
railway logs
```

---

## 📊 Vérifier le Déploiement

### 1. Tester le Backend

```powershell
# Obtenir l'URL du backend
# Dans le dashboard Railway → Service Backend → "Public URL"

$API_URL = "https://backend-XXXX.railway.app"

# Test santé
Invoke-WebRequest "$API_URL/health"
# Doit retourner: {"status": "healthy"}

# Consulter les docs API
# Allez sur: https://backend-XXXX.railway.app/docs
```

### 2. Tester le Frontend

```powershell
# Dans le dashboard Railway → Service Frontend → "Public URL"
# Devrait ouvrir l'app Angular
```

### 3. Vérifier les Logs

```powershell
# Dans le dashboard Railway:
# Service → "Logs" tab
# Cherchez "Application running on port"
```

---

## 🔄 Mises à Jour du Code

Après modification du code:

```powershell
# Commit
git add .
git commit -m "Description du changement"

# Push
git push origin main

# Railway détecte et redéploie automatiquement! ✅
# Pas besoin de faire quoi que ce soit d'autre
```

---

## 🔗 Mapper un Domaine Personnalisé (Optionnel)

### Ajouter votre domaine

1. Dans le dashboard Railway
2. Service → **"Settings"**
3. Scrollez vers **"Domain"**
4. Cliquez **"Add Custom Domain"**
5. Entrez: `api.votre-domaine.com`
6. Railway affiche les instructions DNS

### Configurer les DNS

Chez votre registrar (namecheap, godaddy, etc):

1. Allez dans les DNS settings
2. Créez un record **CNAME**:
   - Nom: `api`
   - Value: `gateway.railway.app`

3. Attendez 5-30 min pour la propagation
4. Testé! ✅

---

## 📊 Monitoring et Logs

### Voir les Logs en Temps Réel

Dashboard Railway → Service → **"Logs"** or **"Monitoring"**

Cherchez:
```
INFO:     Application startup complete
INFO:     GET /health - status 200
```

### Erreurs Communes

**"Failed to connect to database"**
→ Vérifier que PostgreSQL addon est créé  
→ Vérifier DATABASE_URL est défini  

**"Port already in use"**
→ Vérifier que votre app écoute sur `$PORT` (Railway l'injecte)  

**"CORS error"**
→ Vérifier CORS_ORIGINS dans Railway Variables  

**"Static files not found"**
→ Assurer que uploads/ est copié dans le Dockerfile  

---

## 💰 Coûts

### Crédit Gratuit: $5

Vous pouvez utiliser gratuitement:
- ✅ Backend FastAPI (~$1-2/mois)
- ✅ Frontend Node.js (~$1-2/mois)
- ✅ PostgreSQL (~$1-2/mois)
- ✅ Bandwidth (~$0.1/mois)

**Durée**: 1-2 mois selon usage

### Après le crédit

- Backend: ~$2-3/mois
- PostgreSQL: ~$2-3/mois
- **Total: ~$5-10/mois**

**Vs Heroku**: $110/mois → Railway: $5-10/mois 💰 Économie de 90%!

---

## 🎯 Architecture sur Railway

```
Votre Repo GitHub
│
├── backend/
│   ├── Dockerfile (Railway détecte et construit)
│   ├── main.py
│   ├── requirements.txt
│   └── database/
│
├── frontend/frontend/
│   ├── Dockerfile (Railway détecte et construit)
│   ├── package.json
│   ├── server.js
│   └── src/
│
└── railway.json (config optionnelle)

Railway Cluster:
├── Service 1: Backend FastAPI
│   └── Database: PostgreSQL (AUTO)
└── Service 2: Frontend Node.js
```

---

## 🚨 Commandes Pratiques Railway

```powershell
# Redémarrer une app
# Dashboard → Service → Redeploy / Restart

# Voir les variables
# Dashboard → Service → Variables

# Ajouter un secret
# Dashboard → Service → Variables → Add Secret

# Consulter les logs
# Dashboard → Logs tab

# Vérifier la santé
# Dashboard → Monitoring tab

# Obtenir l'URL publique
# Dashboard → Service → "Public URL" button
```

---

## ✅ Checklist Déploiement

- [ ] Repo GitHub créé et poussé
- [ ] Compte Railway créé (avec GitHub)
- [ ] Nouveau projekt créé
- [ ] PostgreSQL addon ajouté
- [ ] Service Backend configuré + déployé
- [ ] Variables d'env Backend complétées
- [ ] Service Frontend configuré + déployé
- [ ] Variables d'env Frontend complétées
- [ ] BD initialisée (`python database/init_db.py`)
- [ ] Seeders chargés (`python database/run_seeders.py`)
- [ ] Backend /health endpoint répond
- [ ] Frontend charge sans erreurs
- [ ] CORS configurés correctement
- [ ] Logs vérifient pas d'erreurs critiques

---

## 🎉 C'est Fini!

Votre app est en ligne sur Railway! 🚀

### URLs d'Accès

- **Backend API**: `https://backend-XXXX.railway.app/docs`
- **Frontend**: `https://frontend-XXXX.railway.app`
- **Dashboard Railway**: `https://railway.app/dashboard`

### Support

- Docs Railway: https://docs.railway.app
- Community Discord: https://discord.gg/railway
- Status: https://status.railway.app

---

## 🔐 Sécurité et Bonnes Pratiques

### Variables Sensibles

Utilisez les **"Secrets"** de Railway pour:
- `SECRET_KEY` → Secret
- `BAMBOOPAY_MERCHANT_SECRET` → Secret
- `SMTP_PASSWORD` → Secret

```
Dashboard → Service → Variables → "Add Secret"
```

### Backups PostgreSQL

Railway crée **automatiquement des backups**:
- Quotidiens (7 jours retenus)
- Sur demande (via dashboard)

Pour télécharger:
```powershell
# Via Railway CLI
railway database export
```

### HTTPS Automatique

Railway **force HTTPS** automatiquement ✅

---

## 📈 Optimisations Futures

Une fois live, vous pouvez:

1. **CDN**: Ajouter Cloudflare (gratuit) pour mettre en cache
2. **Analytics**: Intégrer PostHog (gratuit)
3. **Monitoring**: Ajouter Sentry (gratuit)
4. **Backups**: Configurer des exports quotidiens
5. **Scaling**: Passer à plus de ressources si besoin

---

**Vous êtes prêt pour Railway!** 🎉

Commencez par l'Étape 1 (préparer GitHub) et suivez le guide.

Questions? Consultez https://docs.railway.app
