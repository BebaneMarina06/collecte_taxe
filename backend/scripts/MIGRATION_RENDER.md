# 🚀 Guide de Migration des Données vers Render

Ce guide vous explique comment migrer toutes vos données de la base PostgreSQL locale vers Render.

---

## 📋 Prérequis

1. ✅ Base de données locale PostgreSQL avec des données
2. ✅ Base de données Render créée
3. ✅ Python 3.8+ installé
4. ✅ PostgreSQL installé (pour pg_dump) - optionnel

---

## 🎯 Méthode 1 : Migration Automatique (Recommandée)

### Étape 1 : Obtenir l'URL de la base Render

Dans Render Dashboard → Votre Base de Données → **External Database URL**

Format :
```
postgresql://user:password@host:port/database
```

⚠️ **Important** : Utilisez l'**External Database URL** (pas Internal) pour la migration depuis votre machine locale.

### Étape 2 : Configurer l'URL de la base locale

Ouvrez votre fichier `.env` dans `backend/.env` et vérifiez que `DATABASE_URL` pointe vers votre base locale :

```env
DATABASE_URL=postgresql://postgres:mot_de_passe@localhost:5432/taxe_municipale
```

### Étape 3 : Exécuter le script de migration

```powershell
cd backend\scripts
python migrate_to_render.py --render-db-url "postgresql://user:password@host:port/database"
```

Le script va :
1. ✅ Exporter toutes les données de votre base locale
2. ✅ Créer un fichier dump SQL
3. ✅ Importer les données dans Render
4. ✅ Vérifier que la migration a réussi

---

## 🎯 Méthode 2 : Export puis Import Séparés

### Étape 1 : Exporter uniquement

```powershell
python migrate_to_render.py --export-only --render-db-url "URL_RENDER"
```

Cela créera un fichier `migration_render_YYYYMMDD_HHMMSS.sql` dans le dossier `backend/`.

### Étape 2 : Importer dans Render

```powershell
python migrate_to_render.py --import-only "backend\migration_render_20240101_120000.sql" --render-db-url "URL_RENDER"
```

---

## 🎯 Méthode 3 : Utiliser Python au lieu de pg_dump

Si `pg_dump` n'est pas disponible, utilisez l'option `--use-python` :

```powershell
python migrate_to_render.py --use-python --render-db-url "URL_RENDER"
```

⚠️ **Note** : Cette méthode est plus lente mais ne nécessite pas pg_dump.

---

## 📝 Exemples Complets

### Exemple 1 : Migration complète

```powershell
# Aller dans le dossier scripts
cd C:\Users\Marina\Documents\e_taxe_back_office\backend\scripts

# Migration complète
python migrate_to_render.py --render-db-url "postgresql://taxe_municipale_7dqx_user:password@dpg-d5mnj0f5r7bs73d96n10-a.oregon-postgres.render.com:5432/taxe_municipale_7dqx"
```

### Exemple 2 : Spécifier la base locale

```powershell
python migrate_to_render.py `
  --local-db-url "postgresql://postgres:admin@localhost:5432/taxe_municipale" `
  --render-db-url "postgresql://user:pass@host:port/db"
```

### Exemple 3 : Export uniquement

```powershell
python migrate_to_render.py `
  --export-only `
  --render-db-url "postgresql://user:pass@host:port/db"
```

Puis importer plus tard :

```powershell
python migrate_to_render.py `
  --import-only "backend\migration_render_20240101_120000.sql" `
  --render-db-url "postgresql://user:pass@host:port/db"
```

---

## 🔍 Vérification de la Migration

Le script vérifie automatiquement après l'importation. Vous pouvez aussi vérifier manuellement :

### Via l'API

```bash
curl -X GET "https://votre-app.onrender.com/api/collecteurs" \
  -H "Authorization: Bearer VOTRE_TOKEN"
```

### Via la Documentation Swagger

1. Allez sur `https://votre-app.onrender.com/docs`
2. Connectez-vous
3. Testez les endpoints pour voir vos données

---

## ⚠️ Problèmes Courants

### Erreur : "could not connect to server"

**Problème** : La connexion à Render échoue.

**Solutions** :
1. Vérifiez que vous utilisez l'**External Database URL** (pas Internal)
2. Vérifiez que le mot de passe est correct
3. Vérifiez que la base de données Render est active (pas en veille)

### Erreur : "pg_dump n'est pas trouvé"

**Solution** :
- Installez PostgreSQL (qui inclut pg_dump)
- OU utilisez `--use-python` pour exporter avec Python

### Erreur : "duplicate key" ou "already exists"

**Solution** : C'est normal si certaines données existent déjà. Le script ignore ces erreurs.

### Erreur : "Extension postgis does not exist"

**Solution** : Le script active automatiquement PostGIS. Si cela échoue, activez-le manuellement dans Render :

```sql
CREATE EXTENSION IF NOT EXISTS postgis;
```

### Migration partielle

Si la migration s'arrête en cours de route :
1. Le fichier dump est sauvegardé
2. Vous pouvez réessayer avec `--import-only`
3. Ou nettoyer la base Render et recommencer

---

## 📊 Tables Migrées

Le script migre toutes les tables suivantes (dans l'ordre) :

- ✅ `service`
- ✅ `type_taxe`
- ✅ `zone`
- ✅ `quartier`
- ✅ `type_contribuable`
- ✅ `collecteur`
- ✅ `contribuable`
- ✅ `taxe`
- ✅ `affectation_taxe`
- ✅ `info_collecte`
- ✅ `utilisateur`
- ✅ `zone_geographique`
- ✅ `dossier_impaye`
- ✅ `relance`
- ✅ `caisse`
- ✅ `operation_caisse`
- ✅ `journal`
- ✅ `coupure`
- ✅ `transaction_bamboopay`

---

## 💡 Conseils

1. **Faites un backup** de votre base locale avant la migration
2. **Testez d'abord** avec quelques données sur un environnement de test
3. **Vérifiez les données** après la migration
4. **Conservez le fichier dump** au cas où vous auriez besoin de réimporter

---

## 🆘 Besoin d'aide ?

Si la migration échoue :
1. Vérifiez les logs du script
2. Vérifiez que les URLs sont correctes
3. Vérifiez que les deux bases de données sont accessibles
4. Essayez la méthode export/import séparée

---

Bon succès avec votre migration ! 🚀

