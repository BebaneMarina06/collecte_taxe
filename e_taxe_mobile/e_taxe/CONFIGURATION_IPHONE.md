# Configuration pour iPhone Physique

## 📱 Connexion au Backend Docker

Pour tester l'application sur un iPhone physique, vous devez configurer l'IP locale de votre ordinateur.

### 🔍 Étape 1 : Trouver votre IP locale

**Sur Windows :**
```powershell
ipconfig
```
Cherchez l'adresse IPv4 de votre carte réseau (généralement sous "Carte réseau sans fil Wi-Fi" ou "Adaptateur Ethernet"). Elle ressemble à `192.168.1.XXX` ou `192.168.0.XXX`.

**Sur Mac :**
```bash
ifconfig | grep "inet " | grep -v 127.0.0.1
```

**Sur Linux :**
```bash
hostname -I
```

### ⚙️ Étape 2 : Configurer l'IP dans l'application

L'application détecte automatiquement si elle tourne sur un iPhone physique et utilise une IP par défaut. Vous pouvez la modifier de deux façons :

#### Option A : Via le code (modification temporaire)

Dans `e_taxe/e_taxe/lib/apis/api_service.dart`, ligne 19, modifiez :
```dart
static const String _defaultIOSPhysicalIP = '192.241.10.19'; // Remplacez par votre IP
```

**Note :** L'IP par défaut est déjà configurée avec votre adresse Wi-Fi actuelle (`192.241.10.19`). Si vous changez de réseau, vous devrez la mettre à jour.

#### Option B : Via l'application (recommandé)

L'application permet de configurer l'IP directement depuis l'interface. Allez dans les paramètres de l'application et entrez votre IP locale.

### 🔧 Étape 3 : Vérifier que le backend est accessible

Assurez-vous que :
1. Docker est en cours d'exécution (`docker compose up -d`)
2. Le backend écoute sur `0.0.0.0:8000` (déjà configuré)
3. Votre iPhone et votre ordinateur sont sur le même réseau Wi-Fi

### 🧪 Étape 4 : Tester la connexion

1. Sur votre iPhone, ouvrez Safari
2. Allez à `http://VOTRE_IP:8000/health/`
3. Vous devriez voir `{"status":"ok"}`

Si ça ne fonctionne pas :
- Vérifiez que le pare-feu Windows autorise les connexions sur le port 8000
- Vérifiez que votre iPhone et votre ordinateur sont bien sur le même réseau Wi-Fi

### 🚀 Lancer l'application

```bash
flutter run -d <device-id>
```

Pour voir la liste des appareils disponibles :
```bash
flutter devices
```

### 📝 Notes importantes

- **iOS Simulator** : Utilise automatiquement `localhost:8000`
- **iPhone Physique** : Utilise l'IP locale configurée (par défaut `192.168.1.100`)
- **Android Emulator** : Utilise automatiquement `10.0.2.2:8000`
- **Production** : Utilise l'URL de production (Render)

### 🔄 Changer l'IP après le lancement

Si vous changez de réseau Wi-Fi, vous devrez mettre à jour l'IP. Vous pouvez :
1. Redémarrer l'application avec la nouvelle IP
2. Utiliser la fonction `ApiService.setCustomIP('nouvelle_ip')` dans le code
3. Modifier directement dans les paramètres de l'application (si implémenté)

