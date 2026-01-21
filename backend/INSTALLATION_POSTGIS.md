# Guide d'installation et d'activation de PostGIS

## 📋 Table des matières
1. [Dans Docker (recommandé)](#dans-docker-recommandé)
2. [Sur PostgreSQL local (Windows)](#sur-postgresql-local-windows)
3. [Sur PostgreSQL local (Linux)](#sur-postgresql-local-linux)
4. [Activation de l'extension](#activation-de-lextension)
5. [Vérification](#vérification)

---

## 🐳 Dans Docker (Recommandé)

### Installation automatique
L'image Docker `postgis/postgis:16-3.4` inclut déjà PostGIS 3.4.

**Activer PostGIS dans une base existante :**

```bash
# Se connecter au conteneur PostgreSQL
docker compose exec db psql -U postgres -d taxe_municipale

# Dans psql, exécuter :
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS postgis_topology;  -- Optionnel
```

**Ou en une seule commande :**

```bash
docker compose exec db psql -U postgres -d taxe_municipale -c "CREATE EXTENSION IF NOT EXISTS postgis;"
```

---

## 💻 Sur PostgreSQL local (Windows)

### Méthode 1 : Installation via Stack Builder (Recommandé)

1. **Télécharger PostgreSQL** depuis [postgresql.org](https://www.postgresql.org/download/windows/)
2. **Installer PostgreSQL** (ex: version 16)
3. **Lancer Stack Builder** (inclus avec PostgreSQL)
4. **Sélectionner** :
   - PostgreSQL 16 → Add-ons, Tools & Drivers
   - **PostGIS Bundle** pour votre version de PostgreSQL
5. **Installer** PostGIS Bundle

### Méthode 2 : Installation manuelle

1. **Télécharger PostGIS** depuis [postgis.net/windows_downloads](https://postgis.net/windows_downloads/)
2. **Choisir** la version correspondant à votre PostgreSQL (ex: PostGIS 3.4 pour PostgreSQL 16)
3. **Exécuter** l'installateur
4. **Activer** l'extension (voir section "Activation")

### Méthode 3 : Via Chocolatey

```powershell
# Installer PostgreSQL avec PostGIS
choco install postgresql16 --params '/Password:yourpassword'
choco install postgis --version=3.4.0
```

---

## 🐧 Sur PostgreSQL local (Linux)

### Ubuntu/Debian

```bash
# Mettre à jour les paquets
sudo apt-get update

# Installer PostgreSQL et PostGIS
sudo apt-get install postgresql-16 postgresql-16-postgis-3

# Ou pour PostgreSQL 15
sudo apt-get install postgresql-15 postgresql-15-postgis-3

# Ou pour PostgreSQL 14
sudo apt-get install postgresql-14 postgresql-14-postgis-3
```

### CentOS/RHEL/Fedora

```bash
# Installer PostgreSQL et PostGIS
sudo dnf install postgresql16-server postgresql16 postgis34_16

# Ou via yum (anciennes versions)
sudo yum install postgresql16-server postgresql16 postgis34_16
```

### Arch Linux

```bash
sudo pacman -S postgresql postgis
```

---

## 🔧 Activation de l'extension

### Dans une base de données existante

**Via psql :**

```bash
# Se connecter à PostgreSQL
psql -U postgres -d taxe_municipale

# Activer PostGIS
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS postgis_topology;  -- Optionnel (pour les topologies)
CREATE EXTENSION IF NOT EXISTS postgis_raster;   -- Optionnel (pour les rasters)
```

**Via SQL directement :**

```bash
psql -U postgres -d taxe_municipale -c "CREATE EXTENSION IF NOT EXISTS postgis;"
```

**Via Python (SQLAlchemy) :**

```python
from sqlalchemy import create_engine, text

engine = create_engine("postgresql://user:password@localhost:5432/taxe_municipale")

with engine.begin() as conn:
    conn.execute(text("CREATE EXTENSION IF NOT EXISTS postgis;"))
```

**Via le script Python du projet :**

Le fichier `backend/database/database.py` active automatiquement PostGIS lors de l'initialisation :

```python
def init_db():
    # ...
    conn.execute(text("CREATE EXTENSION IF NOT EXISTS postgis;"))
```

---

## ✅ Vérification

### Vérifier que PostGIS est installé

```sql
-- Vérifier la version de PostGIS
SELECT PostGIS_version();

-- Vérifier les extensions installées
SELECT * FROM pg_extension WHERE extname = 'postgis';

-- Lister toutes les extensions disponibles
\dx
```

### Vérifier les fonctions PostGIS disponibles

```sql
-- Tester une fonction PostGIS
SELECT ST_MakePoint(0.3901, 9.4544) AS point_libreville;

-- Vérifier le SRID (Spatial Reference System Identifier)
SELECT ST_SRID(ST_MakePoint(0.3901, 9.4544));
```

### Via Docker

```bash
# Vérifier la version
docker compose exec db psql -U postgres -d taxe_municipale -c "SELECT PostGIS_version();"
```

---

## 🔍 Dépannage

### Erreur : "extension postgis does not exist"

**Causes possibles :**
1. PostGIS n'est pas installé sur le serveur PostgreSQL
2. PostGIS est installé mais l'extension n'est pas activée dans la base de données
3. Droits insuffisants pour créer des extensions

**Solutions :**

```sql
-- Vérifier si PostGIS est disponible
SELECT * FROM pg_available_extensions WHERE name = 'postgis';

-- Si disponible mais pas installé, installer avec les droits superuser
CREATE EXTENSION IF NOT EXISTS postgis;

-- Si non disponible, installer PostGIS sur le serveur (voir sections ci-dessus)
```

### Erreur : "permission denied to create extension"

**Solution :** Se connecter en tant que superuser (postgres) :

```bash
# Se connecter en tant que postgres
psql -U postgres -d taxe_municipale

# Puis créer l'extension
CREATE EXTENSION IF NOT EXISTS postgis;
```

### Erreur : "could not open extension control file"

**Solution :** PostGIS n'est pas installé sur le serveur. Suivez les instructions d'installation ci-dessus.

---

## 📚 Commandes utiles

### Lister les extensions installées

```sql
SELECT extname, extversion FROM pg_extension;
```

### Désactiver PostGIS (rarement nécessaire)

```sql
DROP EXTENSION IF EXISTS postgis CASCADE;
```

### Mettre à jour PostGIS

```sql
ALTER EXTENSION postgis UPDATE TO '3.4.0';
```

---

## 🎯 Pour ce projet

Dans ce projet, PostGIS est déjà configuré via Docker. Pour activer manuellement :

```bash
# Activer PostGIS dans la base Docker
docker compose exec db psql -U postgres -d taxe_municipale -c "CREATE EXTENSION IF NOT EXISTS postgis;"

# Ou utiliser le script SQL
docker compose exec db psql -U postgres -d taxe_municipale -f /path/to/postgis_setup.sql
```

Le fichier `backend/database/database.py` active automatiquement PostGIS lors de l'initialisation de la base de données.

---

## 📖 Ressources

- [Documentation PostGIS](https://postgis.net/documentation/)
- [PostGIS Downloads](https://postgis.net/install/)
- [PostgreSQL Downloads](https://www.postgresql.org/download/)

