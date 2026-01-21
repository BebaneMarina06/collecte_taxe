# 👤 Créer les Utilisateurs dans Render

Guide pour créer les utilisateurs directement dans la base de données Render.

---

## 🎯 Méthode 1 : Script Python (Recommandé)

### Étape 1 : Réveiller la base Render

Avant de vous connecter, réveillez la base en visitant :
```
https://taxe-municipale.onrender.com/health
```

Attendez 30-60 secondes.

### Étape 2 : Créer l'utilisateur admin

```powershell
cd C:\Users\Marina\Documents\e_taxe_back_office\backend\scripts

python create_users_in_render.py `
  --render-db-url "postgresql://taxe_municipale_7dqx_user:1H1vrXOMhjgWxGGbQJh65kHSqNPxqi1C@dpg-d5mnj0f5r7bs73d96n10-a.oregon-postgres.render.com:5432/taxe_municipale_7dqx"
```

Cela créera l'utilisateur admin avec :
- **Email** : `admin@mairie-libreville.ga`
- **Password** : `admin123`

### Étape 3 : Créer tous les utilisateurs (optionnel)

Si vous voulez créer tous les utilisateurs de votre base locale :

```powershell
python create_users_in_render.py `
  --render-db-url "postgresql://taxe_municipale_7dqx_user:1H1vrXOMhjgWxGGbQJh65kHSqNPxqi1C@dpg-d5mnj0f5r7bs73d96n10-a.oregon-postgres.render.com:5432/taxe_municipale_7dqx" `
  --all
```

---

## 🎯 Méthode 2 : Via SQL Direct (DBeaver)

### Étape 1 : Générer le SQL

```powershell
python generate_admin_sql.py
```

Cela affichera la requête SQL à exécuter.

### Étape 2 : Exécuter dans DBeaver

1. Connectez-vous à Render dans DBeaver
2. Ouvrez un nouvel éditeur SQL
3. Collez la requête SQL générée
4. Exécutez (`Ctrl+Enter`)

---

## 🎯 Méthode 3 : Via l'API (après création de l'admin)

Une fois l'admin créé, vous pouvez créer d'autres utilisateurs via l'API :

1. Connectez-vous avec l'admin : `admin@mairie-libreville.ga` / `admin123`
2. Utilisez l'endpoint `POST /api/utilisateurs` dans Swagger

---

## ✅ Vérification

Après création, testez la connexion :

```powershell
python wake_and_migrate.py `
  --api-url "https://taxe-municipale.onrender.com" `
  --email "admin@mairie-libreville.ga" `
  --password "admin123"
```

---

## 🆘 Si Timeout

Si vous avez un timeout :

1. **Réveillez la base** : Visitez https://taxe-municipale.onrender.com/health
2. **Attendez 30-60 secondes**
3. **Réessayez** le script

---

## 📋 Mots de passe par défaut

- **admin@mairie-libreville.ga** → `admin123`
- **Tous les autres utilisateurs** → `password123`

---

Bon succès ! 🚀

