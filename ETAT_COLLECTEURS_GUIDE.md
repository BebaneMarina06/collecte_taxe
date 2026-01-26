# Interface État des Collecteurs

## 📋 Description
Interface complète pour gérer et suivre l'état des collecteurs avec un tableau détaillé, des filtres avancés et l'export en CSV.

## ✨ Fonctionnalités

### 1. **Tableau Principal**
- **Colonnes affichées:**
  - Nom du collecteur
  - Date de collecte
  - Montant collecté en cash (espèces)
  - Montant collecté numériquement (mobile money, carte, etc.)
  - Montant total collecté
  - Nombre de contribuables collectés
  - Bouton pour afficher/masquer les détails

### 2. **Filtres Disponibles**
- **Filtrage par date:**
  - Option 1: Date spécifique (défaut: aujourd'hui)
  - Option 2: Plage de dates (date début - date fin)
  - Basculement simple entre les deux modes
- **Filtre par collecteur:**
  - Sélection d'un collecteur spécifique ou affichage de tous
- **Bouton Réinitialiser:**
  - Remet tous les filtres aux valeurs par défaut

### 3. **Détails des Contribuables**
- En cliquant sur "Afficher", vous voyez la liste complète des contribuables collectés
- Affichage pour chaque contribuable:
  - Nom et prénom
  - Montant collecté auprès de lui
- Affichage en grille responsive

### 4. **Tableau de Totaux**
- **4 cartes d'information:**
  - Montant Cash Total (rouge)
  - Montant Numérique Total (cyan)
  - Montant Total Général (bleu)
  - Nombre de Collectes Total (orange)
- Les totaux se mettent à jour selon les filtres appliqués

### 5. **Pagination**
- 10 lignes par page (configurable)
- Boutons Précédent/Suivant
- Affichage du numéro de page actuelle

### 6. **Export CSV**
- Bouton "Exporter en CSV"
- Génère un fichier avec le format:
  ```
  Nom du Collecteur, Date, Montant Cash, Montant Numérique, Montant Total, Nombre de Contribuables, Contribuables
  ```
- Inclut une ligne de totaux à la fin
- Nom de fichier: `etat_collecteurs_YYYY-MM-DD.csv`

## 🔧 Architecture Technique

### Backend - Endpoint `/api/collectes/etat/par-collecteur`

**Méthode:** GET

**Paramètres de requête:**
```
- date_debut: date (optionnel) - Début de la plage
- date_fin: date (optionnel) - Fin de la plage
- date_specifique: date (optionnel) - Un jour spécifique
- collecteur_id: integer (optionnel) - ID du collecteur
```

**Réponse:**
```json
[
  {
    "collecteur_id": 1,
    "nom_collecteur": "Jean Dupont",
    "date": "2025-01-26",
    "montant_cash": 500000,
    "montant_numerique": 250000,
    "montant_total": 750000,
    "nombre_contribuables": 15,
    "contribuables": [
      {
        "id": 10,
        "nom": "Dupont",
        "prenom": "Marie",
        "montant": 50000
      }
    ]
  }
]
```

### Frontend - Composant `EtatCollecteursComponent`

**Fichiers créés:**
- `etat-collecteurs.component.ts` - Logique du composant
- `etat-collecteurs.component.html` - Template
- `etat-collecteurs.component.scss` - Styles

**Méthodes principales:**
- `chargerEtats()` - Récupère les données du backend
- `appliquerFiltres()` - Met en place les filtres
- `calculerTotaux()` - Calcule les montants totaux
- `exporterCSV()` - Exporte les données en CSV
- `afficherContribuables()` - Toggle affichage détails

**Intégration API:**
- Méthode `getEtatCollecteurs(params)` ajoutée dans `ApiService`

## 📂 Fichiers Modifiés/Créés

### Backend
1. **`backend/routers/collectes.py`**
   - Ajout de l'endpoint `/api/collectes/etat/par-collecteur`
   - Ajout des classes de réponse `CollecteurEtatResponse`

2. **`backend/main.py`**
   - `redirect_slashes=False` activé (déjà présent)

### Frontend
1. **`frontend/src/app/components/pages/etat-collecteurs/`**
   - `etat-collecteurs.component.ts` (120 lignes)
   - `etat-collecteurs.component.html` (230 lignes)
   - `etat-collecteurs.component.scss` (500+ lignes)

2. **`frontend/src/app/services/api.service.ts`**
   - Ajout de `getEtatCollecteurs(params?: any): Observable<any>`

3. **`frontend/src/app/app.routes.ts`**
   - Ajout de la route `/etat-collecteurs`
   - Accès restreint aux rôles `admin` et `agent_back_office`

## 🎨 Design & UX

### Thème Couleur
- **Gradient principal:** Bleu/Violet (#667eea → #764ba2)
- **Accent cash:** Rouge (#ff6b6b)
- **Accent numérique:** Cyan (#4ecdc4)
- **Accent total:** Bleu (#667eea)
- **Fond:** Gris clair (#f5f7fa)

### Responsive
- Desktop: Grille complète avec toutes les colonnes
- Tablette: Adaptation automatique de la grille
- Mobile: Layout empilé vertical

### Interactions
- Hover sur les lignes du tableau
- Expansion/réduction des détails des contribuables
- Animations de transition fluides
- Indicateurs visuels des boutons actifs

## 🚀 Utilisation

### Accès à l'interface
```
http://localhost:4200/etat-collecteurs
```

### Scénarios courants

1. **Voir l'état du jour actuel:**
   - La date spécifique est pré-remplie avec aujourd'hui
   - Cliquez sur "Charger"

2. **Comparer sur une période:**
   - Cochez "Utiliser une plage de dates"
   - Sélectionnez date début et fin
   - Cliquez sur "Charger"

3. **Suivre un collecteur spécifique:**
   - Sélectionnez un collecteur dans le dropdown
   - Définissez la période
   - Cliquez sur "Charger"

4. **Exporter les données:**
   - Appliquez les filtres désirés
   - Cliquez sur "Exporter en CSV"
   - Le fichier est téléchargé automatiquement

## 📊 Calculs Effectués

Le backend calcule automatiquement:
- **Montant cash:** Somme des collectes type_paiement = 'especes'
- **Montant numérique:** Somme des collectes type_paiement != 'especes'
- **Montant total:** cash + numérique
- **Nombre de contribuables:** Nombre de contribuables distincts

## 🔒 Sécurité

- Authentification requise (AuthGuard)
- Accès limité à `admin` et `agent_back_office` (RoleGuard)
- Les données ne sont filtrées que par les paramètres de requête validés

## 📝 Notes

- Les collectes doivent avoir le statut `CONFIRMED` pour être incluses
- Les montants sont formatés en format français (séparateur décimal: virgule)
- L'affichage des contribuables est limité à 300 pixels de largeur max par élément
- La pagination par défaut montre 10 lignes par page

## ⚙️ Configuration

Pour modifier la pagination, éditez la ligne dans `etat-collecteurs.component.ts`:
```typescript
itemsPerPage = 10; // Changer ce nombre
```

Pour modifier les filtres par défaut, modifiez les méthodes:
```typescript
getTodayDate() // Pour la date par défaut
reinitialiserFiltres() // Pour les valeurs initiales
```
