# 🚀 DÉPLOIEMENT RAPIDE - Checklist

## ✅ Prérequis

- [ ] Heroku CLI installée: `heroku --version`
- [ ] Authentifié: `heroku login`
- [ ] Git repository initialisé: `git status`
- [ ] Branch principale: `main` ou `master`

---

## 📋 ÉTAPE 1: Installation Heroku CLI (5 min)

### Windows

Télécharger et installer depuis:
https://cli-assets.heroku.com/branches/stable/heroku-windows-x64.exe

OU via Scoop:
```powershell
scoop install heroku
```

### Vérifier l'installation
```powershell
heroku --version
heroku login
# S'ouvre dans le navigateur
```

---

## ⚙️ ÉTAPE 2: Configuration Automatique (3 min)

```powershell
# Exécuter le script de configuration
.\setup-heroku.ps1
```

Ce script:
✓ Génère une clé secrète sécurisée
✓ Crée les 2 apps Heroku (backend + frontend)
✓ Configure PostgreSQL + PostGIS
✓ Définit toutes les variables d'environnement

### Ou Configuration Manuelle

```powershell
# 1. Créer les apps
heroku create taxe-backend
heroku create taxe-frontend

# 2. Ajouter PostgreSQL
heroku addons:create heroku-postgresql:standard-0 --app taxe-backend

# 3. Configurer les variables
$secret = [Convert]::ToBase64String(([System.Text.Encoding]::UTF8.GetBytes((New-Guid)))).Substring(0,32)

heroku config:set `
  SECRET_KEY="$secret" `
  ENVIRONMENT=production `
  DEBUG=False `
  CORS_ORIGINS="https://taxe-frontend.herokuapp.com" `
  --app taxe-backend

heroku config:set `
  API_BASE_URL="https://taxe-backend.herokuapp.com/api" `
  --app taxe-frontend
```

---

## 🚀 ÉTAPE 3: Déploiement Automatique (5 min)

```powershell
# Depuis la racine du projet
.\deploy-heroku.ps1
```

Ou déployer manuellement:

### Backend

```powershell
cd backend

# Ajouter le remote
heroku git:remote -a taxe-backend -n heroku-backend

# Déployer
git push heroku-backend main
# ou: git push heroku-backend master

# Voir les logs
heroku logs -f --app taxe-backend
```

### Frontend

```powershell
cd frontend\frontend

# Ajouter le remote
heroku git:remote -a taxe-frontend -n heroku-frontend

# Déployer
git push heroku-frontend main
# ou: git push heroku-frontend master

# Voir les logs
heroku logs -f --app taxe-frontend
```

---

## 🗄️ ÉTAPE 4: Initialiser la Base de Données (2 min)

```powershell
# Initialiser les tables
heroku run python database/init_db.py --app taxe-backend

# Charger les données de test (facultatif)
heroku run python database/run_seeders.py --app taxe-backend
```

---

## ✅ ÉTAPE 5: Vérification (3 min)

```powershell
# Tester le backend
Invoke-WebRequest https://taxe-backend.herokuapp.com/health
# Doit retourner: {"status": "healthy"}

# Ouvrir le frontend
heroku open --app taxe-frontend
# Doit ouvrir: https://taxe-frontend.herokuapp.com/

# Vérifier les logs
heroku logs --app taxe-backend -n 50
heroku logs --app taxe-frontend -n 50
```

---

## 🔐 Ajouter des Variables d'Environnement Supplémentaires

### BambooPay

```powershell
heroku config:set `
  BAMBOOPAY_MERCHANT_ID="6008889" `
  BAMBOOPAY_MERCHANT_SECRET="your-secret" `
  BAMBOOPAY_MERCHANT_USERNAME="6008889" `
  --app taxe-backend
```

### Email (SMTP)

```powershell
heroku config:set `
  SMTP_HOST="smtp.gmail.com" `
  SMTP_PORT="587" `
  SMTP_USER="your-email@gmail.com" `
  SMTP_PASSWORD="your-app-password" `
  SMTP_FROM="your-email@gmail.com" `
  --app taxe-backend
```

### Keycloak (optionnel)

```powershell
heroku config:set `
  KEYCLOAK_URL="https://your-keycloak.com" `
  KEYCLOAK_REALM="taxe" `
  KEYCLOAK_CLIENT_ID="taxe-frontend" `
  --app taxe-frontend
```

---

## 📊 Commandes Utiles

```powershell
# Voir toutes les variables
heroku config --app taxe-backend
heroku config --app taxe-frontend

# Modifier une variable
heroku config:set SECRET_KEY="new-value" --app taxe-backend

# Supprimer une variable
heroku config:unset VARIABLE_NAME --app taxe-backend

# Voir les ressources (dynos, addons)
heroku ps --app taxe-backend
heroku addons --app taxe-backend

# Logs en temps réel
heroku logs -f --app taxe-backend

# Accéder à la console Python
heroku run python --app taxe-backend

# Accéder à PostgreSQL
heroku pg:psql --app taxe-backend

# Backup de la DB
heroku pg:backups:capture --app taxe-backend
heroku pg:backups:download b001 --app taxe-backend

# Restart l'app
heroku restart --app taxe-backend
```

---

## 🔄 Mises à Jour du Code

Après des modifications:

```powershell
# Commit
git add .
git commit -m "Description du changement"

# Redéployer le backend
cd backend
git push heroku-backend main

# OU redéployer le frontend
cd frontend/frontend
git push heroku-frontend main
```

---

## 🚨 Dépannage

### "Port already in use"
→ Vérifier que le Procfile utilise `$PORT`

### "could not connect to database"
→ Vérifier que `DATABASE_URL` est défini: `heroku config:get DATABASE_URL --app taxe-backend`

### "Build failed"
→ Voir les logs: `heroku logs -f --app taxe-backend`

### "H14 - No web processes running"
→ Procfile problématique. Vérifier la syntaxe.

### "CORS error in frontend"
→ Backend CORS_ORIGINS manquant. Ajouter le domaine du frontend.

---

## 💾 Backups & Maintenance

```powershell
# Backup manuel
heroku pg:backups:capture --app taxe-backend

# Lister les backups
heroku pg:backups --app taxe-backend

# Télécharger un backup
heroku pg:backups:download b001 --app taxe-backend

# Configurer les backups automatiques
heroku pg:backups:schedule daily '11:00 UTC' --app taxe-backend
```

---

## 📈 Monitoring

```powershell
# Métriques de performance
heroku ps --app taxe-backend
heroku metrics runtime.uptime --app taxe-backend | head -n 20

# Erreurs récentes
heroku logs --app taxe-backend | Select-String "ERROR"

# Déploiements
heroku releases --app taxe-backend

# Analyser les performances
heroku releases:info v123 --app taxe-backend
```

---

## 🎯 Coûts Estimés (par mois)

- Backend Dyno (Standard-1X): ~$50
- Frontend Dyno (Standard-1X): ~$50
- PostgreSQL (Standard-0): ~$9
- **Total: ~$110/mois**

Pour réduire les coûts:
- Utiliser `Eco` plan (~$5/mois par dyno) - MAIS avec dormancy
- Considérer Render.com, Fly.io ou Railway.app (gratuit/cheaper)

---

## 📚 Ressources

- Heroku Dashboard: https://dashboard.heroku.com/apps
- Heroku CLI Docs: https://devcenter.heroku.com/articles/heroku-cli
- PostgreSQL on Heroku: https://devcenter.heroku.com/articles/heroku-postgresql
- Guide Complet: [HEROKU_DEPLOY_GUIDE.md](HEROKU_DEPLOY_GUIDE.md)

---

**Status**: ✅ Prêt pour le déploiement
**Durée estimée**: 20-30 minutes (setup + déploiement + vérification)
