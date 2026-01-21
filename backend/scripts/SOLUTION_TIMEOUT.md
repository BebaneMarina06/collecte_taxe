# 🔧 Solution au Problème de Timeout avec Render

Le problème de timeout est dû au fait que les bases de données Render (plan gratuit) se mettent en veille après 15 minutes d'inactivité.

---

## 🎯 Solution : Migration via l'API REST

Au lieu de se connecter directement à la base de données, nous allons utiliser l'API REST qui réveille automatiquement la base.

---

## 🚀 Méthode Rapide

### Étape 1 : Obtenir l'URL de votre API Render

Dans Render Dashboard → Votre Service Web → URL

Exemple : `https://e-taxe-api.onrender.com`

### Étape 2 : Exécuter le script de migration

```powershell
cd C:\Users\Marina\Documents\e_taxe_back_office\backend\scripts

python wake_and_migrate.py `
  --api-url "https://votre-app.onrender.com" `
  --email "votre_email_admin" `
  --password "votre_mot_de_passe"
```

Le script va :
1. ✅ Réveiller la base de données Render
2. ✅ Se connecter à l'API
3. ✅ Migrer les zones
4. ✅ Migrer les collecteurs

---

## 📋 Données Migrées Automatiquement

- ✅ **Zones** géographiques
- ✅ **Collecteurs** avec toutes leurs informations

---

## 📝 Autres Données à Migrer Manuellement

Pour les données suivantes, vous devrez les créer via l'interface ou l'API :

- **Contribuables** : Via l'interface web ou l'API `/api/contribuables`
- **Collectes** : Via l'application mobile ou l'API `/api/collectes`
- **Taxes** : Via l'interface web ou l'API `/api/taxes`
- **Utilisateurs** : Via l'interface web ou l'API `/api/utilisateurs`

---

## 🔄 Alternative : Utiliser l'Interface Web

Une fois les zones et collecteurs migrés, vous pouvez :

1. **Aller sur votre API** : `https://votre-app.onrender.com/docs`
2. **Se connecter** avec vos identifiants admin
3. **Créer les autres données** via l'interface Swagger

---

## 💡 Pourquoi cette méthode fonctionne ?

- ✅ L'API réveille automatiquement la base de données
- ✅ Pas besoin de connexion directe SQL
- ✅ Validation automatique des données
- ✅ Gestion des doublons automatique

---

## 🆘 Si ça ne fonctionne toujours pas

### Option 1 : Attendre que la base se réveille

Sur le plan gratuit, le premier appel peut prendre 30-60 secondes. Le script attend automatiquement.

### Option 2 : Utiliser le plan payant

Les plans payants de Render ne mettent pas les bases en veille.

### Option 3 : Migrer progressivement

Migrez les données les plus importantes d'abord (collecteurs, zones), puis ajoutez le reste progressivement via l'interface.

---

## ✅ Vérification

Après la migration, vérifiez :

```bash
# Via Swagger
https://votre-app.onrender.com/docs

# Testez les endpoints :
# - GET /api/collecteurs
# - GET /api/references/zones
```

---

Bon succès ! 🚀

