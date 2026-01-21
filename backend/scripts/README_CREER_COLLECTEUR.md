# 📝 Guide d'Exécution du Script de Création de Collecteur

## 🚀 Méthode 1 : PowerShell (Recommandé)

### Étape 1 : Ouvrir PowerShell

1. Appuyez sur `Windows + X`
2. Sélectionnez **"Windows PowerShell"** ou **"Terminal"**
3. Ou recherchez "PowerShell" dans le menu Démarrer

### Étape 2 : Naviguer vers le dossier du script

```powershell
cd C:\Users\Marina\Documents\e_taxe_back_office\backend\scripts
```

**OU** si vous êtes déjà dans le dossier du projet :

```powershell
cd backend\scripts
```

### Étape 3 : Vérifier que le script existe

```powershell
ls create_collecteur.ps1
```

Vous devriez voir le fichier listé.

### Étape 4 : Modifier le script (si nécessaire)

Avant d'exécuter, ouvrez le script dans un éditeur de texte et modifiez :

```powershell
notepad create_collecteur.ps1
```

**Modifiez au minimum :**
- `$ApiUrl` : URL de votre API Render
- `$AdminEmail` : Votre email admin
- `$AdminPassword` : Votre mot de passe admin

### Étape 5 : Exécuter le script

```powershell
.\create_collecteur.ps1
```

**OU** avec le chemin complet :

```powershell
powershell -ExecutionPolicy Bypass -File .\create_collecteur.ps1
```

---

## ⚠️ Si vous obtenez une erreur de politique d'exécution

Si vous voyez cette erreur :
```
cannot be loaded because running scripts is disabled on this system
```

### Solution 1 : Bypass temporaire (Recommandé)

```powershell
powershell -ExecutionPolicy Bypass -File .\create_collecteur.ps1
```

### Solution 2 : Changer la politique d'exécution (Permanent)

Ouvrez PowerShell **en tant qu'Administrateur** et exécutez :

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

Puis réessayez :

```powershell
.\create_collecteur.ps1
```

---

## 🎯 Méthode 2 : Depuis l'Explorateur de Fichiers

1. Ouvrez l'Explorateur de Fichiers
2. Naviguez vers : `C:\Users\Marina\Documents\e_taxe_back_office\backend\scripts`
3. **Clic droit** sur `create_collecteur.ps1`
4. Sélectionnez **"Exécuter avec PowerShell"**

---

## 📋 Exemple d'exécution complète

```powershell
# 1. Ouvrir PowerShell
# 2. Naviguer vers le dossier
cd C:\Users\Marina\Documents\e_taxe_back_office\backend\scripts

# 3. Vérifier le fichier
ls create_collecteur.ps1

# 4. Modifier le script si nécessaire
notepad create_collecteur.ps1

# 5. Exécuter le script
.\create_collecteur.ps1
```

---

## ✅ Résultat attendu

Si tout fonctionne, vous devriez voir :

```
============================================
  Création d'un Collecteur via l'API
============================================

🔐 Connexion à l'API...
   URL: https://votre-app.onrender.com
   Email: admin@example.com
✅ Connexion réussie !

👤 Création du collecteur...
   Nom: MBOUMBA Jean
   Email: jean.mboumba@mairie-libreville.ga
   Matricule: COL-001
   Zone ID: 1

✅ Collecteur créé avec succès !

============================================
📋 Détails du collecteur créé :
============================================
ID: 1
Nom: MBOUMBA Jean
Email: jean.mboumba@mairie-libreville.ga
Téléphone: +241062345678
Matricule: COL-001
Statut: active
État: deconnecte
Zone ID: 1
Heure de clôture: 18:00
============================================

💡 Le collecteur peut maintenant se connecter à l'application mobile avec:
   Email: jean.mboumba@mairie-libreville.ga
```

---

## 🆘 Dépannage

### Erreur : "cannot be loaded because running scripts is disabled"
→ Utilisez : `powershell -ExecutionPolicy Bypass -File .\create_collecteur.ps1`

### Erreur : "cannot connect to server"
→ Vérifiez que `$ApiUrl` est correct et que votre API Render est en ligne

### Erreur : "401 Unauthorized"
→ Vérifiez que `$AdminEmail` et `$AdminPassword` sont corrects

### Erreur : "Un collecteur avec ce matricule existe déjà"
→ Changez le `$CollecteurMatricule` dans le script

### Erreur : "Zone non trouvée"
→ Vérifiez que `$ZoneId` existe dans votre base de données (commencez par 1)

---

## 💡 Astuce

Pour créer plusieurs collecteurs, modifiez simplement les informations dans le script et réexécutez-le. Assurez-vous de changer :
- Le matricule
- L'email
- Le téléphone

---

Bon succès ! 🚀

