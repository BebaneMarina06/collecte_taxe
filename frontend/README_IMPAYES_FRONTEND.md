# Documentation - Utilisation des Impayés dans le Frontend Angular

## Vue d'ensemble

Le frontend Angular dispose maintenant de deux approches pour gérer les impayés :

### 1. **Vue SQL `impayes_view` (RECOMMANDÉ pour l'affichage)**
- Calcul automatique en temps réel
- Toujours à jour
- Pas de synchronisation nécessaire
- **Nouveaux endpoints:** `/api/impayes/vue/liste`, `/api/impayes/vue/contribuable/{id}`, `/api/impayes/vue/statistiques`

### 2. **Table `dossier_impaye` (Pour la gestion des dossiers)**
- Gestion formelle des dossiers de recouvrement
- Assignation aux collecteurs
- Historique et notes
- **Endpoints existants:** `/api/impayes`

---

## Fichiers créés

### 1. Interfaces TypeScript
**Fichier:** `src/app/interfaces/impayes.interface.ts`

Définit tous les types TypeScript pour les impayés :
- `ImpayeVue` : Représente un impayé depuis la vue
- `StatutImpaye` : Type pour les statuts (PAYE, PARTIEL, IMPAYE, RETARD)
- `ImpayeListeResponse` : Réponse paginée
- `ImpayeContribuableResponse` : Impayés d'un contribuable avec totaux
- `StatistiquesImpayesResponse` : Statistiques globales
- `ImpayesFiltres` : Filtres disponibles

### 2. Service Dédié (Optionnel)
**Fichier:** `src/app/services/impayes.service.ts`

Service spécialisé avec toutes les méthodes pour interroger la vue :
- `getImpayesListe()` - Liste avec filtres
- `getImpayesContribuable()` - Impayés d'un contribuable
- `getStatistiquesImpayes()` - Statistiques globales
- `getImpayesRetard()` - Seulement les retards
- `getImpayesParZone()` - Par zone
- `getImpayesParQuartier()` - Par quartier

### 3. Méthodes ajoutées à ApiService
**Fichier:** `src/app/services/api.service.ts`

Nouvelles méthodes ajoutées (lignes 666-678) :
```typescript
getImpayesVue(params?: any): Observable<any>
getImpayesContribuableVue(contribuableId: number): Observable<any>
getStatistiquesImpayesVue(): Observable<any>
```

---

## Utilisation dans les Composants

### Option 1: Utiliser ApiService (Simple)

```typescript
import { Component, OnInit, inject } from '@angular/core';
import { ApiService } from '../../../services/api.service';

@Component({
  selector: 'app-mon-composant',
  // ...
})
export class MonComposant implements OnInit {
  private apiService = inject(ApiService);

  impayes: any[] = [];
  loading = false;

  ngOnInit(): void {
    this.chargerImpayes();
  }

  chargerImpayes(): void {
    this.loading = true;

    // Récupérer tous les impayés en retard
    this.apiService.getImpayesVue({
      statut: 'RETARD',
      skip: 0,
      limit: 50
    }).subscribe({
      next: (response) => {
        this.impayes = response.items;
        console.log('Total impayés:', response.total);
        this.loading = false;
      },
      error: (err) => {
        console.error('Erreur:', err);
        this.loading = false;
      }
    });
  }

  chargerStatistiques(): void {
    this.apiService.getStatistiquesImpayesVue().subscribe({
      next: (stats) => {
        console.log('Total retard:', stats.globales.total_retard);
        console.log('Montant total dû:', stats.globales.montant_impaye_total);
        console.log('Par zone:', stats.par_zone);
        console.log('Par collecteur:', stats.par_collecteur);
      }
    });
  }

  chargerImpayesContribuable(contribuableId: number): void {
    this.apiService.getImpayesContribuableVue(contribuableId).subscribe({
      next: (data) => {
        console.log('Impayés du contribuable:', data.items);
        console.log('Montant total restant:', data.totaux.montant_total_restant);
        console.log('Nombre de taxes impayées:', data.totaux.nombre_taxes_impayees);
      }
    });
  }
}
```

### Option 2: Utiliser ImpayesService (Typé)

```typescript
import { Component, OnInit, inject } from '@angular/core';
import { ImpayesService } from '../../../services/impayes.service';
import { ImpayeVue, StatutImpaye } from '../../../interfaces/impayes.interface';

@Component({
  selector: 'app-mon-composant',
  // ...
})
export class MonComposant implements OnInit {
  private impayesService = inject(ImpayesService);

  impayes: ImpayeVue[] = [];
  loading = false;

  ngOnInit(): void {
    this.chargerImpayes();
  }

  chargerImpayes(): void {
    this.loading = true;

    this.impayesService.getImpayesListe({
      statut: 'RETARD',
      skip: 0,
      limit: 50
    }).subscribe({
      next: (response) => {
        this.impayes = response.items;
        console.log('Total:', response.total);
        this.loading = false;
      },
      error: (err) => {
        console.error('Erreur:', err);
        this.loading = false;
      }
    });
  }
}
```

---

## Exemples d'Affichage dans le Template

### Liste des impayés

```html
<div class="impayes-container">
  <h2>Impayés en Retard</h2>

  <div *ngIf="loading" class="loading">
    Chargement...
  </div>

  <div *ngIf="!loading && impayes.length === 0" class="no-data">
    Aucun impayé trouvé
  </div>

  <table *ngIf="!loading && impayes.length > 0" class="impayes-table">
    <thead>
      <tr>
        <th>Contribuable</th>
        <th>Taxe</th>
        <th>Montant Attendu</th>
        <th>Montant Payé</th>
        <th>Montant Restant</th>
        <th>Statut</th>
        <th>Échéance</th>
      </tr>
    </thead>
    <tbody>
      <tr *ngFor="let impaye of impayes">
        <td>{{ impaye.contribuable_nom }} {{ impaye.contribuable_prenom }}</td>
        <td>{{ impaye.taxe_nom }}</td>
        <td>{{ impaye.montant_attendu | number:'1.0-0' }} FCFA</td>
        <td>{{ impaye.montant_paye | number:'1.0-0' }} FCFA</td>
        <td class="text-danger">{{ impaye.montant_restant | number:'1.0-0' }} FCFA</td>
        <td>
          <span [class]="getStatutClass(impaye.statut)">
            {{ impaye.statut }}
          </span>
        </td>
        <td>{{ impaye.date_echeance | date:'dd/MM/yyyy' }}</td>
      </tr>
    </tbody>
  </table>
</div>
```

### Carte de statistiques

```html
<div class="stats-cards">
  <div class="stat-card">
    <h3>Total Impayés</h3>
    <p class="stat-value">{{ stats?.globales?.total_impaye || 0 }}</p>
  </div>

  <div class="stat-card danger">
    <h3>En Retard</h3>
    <p class="stat-value">{{ stats?.globales?.total_retard || 0 }}</p>
  </div>

  <div class="stat-card warning">
    <h3>Montant Total Dû</h3>
    <p class="stat-value">
      {{ stats?.globales?.montant_impaye_total | number:'1.0-0' }} FCFA
    </p>
  </div>

  <div class="stat-card success">
    <h3>Taux de Paiement</h3>
    <p class="stat-value">
      {{ calculerTauxPaiement() | number:'1.0-1' }}%
    </p>
  </div>
</div>
```

---

## Filtres Disponibles

Lors de l'appel à `getImpayesVue()` ou `getImpayesListe()`, vous pouvez passer ces filtres :

```typescript
{
  skip: 0,              // Pagination: nombre d'éléments à sauter
  limit: 100,           // Pagination: nombre max d'éléments
  statut: 'RETARD',     // Filtrer par statut: PAYE, PARTIEL, IMPAYE, RETARD
  contribuable_id: 123, // Filtrer par contribuable
  taxe_id: 456,         // Filtrer par taxe
  zone_nom: 'Zone A',   // Filtrer par zone
  quartier_nom: 'Q1'    // Filtrer par quartier
}
```

---

## Intégration dans un Composant Existant

Pour modifier le composant `impayes.component.ts` existant afin d'utiliser la vue :

```typescript
// Dans impayes.component.ts

loadImpayes(): void {
  this.loading = true;
  this.error = '';

  // OPTION 1: Utiliser la vue (calcul automatique)
  this.apiService.getImpayesVue({
    skip: this.currentPage * this.pageSize,
    limit: this.pageSize,
    statut: this.filters.statut || undefined
  }).subscribe({
    next: (response) => {
      this.impayes = response.items;
      this.total = response.total;
      this.loading = false;
    },
    error: (err) => {
      this.error = err.error?.detail || 'Erreur lors du chargement';
      this.loading = false;
    }
  });

  // OPTION 2: Utiliser les dossiers (gestion formelle)
  // this.apiService.getImpayes({...}) // Code existant
}

loadStats(): void {
  // Charger les stats depuis la vue
  this.apiService.getStatistiquesImpayesVue().subscribe({
    next: (data) => {
      this.stats = data.globales;
      this.statsZones = data.par_zone;
      this.statsCollecteurs = data.par_collecteur;
    },
    error: (err) => {
      console.error('Erreur stats:', err);
    }
  });
}
```

---

## Différences entre les deux approches

| Aspect | Vue `impayes_view` | Table `dossier_impaye` |
|--------|-------------------|------------------------|
| **Mise à jour** | Automatique (temps réel) | Manuelle (détection) |
| **Données** | Toutes les affectations | Dossiers créés uniquement |
| **Utilisation** | Affichage, reporting, stats | Gestion de recouvrement |
| **Historique** | Non | Oui (notes, assignations) |
| **Pénalités** | Non | Oui (calculées) |

---

## Recommandations

1. **Pour l'affichage général des impayés** : Utilisez `getImpayesVue()`
   - Dashboard
   - Liste des impayés
   - Statistiques
   - Rapports

2. **Pour la gestion des dossiers de recouvrement** : Utilisez `getImpayes()` (existant)
   - Assignation aux collecteurs
   - Suivi des actions
   - Calcul de pénalités
   - Historique

3. **Combiner les deux** :
   ```typescript
   // 1. Afficher tous les impayés depuis la vue
   this.apiService.getImpayesVue({ statut: 'RETARD' }).subscribe(...)

   // 2. Créer un dossier formel pour un impayé spécifique
   this.apiService.createDossierImpaye({
     contribuable_id: impaye.contribuable_id,
     affectation_taxe_id: impaye.affectation_id,
     montant_initial: impaye.montant_restant,
     date_echeance: impaye.date_echeance
   }).subscribe(...)
   ```

---

## Prochaines Étapes

1. Modifier le composant `impayes.component.ts` pour utiliser la vue
2. Créer un nouveau composant pour le dashboard des impayés
3. Ajouter des graphiques pour visualiser les statistiques
4. Implémenter la création automatique de dossiers depuis la vue

---

## Exemple Complet : Dashboard des Impayés

```typescript
import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ApiService } from '../../../services/api.service';

@Component({
  selector: 'app-dashboard-impayes',
  standalone: true,
  imports: [CommonModule],
  template: `
    <div class="dashboard">
      <h1>Tableau de Bord des Impayés</h1>

      <!-- Statistiques -->
      <div class="stats-grid">
        <div class="stat-card">
          <h3>Total Impayés</h3>
          <p>{{ stats?.globales?.total_impaye || 0 }}</p>
        </div>
        <div class="stat-card danger">
          <h3>En Retard</h3>
          <p>{{ stats?.globales?.total_retard || 0 }}</p>
        </div>
        <div class="stat-card warning">
          <h3>Montant Dû</h3>
          <p>{{ stats?.globales?.montant_impaye_total | number:'1.0-0' }} FCFA</p>
        </div>
      </div>

      <!-- Top 10 zones -->
      <div class="zones-section">
        <h2>Top 10 Zones avec le Plus d'Impayés</h2>
        <table>
          <thead>
            <tr>
              <th>Zone</th>
              <th>Nombre</th>
              <th>Montant</th>
            </tr>
          </thead>
          <tbody>
            <tr *ngFor="let zone of stats?.par_zone?.slice(0, 10)">
              <td>{{ zone.zone_nom }}</td>
              <td>{{ zone.nb_impayes }}</td>
              <td>{{ zone.montant_restant_total | number:'1.0-0' }} FCFA</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  `,
  styles: [`
    .dashboard { padding: 2rem; }
    .stats-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
      gap: 1rem;
      margin: 2rem 0;
    }
    .stat-card {
      background: white;
      padding: 1.5rem;
      border-radius: 8px;
      box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }
    .stat-card h3 { margin: 0 0 0.5rem 0; font-size: 0.9rem; }
    .stat-card p { margin: 0; font-size: 2rem; font-weight: bold; }
    .danger { border-left: 4px solid #dc3545; }
    .warning { border-left: 4px solid #ffc107; }
  `]
})
export class DashboardImpayesComponent implements OnInit {
  private apiService = inject(ApiService);

  stats: any = null;
  loading = false;

  ngOnInit(): void {
    this.chargerStatistiques();
  }

  chargerStatistiques(): void {
    this.loading = true;
    this.apiService.getStatistiquesImpayesVue().subscribe({
      next: (data) => {
        this.stats = data;
        this.loading = false;
      },
      error: (err) => {
        console.error('Erreur:', err);
        this.loading = false;
      }
    });
  }
}
```

---

## Support

Pour toute question ou problème :
1. Consultez la documentation backend : `backend/migrations/README_IMPAYES.md`
2. Vérifiez que la vue a été créée : `python migrations/run_impayes_migration.py`
3. Testez les endpoints API directement : `http://localhost:8000/api/impayes/vue/statistiques`
