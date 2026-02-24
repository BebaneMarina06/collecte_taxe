# Script PowerShell de déploiement sur Heroku

Write-Host "🚀 Début du déploiement Collecte Taxe sur Heroku" -ForegroundColor Green
Write-Host ""

# Vérifier que Heroku CLI est installée
$herokuCheck = heroku --version -ErrorAction SilentlyContinue
if ($null -eq $herokuCheck) {
    Write-Host "❌ Heroku CLI non trouvée. Installez-la depuis https://devcenter.heroku.com/articles/heroku-cli" -ForegroundColor Red
    exit 1
}

# Vérifier que git est initialisé
if (!(Test-Path ".git")) {
    Write-Host "❌ Pas de repository git. Exécutez d'abord:" -ForegroundColor Red
    Write-Host "   git init && git add . && git commit -m 'Initial commit'" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ Heroku CLI détectée" -ForegroundColor Green
Write-Host ""

# Étape 1: Déployer le backend
Write-Host "📦 Déploiement du BACKEND..." -ForegroundColor Cyan
Push-Location backend

# Créer le remote si n'existe pas
try {
    heroku git:remote -a taxe-backend -n heroku-backend -ErrorAction SilentlyContinue
} catch {}

# Déployer
Write-Host "   Envoi du code vers Heroku..." -ForegroundColor Yellow
try {
    git push heroku-backend main
} catch {
    Write-Host "   Essai avec master..." -ForegroundColor Yellow
    git push heroku-backend master
}

Write-Host "✅ Backend déployé" -ForegroundColor Green
Pop-Location
Write-Host ""

# Étape 2: Déployer le frontend
Write-Host "📦 Déploiement du FRONTEND..." -ForegroundColor Cyan
Push-Location "frontend\frontend"

# Créer le remote si n'existe pas
try {
    heroku git:remote -a taxe-frontend -n heroku-frontend -ErrorAction SilentlyContinue
} catch {}

# Déployer
Write-Host "   Envoi du code vers Heroku..." -ForegroundColor Yellow
try {
    git push heroku-frontend main
} catch {
    Write-Host "   Essai avec master..." -ForegroundColor Yellow
    git push heroku-frontend master
}

Write-Host "✅ Frontend déployé" -ForegroundColor Green
Pop-Location
Write-Host ""

Write-Host "🎉 Déploiement terminé !" -ForegroundColor Green
Write-Host ""
Write-Host "Prochaines étapes à effectuer:" -ForegroundColor Yellow
Write-Host "1. Vérifier les logs:" -ForegroundColor White
Write-Host "   heroku logs -f --app taxe-backend" -ForegroundColor Gray
Write-Host ""
Write-Host "2. Initialiser la base de données:" -ForegroundColor White
Write-Host "   heroku run python database/init_db.py --app taxe-backend" -ForegroundColor Gray
Write-Host ""
Write-Host "3. Charger les seeders:" -ForegroundColor White
Write-Host "   heroku run python database/run_seeders.py --app taxe-backend" -ForegroundColor Gray
Write-Host ""
Write-Host "4. Ouvrir l'application:" -ForegroundColor White
Write-Host "   heroku open --app taxe-frontend" -ForegroundColor Gray
Write-Host ""
Write-Host "Documentation complète: HEROKU_DEPLOY_GUIDE.md" -ForegroundColor Cyan
