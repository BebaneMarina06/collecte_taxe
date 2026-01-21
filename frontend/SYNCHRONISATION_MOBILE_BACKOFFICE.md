# Synchronisation Mobile ↔ Backoffice

## Vue d'ensemble

Le système de synchronisation automatique permet de garder les données du backoffice Angular synchronisées avec celles créées/modifiées depuis l'application mobile Flutter. Les deux applications partagent la **même base de données Docker** via le backend FastAPI.

## Architecture

```
┌─────────────────┐         ┌──────────────────┐         ┌─────────────────┐
│  App Mobile     │────────▶│  Backend Docker   │◀────────│  Backoffice     │
│  (Flutter)      │         │  (FastAPI)       │         │  (Angular)      │
└─────────────────┘         └──────────────────┘         └─────────────────┘
                                     │
                                     ▼
                            ┌──────────────────┐
                            │  PostgreSQL      │
                            │  (Docker)        │
                            └──────────────────┘
```

## Comment ça fonctionne

### 1. Backend partagé

- **Backend Docker** : `http://localhost:8000`
- **Base de données** : PostgreSQL dans Docker (`taxe_db`)
- Les deux applications (mobile et backoffice) utilisent le **même backend** et donc la **même base de données**

### 2. Synchronisation automatique

Le service `SyncService` rafraîchit automatiquement les données toutes les **10 secondes** dans le backoffice Angular.

#### Composants synchronisés :

- ✅ **Dashboard** : Statistiques (collectes, collecteurs, clients)
- ✅ **Transactions** : Liste des collectes
- ✅ **Clients** : Liste des contribuables
- ✅ **Gestion Collecteurs** : Liste des collecteurs

### 3. Flux de synchronisation

1. **Création dans l'app mobile** :
   - L'utilisateur crée une collecte ou un client dans l'app mobile
   - L'app envoie la requête au backend Docker (`http://10.0.2.2:8000`)
   - Le backend enregistre dans la base PostgreSQL Docker

2. **Rafraîchissement automatique du backoffice** :
   - Toutes les 10 secondes, le `SyncService` émet un événement
   - Les composants Angular s'abonnent à cet événement
   - Les données sont rechargées depuis le backend
   - Les nouvelles données apparaissent automatiquement dans le backoffice

## Configuration

### Intervalle de synchronisation

Par défaut : **10 secondes**

Pour modifier l'intervalle, dans `sync.service.ts` :

```typescript
// Changer l'intervalle à 5 secondes
this.syncService.setInterval(5000);
```

### Désactiver la synchronisation

```typescript
this.syncService.stop();
```

### Forcer une synchronisation immédiate

```typescript
this.syncService.forceSync();
```

## Ajouter la synchronisation à un nouveau composant

1. Importer le `SyncService` et `Subscription` :

```typescript
import { SyncService } from '../../../services/sync.service';
import { Subscription } from 'rxjs';
import { OnDestroy } from '@angular/core';
```

2. Injecter le service :

```typescript
private syncService = inject(SyncService);
private syncSubscription?: Subscription;
```

3. S'abonner dans `ngOnInit` :

```typescript
ngOnInit(): void {
  this.loadData();
  this.syncSubscription = this.syncService.sync$.subscribe(() => {
    this.loadData();
  });
}
```

4. Se désabonner dans `ngOnDestroy` :

```typescript
ngOnDestroy(): void {
  if (this.syncSubscription) {
    this.syncSubscription.unsubscribe();
  }
}
```

## Test de la synchronisation

1. **Lancer le backend Docker** :
   ```bash
   docker compose up -d
   ```

2. **Lancer le backoffice Angular** :
   ```bash
   cd frontend
   npm start
   ```

3. **Lancer l'app mobile** :
   ```bash
   cd e_taxe/e_taxe
   flutter run
   ```

4. **Tester** :
   - Créer une collecte dans l'app mobile
   - Attendre maximum 10 secondes
   - La collecte apparaît automatiquement dans le backoffice (page Transactions)

## Notes importantes

- ⚠️ La synchronisation ne fonctionne que si les deux applications utilisent le **même backend Docker**
- ⚠️ L'intervalle de 10 secondes est un compromis entre réactivité et performance
- ⚠️ Les filtres de recherche sont préservés lors de la synchronisation (les données ne se rafraîchissent que si aucun filtre n'est actif)

