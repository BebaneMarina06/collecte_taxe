#!/bin/bash
# Script de configuration Heroku - À exécuter AVANT le déploiement
# Usage: ./setup-heroku.sh

set -e

echo "⚙️  Configuration Heroku pour Collecte Taxe"
echo ""

# Vérifier Heroku CLI
if ! command -v heroku &> /dev/null; then
    echo "❌ Heroku CLI non trouvée"
    exit 1
fi

# Générer une clé secrète
echo "🔑 Génération de la clé secrète JWT..."
SECRET_KEY=$(openssl rand -hex 32)
echo "Clé générée: $SECRET_KEY"
echo ""

# Variables de configuration
read -p "Nom de l'app backend Heroku [taxe-backend]: " BACKEND_APP
BACKEND_APP=${BACKEND_APP:-taxe-backend}

read -p "Nom de l'app frontend Heroku [taxe-frontend]: " FRONTEND_APP
FRONTEND_APP=${FRONTEND_APP:-taxe-frontend}

read -p "URL du frontend pour CORS [https://$FRONTEND_APP.herokuapp.com]: " CORS_URL
CORS_URL=${CORS_URL:-https://$FRONTEND_APP.herokuapp.com}

echo ""
echo "📋 Configuration du backend..."

# Configurer les variables d'environnement du backend
heroku config:set \
  SECRET_KEY="$SECRET_KEY" \
  ENVIRONMENT=production \
  DEBUG=False \
  CORS_ORIGINS="$CORS_URL" \
  BAMBOOPAY_DEBUG=false \
  --app $BACKEND_APP

echo ""
echo "✅ Backend configuré"

echo ""
echo "📋 Configuration du frontend..."

# Configurer les variables d'environnement du frontend
heroku config:set \
  API_BASE_URL="https://$BACKEND_APP.herokuapp.com/api" \
  --app $FRONTEND_APP

echo ""
echo "✅ Frontend configuré"

echo ""
echo "🗄️  Configuration de PostgreSQL..."

# Créer l'addon PostgreSQL si n'existe pas
heroku addons:create heroku-postgresql:standard-0 \
  --version=16 \
  --app $BACKEND_APP || echo "   PostgreSQL déjà configuré"

echo ""
echo "✅ PostgreSQL configuré"

echo ""
echo "🎉 Configuration terminée!"
echo ""
echo "Vérifier la configuration:"
echo "   heroku config --app $BACKEND_APP"
echo "   heroku config --app $FRONTEND_APP"
