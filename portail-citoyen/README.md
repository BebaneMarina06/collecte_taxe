# Portail Citoyen - Mairie de Libreville

Application web permettant aux citoyens d'accéder aux services de la mairie, de faire des demandes, de consulter leurs taxes et de payer en ligne.

## Fonctionnalités

- **Page d'accueil** : Présentation des services de la mairie
- **Authentification** : Connexion par téléphone et mot de passe
- **Dashboard** : Vue d'ensemble des demandes et taxes
- **Gestion des demandes** : Création, suivi et consultation des demandes de services
- **Consultation des taxes** : Visualisation des taxes, échéances et montants dus
- **Paiement en ligne** : Paiement des taxes via BambooPay (Mobile Money ou paiement web)

## Prérequis

- Node.js 18+ et npm
- Backend FastAPI démarré sur `http://localhost:8000`

## Installation

```bash
cd portail-citoyen
npm install
```

## Démarrage

```bash
npm start
```

L'application sera accessible sur `http://localhost:4201`

## Configuration

Modifiez `src/environments/environment.ts` pour changer l'URL de l'API :

```typescript
export const environment = {
  production: false,
  apiUrl: 'http://localhost:8000'
};
```

## Migration de base de données

Avant de pouvoir utiliser l'authentification des citoyens, exécutez la migration SQL :

```bash
# Depuis le dossier backend
psql -U votre_user -d votre_database -f database/migrations/add_citoyen_auth_fields.sql
```

Cette migration ajoute les champs `mot_de_passe_hash` et `matricule` à la table `contribuable`.

## Structure de l'application

```
src/
├── app/
│   ├── pages/
│   │   ├── accueil/          # Page d'accueil
│   │   ├── login/             # Page de connexion
│   │   ├── dashboard/         # Tableau de bord
│   │   ├── demandes/          # Liste des demandes
│   │   ├── nouvelle-demande/  # Création de demande
│   │   ├── taxes/              # Liste des taxes
│   │   └── paiement/           # Page de paiement
│   ├── services/
│   │   ├── auth.service.ts    # Service d'authentification
│   │   └── api.service.ts     # Service API
│   ├── guards/
│   │   └── auth.guard.ts      # Guard d'authentification
│   └── interceptors/
│       └── auth.interceptor.ts # Intercepteur HTTP
```

## Endpoints API utilisés

- `POST /api/citoyen/login` - Authentification
- `GET /api/services` - Liste des services
- `GET /api/demandes-citoyens?contribuable_id={id}` - Liste des demandes
- `POST /api/demandes-citoyens` - Création de demande
- `GET /api/citoyen/taxes/{contribuable_id}` - Taxes du contribuable
- `GET /api/client/taxes` - Taxes disponibles
- `POST /api/client/paiement/initier` - Initier un paiement
- `GET /api/client/paiement/statut/{billing_id}` - Statut du paiement

## Notes importantes

- Les contribuables doivent avoir un `mot_de_passe_hash` configuré pour pouvoir se connecter
- Le paiement en ligne utilise BambooPay (configuration requise dans le backend)
- Les demandes peuvent avoir les statuts : `envoyee`, `en_traitement`, `complete`, `rejetee`
- Les taxes peuvent avoir les statuts : `a_jour`, `en_retard`, `partiellement_paye`
