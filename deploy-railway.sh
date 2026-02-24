#!/bin/bash
# Script de guide Railway pour Linux/Mac

echo ""
echo "╔════════════════════════════════════════════╗"
echo "║   Déploiement Railway.app - Collecte Taxe  ║"
echo "║          Prêt pour le déploiement!         ║"
echo "╚════════════════════════════════════════════╝"
echo ""

echo "📋 Prérequis:"
echo "  ✓ Compte GitHub (gratuit)"
echo "  ✓ Code poussé sur GitHub"
echo "  ✓ Compte Railway (https://railway.app)"
echo ""

echo "🔍 Vérification des prérequis..."
echo ""

# Vérifier git
if ! command -v git &> /dev/null; then
    echo "❌ Git non trouvé"
    exit 1
fi
echo "✅ Git: OK"

# Vérifier remote GitHub
if git remote -v | grep -q "github.com"; then
    echo "✅ Remote GitHub: OK"
else
    echo "⚠️  Pas de remote GitHub configuré"
fi

echo ""
echo "📚 Guide de Déploiement:"
echo ""
echo "1️⃣  Créer un Compte Railway (gratuit)"
echo "   → https://railway.app"
echo "   → Connectez-vous avec GitHub"
echo "   → Vous obtenez \$5 de crédit gratuit!"
echo ""

echo "2️⃣  Pousser le Code sur GitHub"
echo "   → git add ."
echo "   → git commit -m 'Prêt pour Railway'"
echo "   → git push origin main"
echo ""

echo "3️⃣  Déployer depuis Railway Dashboard"
echo "   → Allez sur: https://railway.app/dashboard"
echo "   → Cliquez 'New Project'"
echo "   → Sélectionnez 'Import from GitHub'"
echo "   → Choisissez 'collecte-taxe'"
echo "   → Railway détecte le Dockerfile automatiquement"
echo "   → Cliquez 'Deploy'"
echo ""

echo "4️⃣  Initialiser la Base de Données"
echo "   → Dans Railway Dashboard:"
echo "     • Service Backend → 'Shell' tab"
echo "     • Exécutez: python database/init_db.py"
echo "     • Puis: python database/run_seeders.py"
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "💰 Coûts:"
echo "  • Crédit gratuit: \$5 (valide 1-2 mois)"
echo "  • Après crédit: ~\$5-10/mois (vs Heroku: \$110/mois!)"
echo ""
echo "📚 Documentation Complète:"
echo "  → Voir: RAILWAY_DEPLOY_GUIDE.md"
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Commencez ici: https://railway.app/dashboard"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
