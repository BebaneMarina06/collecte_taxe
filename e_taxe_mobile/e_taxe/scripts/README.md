# Scripts pour modifier la base de données

## Installation

1. Installez Python 3.8+ si ce n'est pas déjà fait
2. Installez les dépendances :
```bash
pip install -r requirements.txt
```

## Utilisation

### Script Python

```bash
python modify_database.py
```

Le script vous permet de :
- Lister toutes les tables
- Lister tous les utilisateurs
- Lister tous les collecteurs
- Créer des utilisateurs de test
- Modifier des données
- Exécuter des requêtes SQL personnalisées

### Exemples de requêtes SQL utiles

#### Voir tous les utilisateurs collecteurs
```sql
SELECT * FROM utilisateur WHERE role = 'collecteur';
```

#### Créer un mot de passe hashé pour un utilisateur
```python
import bcrypt
password = "votre_mot_de_passe"
password_hash = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt()).decode('utf-8')
print(password_hash)
```

#### Créer un collecteur complet (utilisateur + collecteur)

**IMPORTANT**: La table `collecteur` n'a pas de mot de passe. L'authentification se fait via la table `users`. Il faut créer les deux et les lier.

**Avec le script Python** (recommandé):
```python
# Dans modify_database.py, décommentez et modifiez:
create_complete_collecteur(
    conn=conn,
    email="collecteur@test.com",
    password="motdepasse123",  # Le mot de passe sera hashé automatiquement
    nom="Doe",
    prenom="John",
    telephone="+24101234567",
    matricule="COL001",
    zone_id=None  # Optionnel
)
```

**Manuellement avec SQL**:
```sql
-- 1. Hasher le mot de passe d'abord (utilisez Python ou votre backend)
-- 2. Créer l'utilisateur dans la table 'utilisateur'
INSERT INTO utilisateur (email, mot_de_passe_hash, nom, prenom, telephone, role, actif)
VALUES ('collecteur@test.com', 'hash_du_mot_de_passe', 'Nom', 'Prenom', '+24101234567', 'collecteur', true)
RETURNING id;

-- 3. Créer le collecteur dans la table 'collecteur' (singulier)
INSERT INTO collecteur (nom, prenom, email, telephone, matricule, statut, etat, actif)
VALUES ('Nom', 'Prenom', 'collecteur@test.com', '+24101234567', 'COL001', 'active', 'deconnecte', true)
RETURNING id;

-- 4. Lier les deux (ajouter la colonne user_id si elle n'existe pas, puis lier)
ALTER TABLE collecteur ADD COLUMN IF NOT EXISTS user_id INTEGER;
UPDATE collecteur 
SET user_id = (SELECT id FROM utilisateur WHERE email = 'collecteur@test.com')
WHERE email = 'collecteur@test.com';
```

#### Modifier le mot de passe d'un utilisateur
```sql
-- ATTENTION: Vous devez d'abord hasher le nouveau mot de passe avec bcrypt
UPDATE utilisateur 
SET mot_de_passe_hash = 'nouveau_hash_bcrypt' 
WHERE email = 'collecteur@test.com';
```

#### Voir tous les collecteurs avec leurs utilisateurs associés
```sql
-- Avec user_id (si la colonne existe):
SELECT u.*, c.* 
FROM utilisateur u 
LEFT JOIN collecteur c ON u.id = c.user_id 
WHERE u.role = 'collecteur';

-- Ou lier par email:
SELECT u.*, c.* 
FROM utilisateur u 
LEFT JOIN collecteur c ON u.email = c.email 
WHERE u.role = 'collecteur';
```

#### Voir les collecteurs qui peuvent se connecter (ont un compte utilisateur)
```sql
SELECT c.*, u.email as user_email, u.role, u.actif as user_actif
FROM collecteur c
INNER JOIN utilisateur u ON c.email = u.email OR c.user_id = u.id
WHERE u.role = 'collecteur' AND u.actif = true;
```

#### Lier un collecteur existant à un utilisateur existant
```sql
-- Ajouter la colonne user_id si elle n'existe pas
ALTER TABLE collecteur ADD COLUMN IF NOT EXISTS user_id INTEGER;

-- Lier par ID utilisateur
UPDATE collecteur 
SET user_id = (SELECT id FROM utilisateur WHERE email = collecteur.email)
WHERE user_id IS NULL;
```

## Outils recommandés

- **DBeaver** : Interface graphique pour gérer la base de données
- **pgAdmin** : Outil officiel PostgreSQL
- **TablePlus** : Interface moderne et simple

