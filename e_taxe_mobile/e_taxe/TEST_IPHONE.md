# 🧪 Test sur iPhone - Guide Rapide

## ✅ Configuration Actuelle

- **IP Wi-Fi configurée** : `192.241.10.19`
- **Backend Docker** : ✅ En cours d'exécution sur le port 8000
- **Base de données** : ✅ En cours d'exécution sur le port 5432

## 📱 Étapes pour Tester

### 1. Vérifier que l'iPhone est sur le même réseau Wi-Fi

Assurez-vous que votre iPhone est connecté au même réseau Wi-Fi que votre ordinateur.

### 2. Tester la connexion depuis Safari (iPhone)

1. Ouvrez Safari sur votre iPhone
2. Allez à : `http://192.241.10.19:8000/health/`
3. Vous devriez voir : `{"status":"ok"}`

**Si ça ne fonctionne pas :**
- Vérifiez que le pare-feu Windows autorise les connexions sur le port 8000
- Vérifiez que votre iPhone et votre ordinateur sont sur le même réseau Wi-Fi
- Essayez de redémarrer Docker : `docker compose restart backend`

### 3. Autoriser le port 8000 dans le pare-feu Windows (si nécessaire)

Si la connexion ne fonctionne pas, exécutez cette commande en tant qu'administrateur :

```powershell
netsh advfirewall firewall add rule name="Docker Backend Port 8000" dir=in action=allow protocol=TCP localport=8000
```

### 4. Lancer l'application Flutter

```bash
cd e_taxe/e_taxe
flutter run
```

Sélectionnez votre iPhone dans la liste des appareils disponibles.

### 5. Vérifier la connexion dans l'application

Une fois l'application lancée :
1. Essayez de vous connecter avec un compte collecteur
2. Si la connexion échoue, vérifiez les logs dans la console Flutter
3. L'application devrait automatiquement utiliser `http://192.241.10.19:8000`

## 🔍 Dépannage

### Problème : "Failed to connect" ou "Connection refused"

**Solutions :**
1. Vérifiez que Docker est en cours d'exécution :
   ```powershell
   docker compose ps
   ```

2. Vérifiez que le backend répond :
   ```powershell
   curl http://localhost:8000/health/
   ```

3. Vérifiez le pare-feu Windows (voir étape 3 ci-dessus)

4. Vérifiez que l'iPhone et l'ordinateur sont sur le même réseau Wi-Fi

### Problème : L'application utilise toujours localhost

**Solution :**
- L'application détecte automatiquement si elle tourne sur un iPhone physique
- Si vous êtes sur le simulateur iOS, elle utilisera `localhost:8000` (c'est normal)
- Pour forcer l'utilisation de l'IP locale, modifiez le code dans `api_service.dart`

### Problème : L'IP a changé

Si vous changez de réseau Wi-Fi, votre IP peut changer. Pour la mettre à jour :

1. Exécutez `ipconfig` pour trouver votre nouvelle IP
2. Modifiez `e_taxe/e_taxe/lib/apis/api_service.dart`, ligne 19 :
   ```dart
   static const String _defaultIOSPhysicalIP = 'NOUVELLE_IP';
   ```
3. Redémarrez l'application

## 📝 Notes

- **iOS Simulator** : Utilise `localhost:8000` (pas besoin de changer l'IP)
- **iPhone Physique** : Utilise `192.241.10.19:8000` (votre IP Wi-Fi actuelle)
- **Android Emulator** : Utilise `10.0.2.2:8000` (automatique)
- **Production** : Utilise l'URL Render (automatique en mode release)

