# 🗄️ Guide de Migration avec DBeaver

Guide complet pour migrer vos données vers Render en utilisant DBeaver.

---

## 📥 Étape 1 : Télécharger et Installer DBeaver

1. Allez sur : https://dbeaver.io/download/
2. Téléchargez **DBeaver Community Edition** (gratuit)
3. Installez DBeaver (suivez l'assistant d'installation)
4. Ouvrez DBeaver

---

## 🔌 Étape 2 : Créer la Connexion à Render

### 2.1. Créer une nouvelle connexion

1. Dans DBeaver, cliquez sur **"Nouvelle connexion"** (icône prise) ou **Database → New Database Connection**
2. Sélectionnez **PostgreSQL**
3. Cliquez sur **Suivant**

### 2.2. Configurer la connexion

Remplissez les informations suivantes :

**Onglet "Main" :**
```
Host:     dpg-d5mnj0f5r7bs73d96n10-a.oregon-postgres.render.com
Port:     5432
Database: taxe_municipale_7dqx
Username: taxe_municipale_7dqx_user
Password: 1H1vrXOMhjgWxGGbQJh65kHSqNPxqi1C
```

**Important :**
- ✅ Cochez **"Show all databases"** si vous voulez voir toutes les bases
- ✅ Cochez **"Save password"** pour ne pas retaper le mot de passe

### 2.3. Tester la connexion

1. Cliquez sur **"Test Connection"**
2. Si c'est la première fois, DBeaver vous demandera de télécharger le driver PostgreSQL → Cliquez sur **"Download"**
3. Attendez que le téléchargement se termine
4. Cliquez à nouveau sur **"Test Connection"**
5. Vous devriez voir : **"Connected"** ✅

### 2.4. Finaliser

1. Cliquez sur **"Finish"**
2. La connexion apparaît dans le panneau de gauche

---

## 📂 Étape 3 : Ouvrir le Fichier Dump SQL

### 3.1. Ouvrir le fichier

1. Dans DBeaver : **File → Open SQL Script** (ou `Ctrl+O`)
2. Naviguez vers :
   ```
   C:\Users\Marina\Documents\e_taxe_back_office\backend\migration_render_20260119_093303.sql
   ```
3. Cliquez sur **"Open"**

### 3.2. Vérifier le contenu

Le fichier devrait s'ouvrir dans un éditeur SQL. Vous devriez voir des commandes `INSERT INTO ...`.

---

## ⚙️ Étape 4 : Préparer la Base de Données Render

### 4.1. Activer PostGIS

Avant d'importer, il faut activer PostGIS :

1. Dans DBeaver, **clic droit** sur votre connexion Render
2. Sélectionnez **"SQL Editor → New SQL Script"**
3. Tapez :
   ```sql
   CREATE EXTENSION IF NOT EXISTS postgis;
   ```
4. Cliquez sur **"Execute SQL Script"** (ou `Ctrl+Enter`)
5. Vous devriez voir : **"Query executed successfully"** ✅

### 4.2. Vérifier les tables

Vérifiez que les tables existent :

1. Dans le panneau de gauche, développez votre connexion
2. Développez **"Databases" → "taxe_municipale_7dqx" → "Schemas" → "public" → "Tables"**
3. Vous devriez voir toutes vos tables

---

## 🚀 Étape 5 : Exécuter le Script de Migration

### 5.1. Exécuter le script complet

1. Dans l'éditeur SQL avec votre fichier dump ouvert
2. **Sélectionnez TOUT le contenu** (`Ctrl+A`)
3. Cliquez sur **"Execute SQL Script"** (ou `Ctrl+Enter`)
4. **OU** cliquez sur le bouton **"Execute"** (icône flèche verte)

### 5.2. Surveiller l'exécution

- DBeaver va exécuter toutes les commandes SQL
- Vous verrez la progression dans le panneau **"Log"** en bas
- Cela peut prendre quelques minutes selon la taille des données

### 5.3. Gérer les erreurs

Si vous voyez des erreurs :

**Erreur "duplicate key" ou "already exists" :**
- ✅ C'est normal si certaines données existent déjà
- Le script continue avec les autres données

**Erreur "relation does not exist" :**
- ⚠️ La table n'existe pas encore
- Exécutez d'abord le script de création des tables (si vous en avez un)

**Erreur "extension postgis does not exist" :**
- ⚠️ PostGIS n'est pas activé
- Retournez à l'étape 4.1

---

## ✅ Étape 6 : Vérifier la Migration

### 6.1. Vérifier les données dans DBeaver

1. Dans le panneau de gauche, développez une table (ex: `collecteur`)
2. **Clic droit** → **"View Data"**
3. Vous devriez voir vos données

### 6.2. Compter les enregistrements

Exécutez ces requêtes dans un nouvel éditeur SQL :

```sql
-- Nombre de collecteurs
SELECT COUNT(*) FROM collecteur;

-- Nombre de contribuables
SELECT COUNT(*) FROM contribuable;

-- Nombre de taxes
SELECT COUNT(*) FROM taxe;

-- Nombre de collectes
SELECT COUNT(*) FROM info_collecte;
```

### 6.3. Vérifier via l'API

1. Allez sur : `https://votre-app.onrender.com/docs`
2. Connectez-vous
3. Testez les endpoints pour voir vos données

---

## 🆘 Dépannage

### Problème : "Connection timeout"

**Solution :**
- Vérifiez que la base Render n'est pas en veille (sur le plan gratuit)
- Réessayez la connexion
- Si c'est un plan gratuit, le premier appel peut prendre 30-60 secondes

### Problème : "Password authentication failed"

**Solution :**
- Vérifiez que le mot de passe est correct
- Copiez-collez le mot de passe depuis Render Dashboard

### Problème : "Could not connect to server"

**Solution :**
- Vérifiez que vous utilisez l'**External Database URL** (pas Internal)
- Vérifiez que le host et le port sont corrects

### Problème : Le script est trop long à exécuter

**Solution :**
- C'est normal pour de gros volumes de données
- Laissez DBeaver terminer
- Surveillez le panneau "Log" pour voir la progression

---

## 💡 Astuces

1. **Sauvegarder la connexion** : DBeaver sauvegarde automatiquement votre connexion
2. **Exécuter par parties** : Si le script est très long, vous pouvez sélectionner et exécuter des parties
3. **Vérifier avant d'importer** : Regardez d'abord quelques lignes du dump pour comprendre la structure
4. **Backup** : Avant d'importer, faites un backup de votre base Render (si possible)

---

## 📋 Checklist de Migration

Avant de commencer :
- [ ] DBeaver installé
- [ ] Connexion à Render créée et testée
- [ ] PostGIS activé dans Render
- [ ] Fichier dump SQL disponible

Pendant la migration :
- [ ] Script SQL ouvert dans DBeaver
- [ ] Script exécuté sans erreurs critiques
- [ ] Données vérifiées dans DBeaver

Après la migration :
- [ ] Nombre d'enregistrements vérifié
- [ ] Données testées via l'API
- [ ] Application fonctionnelle

---

## 🎯 Résumé Rapide

1. **Installer DBeaver** → https://dbeaver.io/download/
2. **Créer connexion** → PostgreSQL avec les infos Render
3. **Activer PostGIS** → `CREATE EXTENSION IF NOT EXISTS postgis;`
4. **Ouvrir le dump** → `migration_render_20260119_093303.sql`
5. **Exécuter** → `Ctrl+Enter`
6. **Vérifier** → Compter les enregistrements

---

Bon succès avec votre migration ! 🚀

