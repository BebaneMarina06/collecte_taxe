@echo off
REM Script de vérification de l'implémentation responsivité (Windows)
REM À exécuter après l'implémentation pour vérifier que tout est en place

setlocal enabledelayedexpansion
title Vérification Responsivité et Zoom

echo.
echo ╔════════════════════════════════════════════════════════════╗
echo ║   Vérification de l'implémentation Responsivité et Zoom    ║
echo ╚════════════════════════════════════════════════════════════╝
echo.

REM Compteurs
set /a total=0
set /a passed=0
set /a failed=0

REM Fonction pour vérifier un fichier
:check_file
set file=%1
set description=%2

set /a total=!total!+1

if exist "!file!" (
    color 2
    echo [OK] !description!
    color 7
    set /a passed=!passed!+1
    goto :eof
) else (
    color 4
    echo [FAIL] !description! (fichier manquant: !file!)
    color 7
    set /a failed=!failed!+1
    goto :eof
)

REM Vérifier les fichiers créés
echo.
echo 📋 Vérification des fichiers créés:
echo ════════════════════════════════════════════════════════════
call :check_file "src\app\services\responsive.service.ts" "Service ResponsiveService"
call :check_file "src\app\components\responsive-debugger\responsive-debugger.component.ts" "Composant Debugger"
if exist "src\app\components\responsive-debugger" (
    color 2
    echo [OK] Dossier Debugger
    color 7
    set /a passed=!passed!+1
) else (
    color 4
    echo [FAIL] Dossier Debugger (manquant)
    color 7
    set /a failed=!failed!+1
)
set /a total=!total!+1

echo.
echo 📋 Vérification des fichiers modifiés:
echo ════════════════════════════════════════════════════════════
call :check_file "src\index.html" "HTML Principal (modifié)"
call :check_file "src\styles.scss" "Styles Globaux (modifié)"
call :check_file "src\app\app.component.ts" "App Component (modifié)"
call :check_file "tailwind.config.js" "Configuration Tailwind"

echo.
echo 📋 Vérification de la documentation:
echo ════════════════════════════════════════════════════════════
call :check_file "RESPONSIVE_GUIDE.md" "Guide Complet"
call :check_file "RESPONSIVE_EXAMPLES.ts" "Exemples de Code"
call :check_file "RESPONSIVE_IMPLEMENTATION.md" "Détails d'Implémentation"
call :check_file "RESPONSIVE_FAQ.md" "Questions Fréquentes"
call :check_file "RESPONSIVE_QUALITY_CHECKLIST.ts" "Checklist Qualité"
call :check_file "RESPONSIVE_QUICKSTART.md" "Démarrage Rapide"
call :check_file "RESPONSIVE_SUMMARY.md" "Résumé Exécutif"
call :check_file "RESPONSIVE_DOCUMENTATION.md" "Documentation Complète"
call :check_file "README_RESPONSIVE.md" "Index de Documentation"

echo.
echo ════════════════════════════════════════════════════════════
echo 📊 Résumé:
echo ════════════════════════════════════════════════════════════
echo Total vérifications: !total!
color 2
echo Réussis: !passed!
color 7
if !failed! gtr 0 (
    color 4
)
echo Échoués: !failed!
color 7

echo.
echo ════════════════════════════════════════════════════════════

if !failed! equ 0 (
    color 2
    echo ✓ Toutes les vérifications sont passées!
    color 7
    echo.
    echo 🚀 Prochaines étapes:
    echo 1. npm install (si nécessaire^)
    echo 2. npm start (lancer l'app^)
    echo 3. F12 pour ouvrir DevTools
    echo 4. Ctrl+Shift+M pour activer Device Mode
    echo 5. Tester avec différentes résolutions
    echo.
    echo 📚 Pour en savoir plus:
    echo    Lire: README_RESPONSIVE.md
    echo.
    pause
    exit /b 0
) else (
    color 4
    echo ✗ Certaines vérifications ont échoué!
    color 7
    echo.
    echo ⚠️ Fichiers manquants détectés. Assurez-vous que:
    echo 1. Vous êtes dans le bon répertoire (frontend^)
    echo 2. Tous les fichiers ont été créés/modifiés
    echo 3. Les chemins sont corrects
    echo.
    pause
    exit /b 1
)
