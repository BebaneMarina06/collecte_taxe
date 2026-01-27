# Migrations de la base de données

## Migration: Create collecte_location table

### Description
Cette migration crée la table `collecte_location` pour stocker la géolocalisation des collectes.

### Comment exécuter la migration

#### Option 1: Via Python (recommandé)
```bash
# Depuis le dossier backend
python migrations/run_migration.py
```

#### Option 2: Via psql (PostgreSQL CLI)
```bash
# Connexion à la base de données
psql -h <host> -U <user> -d <database>

# Exécuter le script SQL
\i migrations/create_collecte_location.sql
```

#### Option 3: Via DBeaver / pgAdmin
1. Ouvrir DBeaver ou pgAdmin
2. Se connecter à la base de données
3. Ouvrir le fichier `create_collecte_location.sql`
4. Exécuter le script

### Vérification
Pour vérifier que la table a été créée :
```sql
-- Vérifier l'existence de la table
SELECT EXISTS (
   SELECT FROM information_schema.tables
   WHERE table_schema = 'public'
   AND table_name = 'collecte_location'
);

-- Voir la structure de la table
\d collecte_location
```

### Rollback
Pour supprimer la table si nécessaire :
```sql
DROP TABLE IF EXISTS collecte_location CASCADE;
```
