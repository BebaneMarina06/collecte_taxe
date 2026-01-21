# Gestion de l'heure de clôture pour les collecteurs

## 📋 Vue d'ensemble

Cette fonctionnalité permet de gérer automatiquement la fermeture de l'application pour les collecteurs à une heure spécifique. L'application vérifie périodiquement l'heure de clôture et prend les mesures appropriées.

## ✨ Fonctionnalités

### 1. **Vérification automatique**
- Vérification toutes les minutes de l'heure actuelle
- Comparaison avec l'heure de clôture du collecteur
- Démarrage automatique après la connexion

### 2. **Avertissements**
- **15 minutes avant** : Avertissement orange
- **5 minutes avant** : Avertissement rouge critique
- Messages clairs et non-dismissibles pour les avertissements critiques

### 3. **Fermeture automatique**
- Déconnexion automatique du collecteur à l'heure de clôture
- Dialogue de fermeture avec option de déconnexion manuelle
- Déconnexion automatique après 3 secondes si aucune action

### 4. **Blocage des actions**
- Impossible de créer une collecte dans les 5 dernières minutes
- Message d'erreur explicite si tentative de création
- Vérification avant chaque création de collecte

### 5. **Indicateur visuel**
- Affichage du temps restant avant fermeture dans l'accueil
- Changement de couleur selon le temps restant (orange si < 15 min)
- Mise à jour toutes les 30 secondes

## 🔧 Implémentation technique

### Modèle Collecteur
Le modèle `Collecteur` a été mis à jour pour inclure le champ `heureCloture` :
```dart
final String? heureCloture; // Format HH:mm
```

### Service ClosingTimeService
Service principal qui gère toute la logique de clôture :

**Méthodes principales** :
- `startChecking()` : Démarre la vérification périodique
- `stopChecking()` : Arrête la vérification
- `canCreateCollecte()` : Vérifie si on peut créer une collecte
- `getTimeRemaining()` : Retourne le temps restant avant fermeture
- `reset()` : Réinitialise l'état

**Fonctionnement** :
1. Vérifie l'heure de clôture du collecteur connecté
2. Parse l'heure au format HH:mm
3. Compare avec l'heure actuelle
4. Affiche des avertissements selon le temps restant
5. Déconnecte automatiquement à l'heure de clôture

### Intégration dans AuthController
- Démarre automatiquement la vérification après connexion réussie
- Arrête la vérification lors de la déconnexion
- Réinitialise l'état lors de la déconnexion

### Intégration dans AddCollecte
- Vérifie `canCreateCollecte()` avant de permettre la création
- Affiche un message d'erreur si l'heure de clôture est proche

### Indicateur dans AccueilAgent
- Affiche le temps restant avant fermeture
- Change de couleur si moins de 15 minutes restantes
- Mise à jour toutes les 30 secondes

## 📱 Utilisation

### Configuration de l'heure de clôture
L'heure de clôture est configurée dans la base de données pour chaque collecteur dans le champ `heure_cloture` (format HH:mm, ex: "18:00").

### Comportement utilisateur

1. **Pendant la journée** :
   - L'application fonctionne normalement
   - Aucun avertissement affiché

2. **15 minutes avant la fermeture** :
   - Avertissement orange en haut de l'écran
   - Message : "L'application se fermera dans X minutes"

3. **5 minutes avant la fermeture** :
   - Avertissement rouge critique
   - Message : "Fermeture dans X minutes !"
   - Non-dismissible

4. **À l'heure de clôture** :
   - Dialogue de fermeture affiché
   - Déconnexion automatique après 3 secondes
   - Retour à l'écran de connexion

5. **Tentative de création de collecte** :
   - Si moins de 5 minutes avant la fermeture : Bloquée
   - Message d'erreur explicite affiché

## 🎯 Format de l'heure

L'heure de clôture doit être au format **HH:mm** (24 heures) :
- Exemples valides : "18:00", "17:30", "20:15"
- Format : 2 chiffres pour les heures (00-23), deux-points, 2 chiffres pour les minutes (00-59)

## ⚙️ Configuration

### Dans la base de données
```sql
UPDATE collecteur 
SET heure_cloture = '18:00' 
WHERE id = <collecteur_id>;
```

### Via l'API
L'heure de clôture peut être mise à jour via l'endpoint de mise à jour du collecteur :
```json
{
  "heure_cloture": "18:00"
}
```

## 🔄 Cycle de vie

1. **Connexion** → Démarrage de la vérification
2. **Pendant la session** → Vérification toutes les minutes
3. **Avertissements** → Affichés selon le temps restant
4. **Fermeture** → Déconnexion automatique
5. **Déconnexion** → Arrêt de la vérification

## 📝 Notes importantes

- La vérification se fait toutes les **1 minute**
- L'indicateur dans l'accueil se met à jour toutes les **30 secondes**
- Les collectes ne peuvent plus être créées dans les **5 dernières minutes**
- La déconnexion automatique se fait après **3 secondes** d'affichage du dialogue
- Si l'heure de clôture n'est pas configurée, l'application fonctionne normalement sans restriction

## 🐛 Gestion des erreurs

- Si l'heure de clôture est invalide ou mal formatée, elle est ignorée
- Si le collecteur n'a pas d'heure de clôture, l'application fonctionne normalement
- Les erreurs de déconnexion sont ignorées pour éviter de bloquer la fermeture

## 🚀 Améliorations futures possibles

- Configuration de l'heure de clôture depuis l'application
- Historique des fermetures
- Notifications push avant la fermeture
- Mode "extension" pour prolonger l'heure de clôture
- Statistiques de fermeture

