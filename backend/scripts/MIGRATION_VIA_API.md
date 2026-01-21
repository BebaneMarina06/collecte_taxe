# 🚀 Migration des Données via l'API REST

Cette méthode contourne les problèmes de connexion directe à la base de données Render en utilisant l'API REST.

---

## 🎯 Pourquoi utiliser cette méthode ?

- ✅ **Contourne les timeouts** de connexion directe
- ✅ **Fonctionne même si** la base Render est en veille
- ✅ **Utilise l'API** qui est toujours accessible
- ✅ **Validation automatique** des données

---

## 📋 Prérequis

1. ✅ Base de données locale avec des données
2. ✅ API Render déployée et accessible
3. ✅ Identifiants administrateur

---

## 🚀 Utilisation

### Étape 1 : Obtenir l'URL de votre API Render

Dans Render Dashboard → Votre Service Web → URL

Exemple : `https://e-taxe-api.onrender.com`

### Étape 2 : Exécuter le script

```powershell
cd C:\Users\Marina\Documents\e_taxe_back_office\backend\scripts

python migrate_via_api.py `
  --api-url "https://votre-app.onrender.com" `
  --email "admin@example.com" `
  --password "votre_mot_de_passe"
```

---

## 📊 Données Migrées

Cette méthode migre :

- ✅ **Zones** géographiques
- ✅ **Collecteurs** avec leurs informations
- ✅ **Quartiers** (si les endpoints existent)
- ✅ **Types de contribuables** (si les endpoints existent)
- ✅ **Services** (si les endpoints existent)
- ✅ **Taxes** (si les endpoints existent)

---

## ⚠️ Limitations

Cette méthode ne migre **pas automatiquement** :

- ❌ **Contribuables** (nécessite des relations complexes)
- ❌ **Collectes** (historique)
- ❌ **Affectations de taxes**
- ❌ **Utilisateurs** (sécurité)

Pour ces données, utilisez :
1. Le fichier dump SQL créé précédemment
2. Ou migrez-les manuellement via l'interface

---

## 💡 Alternative : Utiliser le fichier dump avec pgAdmin ou DBeaver

Si la connexion directe ne fonctionne pas, vous pouvez :

1. **Télécharger pgAdmin** ou **DBeaver** (gratuit)
2. **Se connecter** à Render avec l'External Database URL
3. **Exécuter** le fichier dump SQL créé

### Avec DBeaver :

1. Téléchargez DBeaver : https://dbeaver.io/
2. Créez une nouvelle connexion PostgreSQL
3. Utilisez l'External Database URL de Render
4. Ouvrez le fichier `migration_render_*.sql`
5. Exécutez le script

---

## 🔄 Méthode Hybride Recommandée

1. **Migrer les données principales** via l'API (zones, collecteurs)
2. **Migrer les données complexes** via le dump SQL avec DBeaver/pgAdmin

---

## 📝 Exemple Complet

```powershell
# 1. Migration via API (données principales)
python migrate_via_api.py `
  --api-url "https://e-taxe-api.onrender.com" `
  --email "admin@mairie.ga" `
  --password "motdepasse"

# 2. Pour les autres données, utilisez DBeaver avec le fichier dump
#    backend/migration_render_20260119_093303.sql
```

---

## ✅ Vérification

Après la migration, vérifiez via l'API :

```bash
# Liste des collecteurs
curl https://votre-app.onrender.com/api/collecteurs \
  -H "Authorization: Bearer VOTRE_TOKEN"

# Liste des zones
curl https://votre-app.onrender.com/api/references/zones \
  -H "Authorization: Bearer VOTRE_TOKEN"
```

Ou via Swagger : `https://votre-app.onrender.com/docs`

---

Bon succès ! 🚀

