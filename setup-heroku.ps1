# Script PowerShell de configuration Heroku
# Usage: ./setup-heroku.ps1

Write-Host "⚙️  Configuration Heroku pour Collecte Taxe" -ForegroundColor Cyan
Write-Host ""

# Vérifier Heroku CLI
$herokuCheck = heroku --version -ErrorAction SilentlyContinue
if ($null -eq $herokuCheck) {
    Write-Host "❌ Heroku CLI non trouvée" -ForegroundColor Red
    Write-Host "Installez depuis: https://devcenter.heroku.com/articles/heroku-cli" -ForegroundColor Yellow
    exit 1
}

# Générer une clé secrète
Write-Host "🔑 Génération de la clé secrète JWT..." -ForegroundColor Green
$SECRET_KEY = -join ((0..63) | ForEach-Object { (0x0..0xf | Get-Random -Count 1 | ForEach-Object {'{0:x}' -f $_}) })
$SECRET_KEY = [System.Convert]::ToBase64String(([System.Text.Encoding]::UTF8.GetBytes($SECRET_KEY)))
Write-Host "Clé générée: $SECRET_KEY" -ForegroundColor Gray
Write-Host ""

# Valeurs par défaut
$BACKEND_APP = "taxe-backend"
$FRONTEND_APP = "taxe-frontend"
$CORS_URL = "https://$FRONTEND_APP.herokuapp.com"

Write-Host "Configuration par défaut:" -ForegroundColor Yellow
Write-Host "  Backend: $BACKEND_APP" -ForegroundColor Gray
Write-Host "  Frontend: $FRONTEND_APP" -ForegroundColor Gray
Write-Host "  CORS: $CORS_URL" -ForegroundColor Gray
Write-Host ""

$confirm = Read-Host "Utiliser ces valeurs? (Y/n)"
if ($confirm -ne "n" -and $confirm -ne "N") {
    Write-Host ""
    Write-Host "📋 Configuration du backend..." -ForegroundColor Cyan
    
    # Configurer les variables d'environnement du backend
    heroku config:set `
      SECRET_KEY="$SECRET_KEY" `
      ENVIRONMENT=production `
      DEBUG=False `
      CORS_ORIGINS="$CORS_URL" `
      BAMBOOPAY_DEBUG=false `
      --app $BACKEND_APP
    
    Write-Host "✅ Backend configuré" -ForegroundColor Green
    
    Write-Host ""
    Write-Host "📋 Configuration du frontend..." -ForegroundColor Cyan
    
    # Configurer les variables d'environnement du frontend
    heroku config:set `
      API_BASE_URL="https://$BACKEND_APP.herokuapp.com/api" `
      --app $FRONTEND_APP
    
    Write-Host "✅ Frontend configuré" -ForegroundColor Green
    
    Write-Host ""
    Write-Host "🗄️  Configuration de PostgreSQL..." -ForegroundColor Cyan
    
    # Créer l'addon PostgreSQL
    heroku addons:create heroku-postgresql:standard-0 `
      --version=16 `
      --app $BACKEND_APP -ErrorAction SilentlyContinue
    
    Write-Host "✅ PostgreSQL configuré" -ForegroundColor Green
    
    Write-Host ""
    Write-Host "🎉 Configuration terminée!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Vérifier la configuration:" -ForegroundColor Yellow
    Write-Host "   heroku config --app $BACKEND_APP" -ForegroundColor Gray
    Write-Host "   heroku config --app $FRONTEND_APP" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Prochaine étape: ./deploy-heroku.ps1" -ForegroundColor Cyan
} else {
    Write-Host "Configuration annulée" -ForegroundColor Yellow
}
