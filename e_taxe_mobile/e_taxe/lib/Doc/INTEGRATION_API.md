# Documentation d'Intégration API - Application Mobile E-TAXE

## Vue d'ensemble

L'application mobile a été intégrée avec le backend FastAPI déployé sur Render. Tous les endpoints nécessaires pour les collecteurs ont été implémentés.

## Architecture mise en place

### 1. Modèles de données (`lib/models/`)
- ✅ `user.dart` - Modèle utilisateur
- ✅ `collecteur.dart` - Modèle collecteur
- ✅ `contribuable.dart` - Modèle contribuable (client)
- ✅ `taxe.dart` - Modèle taxe
- ✅ `collecte.dart` - Modèle collecte
- ✅ `statistiques.dart` - Modèle statistiques

### 2. Services (`lib/services/` et `lib/apis/`)
- ✅ `storage_service.dart` - Gestion du stockage local (token, infos utilisateur)
- ✅ `api_service.dart` - Service API complet avec tous les endpoints

### 3. Controllers GetX (`lib/controllers/`)
- ✅ `auth_controller.dart` - Gestion de l'authentification
- ✅ `collecte_controller.dart` - Gestion des collectes
- ✅ `client_controller.dart` - Gestion des clients/contribuables
- ✅ `taxe_controller.dart` - Gestion des taxes
- ✅ `statistiques_controller.dart` - Gestion des statistiques

### 4. Composants réutilisables (`lib/components/`)
- ✅ `collecte_card.dart` - Carte de collecte
- ✅ `client_card.dart` - Carte de client

## Endpoints utilisés

### Authentification
- `POST /api/auth/login` - Connexion du collecteur

### Collecteur
- `GET /api/collecteurs/{id}` - Détails du collecteur
- `PUT /api/collecteurs/{id}` - Mise à jour du collecteur
- `PATCH /api/collecteurs/{id}/connexion` - Marquer comme connecté
- `PATCH /api/collecteurs/{id}/deconnexion` - Marquer comme déconnecté

### Collectes
- `GET /api/collectes?collecteur_id={id}` - Liste des collectes
- `GET /api/collectes/{id}` - Détails d'une collecte
- `POST /api/collectes` - Créer une collecte
- `PATCH /api/collectes/{id}/valider` - Valider une collecte
- `PATCH /api/collectes/{id}/annuler` - Annuler une collecte

### Contribuables (Clients)
- `GET /api/contribuables?collecteur_id={id}` - Liste des contribuables
- `GET /api/contribuables/{id}` - Détails d'un contribuable
- `POST /api/contribuables` - Créer un contribuable

### Taxes
- `GET /api/taxes?actif=true` - Liste des taxes actives

### Statistiques
- `GET /api/rapports/collecteur/{id}` - Statistiques du collecteur

## Configuration

### URL de l'API
L'URL de base est définie dans `lib/apis/api_service.dart` :
```dart
static const String baseUrl = 'https://taxe-municipale.onrender.com';
```

Pour le développement local, décommentez :
```dart
// static const String baseUrl = 'http://localhost:8000';
```

### Authentification
Le token JWT est automatiquement :
- Sauvegardé après connexion dans `SharedPreferences`
- Ajouté dans les headers de toutes les requêtes authentifiées
- Supprimé lors de la déconnexion

## Pages intégrées

### ✅ Page de connexion (`lib/authentification/connexion.dart`)
- Intégration complète avec `AuthController`
- Validation des champs
- Gestion des erreurs
- Affichage du loading

### ✅ Page d'accueil (`lib/vues/accueil_agent.dart`)
- Chargement des collectes récentes depuis l'API
- Affichage du nom du collecteur connecté
- Liste des collectes récentes (5 dernières)
- Gestion du loading et des erreurs

### ✅ Page clients (`lib/vues/clients.dart`)
- Chargement de la liste des clients depuis l'API
- Recherche en temps réel
- Pull-to-refresh
- Gestion du loading et des erreurs

## Fonctionnalités implémentées

### Authentification
- ✅ Connexion avec email et mot de passe
- ✅ Sauvegarde du token JWT
- ✅ Vérification de l'état de connexion au démarrage
- ✅ Déconnexion avec nettoyage des données

### Collectes
- ✅ Liste des collectes avec pagination
- ✅ Détails d'une collecte
- ✅ Création d'une collecte
- ✅ Validation d'une collecte
- ✅ Annulation d'une collecte
- ✅ Filtrage par statut

### Clients
- ✅ Liste des clients
- ✅ Recherche de clients
- ✅ Détails d'un client
- ✅ Création d'un client

### Gestion d'état
- ✅ Utilisation de GetX pour la réactivité
- ✅ Controllers pour chaque fonctionnalité
- ✅ Observables pour les mises à jour automatiques

### Gestion des erreurs
- ✅ Messages d'erreur utilisateur
- ✅ Gestion des erreurs réseau
- ✅ Gestion des erreurs d'authentification (401)
- ✅ Boutons de réessai

## Prochaines étapes

### Pages à intégrer
- [ ] `add_collecte.dart` - Formulaire de création de collecte
- [ ] `add_client.dart` - Formulaire de création de client
- [ ] `details_collecte.dart` - Détails d'une collecte
- [ ] `details_client.dart` - Détails d'un client
- [ ] `historique_collecte.dart` - Historique complet des collectes
- [ ] `profil.dart` - Profil du collecteur
- [ ] `caisses.dart` - Gestion des caisses

### Améliorations possibles
- [ ] Cache des données pour mode hors ligne
- [ ] Synchronisation automatique
- [ ] Notifications push
- [ ] Export des données
- [ ] Statistiques avancées

## Notes importantes

### Service Render (gratuit)
- ⚠️ Le service se met en veille après 15 minutes d'inactivité
- ⚠️ Le premier démarrage après veille prend 30-60 secondes
- 💡 Ajoutez un message de chargement pour informer l'utilisateur

### Gestion du token
- Le token est stocké localement et persiste entre les sessions
- Si le token expire (401), l'utilisateur doit se reconnecter
- Vous pouvez ajouter un refresh token si votre backend le supporte

### Performance
- Les données sont chargées à la demande (lazy loading)
- La pagination est implémentée pour les listes
- Utilisez `RefreshIndicator` pour rafraîchir manuellement

## Test

Pour tester l'intégration :

1. **Lancer l'application**
   ```bash
   flutter run
   ```

2. **Se connecter**
   - Utilisez les identifiants d'un collecteur valide
   - Vérifiez que le token est sauvegardé

3. **Tester les fonctionnalités**
   - Vérifier que les collectes se chargent
   - Vérifier que les clients se chargent
   - Tester la recherche
   - Tester le pull-to-refresh

## Support

En cas de problème :
1. Vérifiez les logs de l'application
2. Vérifiez que le backend est accessible : `https://taxe-municipale.onrender.com/health`
3. Vérifiez les erreurs dans la console Flutter
4. Vérifiez que le token est valide

