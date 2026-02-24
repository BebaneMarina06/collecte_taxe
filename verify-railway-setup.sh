#!/bin/bash
# Vérifier les fichiers de déploiement Railway

echo "🔍 Vérification des fichiers Railway..."
echo ""

files=(
    "backend/Dockerfile.railway"
    "backend/requirements.txt"
    "backend/main.py"
    "frontend/frontend/Dockerfile.heroku"
    "frontend/frontend/server.js"
    "frontend/frontend/package.json"
    "railway.json"
)

missing=0

for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file"
    else
        echo "❌ $file (manquant)"
        missing=$((missing + 1))
    fi
done

echo ""

if [ $missing -eq 0 ]; then
    echo "🎉 Tous les fichiers sont prêts pour Railway!"
    echo ""
    echo "Prochaines étapes:"
    echo "1. Créer un compte: https://railway.app"
    echo "2. Pousser le code: git push origin main"
    echo "3. Lancer le déploiement depuis le dashboard Railway"
else
    echo "❌ $missing fichiers manquent"
    echo ""
    echo "Assurez-vous que vous êtes dans le dossier racine du projet"
fi
