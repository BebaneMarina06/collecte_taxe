#!/bin/bash
# Script de vérification de l'implémentation responsivité
# À exécuter après l'implémentation pour vérifier que tout est en place

echo "╔════════════════════════════════════════════════════════════╗"
echo "║   Vérification de l'implémentation Responsivité et Zoom    ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Couleurs pour les messages
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Compteurs
total=0
passed=0
failed=0

# Fonction pour vérifier un fichier
check_file() {
    local file=$1
    local description=$2
    
    total=$((total + 1))
    
    if [ -f "$file" ]; then
        echo -e "${GREEN}✓${NC} $description"
        passed=$((passed + 1))
    else
        echo -e "${RED}✗${NC} $description (fichier manquant: $file)"
        failed=$((failed + 1))
    fi
}

# Fonction pour vérifier un dossier
check_dir() {
    local dir=$1
    local description=$2
    
    total=$((total + 1))
    
    if [ -d "$dir" ]; then
        echo -e "${GREEN}✓${NC} $description"
        passed=$((passed + 1))
    else
        echo -e "${RED}✗${NC} $description (dossier manquant: $dir)"
        failed=$((failed + 1))
    fi
}

# Vérifier les fichiers créés
echo "📋 Vérification des fichiers créés:"
echo "════════════════════════════════════════════════════════════"

check_file "src/app/services/responsive.service.ts" "Service ResponsiveService"
check_file "src/app/components/responsive-debugger/responsive-debugger.component.ts" "Composant Debugger"
check_dir "src/app/components/responsive-debugger" "Dossier Debugger"

echo ""
echo "📋 Vérification des fichiers modifiés:"
echo "════════════════════════════════════════════════════════════"

check_file "src/index.html" "HTML Principal (modifié)"
check_file "src/styles.scss" "Styles Globaux (modifié)"
check_file "src/app/app.component.ts" "App Component (modifié)"
check_file "tailwind.config.js" "Configuration Tailwind"

echo ""
echo "📋 Vérification de la documentation:"
echo "════════════════════════════════════════════════════════════"

check_file "RESPONSIVE_GUIDE.md" "Guide Complet"
check_file "RESPONSIVE_EXAMPLES.ts" "Exemples de Code"
check_file "RESPONSIVE_IMPLEMENTATION.md" "Détails d'Implémentation"
check_file "RESPONSIVE_FAQ.md" "Questions Fréquentes"
check_file "RESPONSIVE_QUALITY_CHECKLIST.ts" "Checklist Qualité"
check_file "RESPONSIVE_QUICKSTART.md" "Démarrage Rapide"
check_file "RESPONSIVE_SUMMARY.md" "Résumé Exécutif"
check_file "RESPONSIVE_DOCUMENTATION.md" "Documentation Complète"
check_file "README_RESPONSIVE.md" "Index de Documentation"

echo ""
echo "════════════════════════════════════════════════════════════"
echo "📊 Résumé:"
echo "════════════════════════════════════════════════════════════"
echo -e "Total vérifications: $total"
echo -e "${GREEN}Réussis: $passed${NC}"
echo -e "${RED}Échoués: $failed${NC}"

echo ""
echo "════════════════════════════════════════════════════════════"

if [ $failed -eq 0 ]; then
    echo -e "${GREEN}✓ Toutes les vérifications sont passées!${NC}"
    echo ""
    echo "🚀 Prochaines étapes:"
    echo "1. npm install (si nécessaire)"
    echo "2. npm start (lancer l'app)"
    echo "3. F12 pour ouvrir DevTools"
    echo "4. Ctrl+Shift+M pour activer Device Mode"
    echo "5. Tester avec différentes résolutions"
    echo ""
    echo "📚 Pour en savoir plus:"
    echo "   Lire: README_RESPONSIVE.md"
    exit 0
else
    echo -e "${RED}✗ Certaines vérifications ont échoué!${NC}"
    echo ""
    echo "⚠️ Fichiers manquants détectés. Assurez-vous que:"
    echo "1. Vous êtes dans le bon répertoire (frontend/)"
    echo "2. Tous les fichiers ont été créés/modifiés"
    echo "3. Les chemins sont corrects"
    echo ""
    exit 1
fi
