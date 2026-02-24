# 🚀 Script PowerShell de Déploiement Railway

Write-Host "
╔════════════════════════════════════════════╗
║   Déploiement Railway.app - Collecte Taxe  ║
║          Prêt pour le déploiement!         ║
╚════════════════════════════════════════════╝
" -ForegroundColor Cyan

Write-Host ""
Write-Host "📋 Prérequis:" -ForegroundColor Yellow
Write-Host "  ✓ Compte GitHub (gratuit)" -ForegroundColor Gray
Write-Host "  ✓ Code poussé sur GitHub" -ForegroundColor Gray
Write-Host "  ✓ Compte Railway (https://railway.app)" -ForegroundColor Gray
Write-Host ""

# Vérifier les prérequis
Write-Host "🔍 Vérification des prérequis..." -ForegroundColor Cyan
Write-Host ""

# Vérifier git
$gitCheck = git --version -ErrorAction SilentlyContinue
if ($null -eq $gitCheck) {
    Write-Host "❌ Git non trouvé" -ForegroundColor Red
    exit 1
}
Write-Host "✅ Git: OK" -ForegroundColor Green

# Vérifier repo GitHub
$remoteCheck = git remote -v 2>&1 | Select-String "github.com"
if ($null -eq $remoteCheck) {
    Write-Host "⚠️  Pas de remote GitHub détecté" -ForegroundColor Yellow
    Write-Host "   Créez un repo GitHub et configurez:" -ForegroundColor Gray
    Write-Host "   git remote add origin https://github.com/USER/collecte-taxe.git" -ForegroundColor Gray
    Write-Host ""
} else {
    Write-Host "✅ Remote GitHub: OK" -ForegroundColor Green
}

Write-Host ""
Write-Host "📚 Guide de Déploiement:" -ForegroundColor Cyan
Write-Host ""
Write-Host "1️⃣  Créer un Compte Railway (gratuit)" -ForegroundColor Yellow
Write-Host "   → https://railway.app" -ForegroundColor Gray
Write-Host "   → Connectez-vous avec GitHub" -ForegroundColor Gray
Write-Host "   → Vous obtenez \$5 de crédit gratuit!" -ForegroundColor Gray
Write-Host ""

Write-Host "2️⃣  Pousser le Code sur GitHub" -ForegroundColor Yellow
Write-Host "   → git add ." -ForegroundColor Gray
Write-Host "   → git commit -m 'Prêt pour Railway'" -ForegroundColor Gray
Write-Host "   → git push origin main" -ForegroundColor Gray
Write-Host ""

Write-Host "3️⃣  Déployer depuis Railway Dashboard" -ForegroundColor Yellow
Write-Host "   → Allez sur: https://railway.app/dashboard" -ForegroundColor Gray
Write-Host "   → Cliquez 'New Project'" -ForegroundColor Gray
Write-Host "   → Sélectionnez 'Import from GitHub'" -ForegroundColor Gray
Write-Host "   → Choisissez 'collecte-taxe'" -ForegroundColor Gray
Write-Host "   → Railway détecte le Dockerfile automatiquement" -ForegroundColor Gray
Write-Host "   → Cliquez 'Deploy'" -ForegroundColor Gray
Write-Host ""

Write-Host "4️⃣  Attendre le Déploiement (5-10 min)" -ForegroundColor Yellow
Write-Host "   → Railway va:" -ForegroundColor Gray
Write-Host "     ✓ Cloner le repo" -ForegroundColor Gray
Write-Host "     ✓ Builder le Dockerfile" -ForegroundColor Gray
Write-Host "     ✓ Créer PostgreSQL" -ForegroundColor Gray
Write-Host "     ✓ Lancer les conteneurs" -ForegroundColor Gray
Write-Host "     ✓ Vous donner une URL publique" -ForegroundColor Gray
Write-Host ""

Write-Host "5️⃣  Initialiser la Base de Données" -ForegroundColor Yellow
Write-Host "   → Dans Railway Dashboard:" -ForegroundColor Gray
Write-Host "     • Service Backend → 'Shell' tab" -ForegroundColor Gray
Write-Host "     • Exécutez: python database/init_db.py" -ForegroundColor Gray
Write-Host "     • Puis: python database/run_seeders.py" -ForegroundColor Gray
Write-Host ""

Write-Host "6️⃣  Tester" -ForegroundColor Yellow
Write-Host "   → Ouvrez: https://backend-XXXX.railway.app/health" -ForegroundColor Gray
Write-Host "   → Devrait retourner: {\"status\": \"healthy\"}" -ForegroundColor Gray
Write-Host ""

Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""

Write-Host "💰 Coûts:" -ForegroundColor Yellow
Write-Host "  • Crédit gratuit: \$5 (valide 1-2 mois)" -ForegroundColor Green
Write-Host "  • Après crédit: ~\$5-10/mois (vs Heroku: \$110/mois!)" -ForegroundColor Green
Write-Host ""

Write-Host "📚 Documentation Complète:" -ForegroundColor Cyan
Write-Host "  → Voir: RAILWAY_DEPLOY_GUIDE.md" -ForegroundColor Gray
Write-Host ""

Write-Host "🆘 Besoin d'Aide?" -ForegroundColor Cyan
Write-Host "  → Docs: https://docs.railway.app" -ForegroundColor Gray
Write-Host "  → Discord: https://discord.gg/railway" -ForegroundColor Gray
Write-Host ""

Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""

$continuer = Read-Host "Êtes-vous prêt? (Y/n)"

if ($continuer -eq "n" -or $continuer -eq "N") {
    Write-Host "D'accord! Révisez le guide et relancez ce script quand vous êtes prêt." -ForegroundColor Yellow
    Write-Host "Consultez: RAILWAY_DEPLOY_GUIDE.md" -ForegroundColor Gray
    exit 0
}

Write-Host ""
Write-Host "🎯 Prochaines Étapes:" -ForegroundColor Green
Write-Host ""
Write-Host "1. Créer un compte Railway:" -ForegroundColor White
Write-Host "   https://railway.app" -ForegroundColor Cyan
Write-Host ""
Write-Host "2. Lire le guide complet:" -ForegroundColor White
Write-Host "   RAILWAY_DEPLOY_GUIDE.md" -ForegroundColor Cyan
Write-Host ""
Write-Host "3. Revenir ici une fois le code poussé sur GitHub" -ForegroundColor White
Write-Host ""

# Offrir de créer les fichiers de config
$createConfig = Read-Host "Voulez-vous que je vérifie les fichiers de config? (y/N)"

if ($createConfig -eq "y" -or $createConfig -eq "Y") {
    Write-Host ""
    Write-Host "🔍 Vérification des fichiers..." -ForegroundColor Cyan
    
    $files = @(
        ".\backend\Dockerfile.railway",
        ".\frontend\frontend\Dockerfile.heroku",
        ".\frontend\frontend\server.js",
        ".\railway.json"
    )
    
    foreach ($file in $files) {
        if (Test-Path $file) {
            Write-Host "  ✅ $file" -ForegroundColor Green
        } else {
            Write-Host "  ❌ $file (manquant)" -ForegroundColor Red
        }
    }
    
    Write-Host ""
    Write-Host "Tous les fichiers sont prêts pour Railway! 🎉" -ForegroundColor Green
}

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "Commencez ici: https://railway.app/dashboard" -ForegroundColor Yellow
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
