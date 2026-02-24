#!/bin/bash
# Script de déploiement rapide sur Heroku

set -e

echo "🚀 Début du déploiement Collecte Taxe sur Heroku"
echo ""

# Vérifier que Heroku CLI est installée
if ! command -v heroku &> /dev/null; then
    echo "❌ Heroku CLI non trouvée. Installez-la depuis https://devcenter.heroku.com/articles/heroku-cli"
    exit 1
fi

# Vérifier que git est initialisé
if [ ! -d .git ]; then
    echo "❌ Pas de repository git. Exécutez: git init && git add . && git commit -m 'Initial commit'"
    exit 1
fi

echo "✅ Heroku CLI détectée"
echo ""

# Déployer le backend
echo "📦 Déploiement du backend..."
cd backend

# Créer le remote si n'existe pas
heroku git:remote -a taxe-backend -n heroku-backend 2>/dev/null || true

# Déployer
git push heroku-backend main 2>/dev/null || git push heroku-backend master || true

echo "✅ Backend déployé"
echo ""

# Revenir à la racine
cd ..

# Déployer le frontend
echo "📦 Déploiement du frontend..."
cd frontend/frontend

# Créer le remote si n'existe pas
heroku git:remote -a taxe-frontend -n heroku-frontend 2>/dev/null || true

# Déployer en utilisant subtree
git push heroku-frontend main 2>/dev/null || git push heroku-frontend master || true

echo "✅ Frontend déployé"
echo ""

echo "🎉 Déploiement terminé !"
echo ""
echo "Prochaines étapes:"
echo "1. Vérifier les logs: heroku logs -f --app taxe-backend"
echo "2. Initialiser la BD: heroku run python database/init_db.py --app taxe-backend"
echo "3. Charger les seeders: heroku run python database/run_seeders.py --app taxe-backend"
echo "4. Ouvrir l'app: heroku open --app taxe-frontend"
