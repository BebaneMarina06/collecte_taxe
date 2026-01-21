## Endpoints requis pour l’application mobile

Ce document liste les endpoints que le backend FastAPI doit exposer pour alimenter l’application mobile Flutter. Chaque endpoint peut s’appuyer sur des **vues SQL** (recommandé) ou des requêtes ORM classiques, mais **doit respecter le format de données décrit ci‑dessous**.

### Principes généraux
- Authentification JWT obligatoire (`Authorization: Bearer <token>`), sauf mention contraire.
- Format JSON UTF‑8.
- En cas d’échec : renvoyer un message clair (`detail`) et un code HTTP approprié (401, 404, 422, 500…).
- Les identifiants peuvent être renvoyés en `int` ou `string`, mais **le mobile tolère uniquement les valeurs numériques** pour éviter de retomber sur des conversions locales.

---

### 1. Authentication
| Endpoint | Méthode | Params | Corps / Réponse attendue |
|----------|---------|--------|---------------------------|
| `/api/auth/login` | `POST` | Body `x-www-form-urlencoded` (`username`, `password`) | `200` → `{ access_token, token_type, user: { id, nom, prenom, email, role } }` |

---

### 2. Collecteurs
| Endpoint | Usage mobile | Champs attendus |
|----------|--------------|-----------------|
| `GET /api/collecteurs?email=` | Récupérer le collecteur connecté | `id, nom, prenom, matricule, email, telephone, statut, etat, actif, zone_id, heure_cloture` |
| `PATCH /api/collecteurs/{id}/connexion` | Marquer un collecteur en ligne | Pas de réponse spécifique (200) |
| `PATCH /api/collecteurs/{id}/deconnexion` | Marquer hors ligne | Pas de réponse spécifique (200) |
| `PATCH /api/collecteurs/{id}` | Mise à jour (heure de clôture, état, etc.) | Même schéma que `GET` |

---

### 3. Collectes
| Endpoint | Usage | Paramètres supportés | Champs JSON utilisés par l’app |
|----------|-------|----------------------|--------------------------------|
| `GET /api/collectes` | Liste paginée | `collecteur_id`, `contribuable_id`, `taxe_id`, `statut`, `date_debut`, `date_fin`, `telephone`, `skip`, `limit` | `id`, `contribuable_id`, `taxe_id`, `collecteur_id`, `montant`, `commission`, `reference`, `type_paiement`, `statut`, `date_collecte`, `billetage`, `annule`, sous-objets optionnels `contribuable`, `taxe`, `collecteur` |
| `GET /api/collectes/{id}` | Détails | — | Même schéma que liste |
| `POST /api/collectes` | Création | Body JSON : `contribuable_id`, `taxe_id`, `collecteur_id`, `montant`, `type_paiement`, `billetage?`, `date_collecte` | Retourne l’objet `Collecte` complet |
| `PATCH /api/collectes/{id}/valider` | Valider une collecte | — | Collecte mise à jour |
| `PATCH /api/collectes/{id}/annuler` | Annuler (si `raison` fournie) | Body `{ "raison": "..." }` | Collecte mise à jour |

**Vue SQL recommandée** : `vue_collectes_mobile` contenant directement les jointures vers contribuables, taxes et collecteur pour éviter des requêtes multiples.

---

### 4. Contribuables
| Endpoint | Usage | Paramètres | Champs attendus |
|----------|-------|------------|-----------------|
| `GET /api/contribuables` | Liste associée au collecteur | `collecteur_id`, `actif`, `skip`, `limit` | `id`, `nom`, `prenom`, `telephone`, `adresse`, `actif`, `collecteur_id`, `created_at`, `updated_at` |
| `GET /api/contribuables/{id}` | Détails | — | Même schéma |
| `POST /api/contribuables` | Création | Body JSON (`nom`, `prenom`, `telephone?`, `adresse?`, `collecteur_id`) | Retourne contribuable complet |

---

### 5. Taxes
| Endpoint | Usage | Paramètres | Champs attendus |
|----------|-------|------------|-----------------|
| `GET /api/taxes` | Liste des taxes disponibles (filtrables) | `actif`, `type_taxe_id`, `service_id`, `skip`, `limit` | `id`, `nom`, `code`, `description`, `montant`, `montant_variable`, `periodicite`, `commission_pourcentage`, `actif`, `type_taxe_id`, `service_id` |
| `GET /api/taxes/{id}` | Détails | — | Même schéma |

---

### 6. Statistiques (à ajouter)
L’application tente successivement ces URL puis bascule en calcul local si elles retournent 404. Il est donc nécessaire d’en exposer **au moins une** :

| Endpoint | Description | Champs JSON attendus |
|----------|-------------|----------------------|
| `GET /api/rapports/collecteur/{collecteur_id}` | Vue agrégée par collecteur | `total_collecte`, `nombre_collectes`, `collectes_completes`, `collectes_en_attente`, `commission_totale` |
| `GET /api/collecteurs/{collecteur_id}/statistiques` | Variante équivalente | Même schéma |
| `GET /api/statistiques/collecteur/{collecteur_id}` | Variante équivalente | Même schéma |

**Vue SQL recommandée** : `vue_statistiques_collecteur` regroupant les agrégats nécessaires.

---

### 7. Accessibilité & Localisation (nouveau)
Ces endpoints alimentent les réglages d’accessibilité (thèmes, contrastes, tailles de police) et la traduction de l’interface.

| Endpoint | Description | Champs JSON attendus |
|----------|-------------|----------------------|
| `GET /api/app/preferences` | Retourne les préférences serveur par défaut (thème, police, contraste, sons, animations) | `theme_defaut`, `mode_sombre_disponible`, `contrastes_disponibles[]`, `tailles_police[]`, `animations_autorisees`, `sons_confirmation` |
| `PATCH /api/app/preferences` | Sauvegarde les choix d’un collecteur (lié à son `user_id`) | Body : `{ theme, contraste, taille_police, animations, sons }`; réponse = préférences mises à jour |
| `GET /api/localisation/textes` | Fichiers de traduction des libellés mobiles | `lang`, `version`, `strings: { cle: valeur }` |
| `GET /api/localisation/disponibles` | Liste des langues activées et métadonnées | `code`, `nom`, `direction` (ltr/rtl), `defaut` (bool) |

**Remarque** : pour éviter de publier un nouvel APK à chaque ajout de libellé, exposez une version (`version`) afin que l’app sache quand rafraîchir les chaînes.

---

### 8. Suivi des performances (nouveau)
Ces endpoints complètent le module statistiques en fournissant des objectifs, des badges et une timeline des performances.

| Endpoint | Description | Champs JSON attendus |
|----------|-------------|----------------------|
| `GET /api/collecteurs/{collecteur_id}/objectifs` | Objectifs journaliers/hebdo assignés au collecteur | `collecteur_id`, `objectif_journalier`, `objectif_hebdo`, `objectif_mensuel`, `devise`, `periode_courante` |
| `GET /api/collecteurs/{collecteur_id}/performances?periode=jour|semaine|mois` | Historique des montants et volumes pour alimenter les graphiques | `periode`, `points: [{ label, date_debut, date_fin, montant, nombre_collectes }]`, `progression_vs_objectif` |
| `GET /api/collecteurs/{collecteur_id}/badges` | Gamification / badges obtenus et ceux en cours | `badges: [{ code, label, description, statut (locked|in_progress|earned), date_obtention? }]` |
| `POST /api/collecteurs/{collecteur_id}/performances/feedback` | Permet d’accuser réception d’un badge ou d’un palier franchi | Body `{ badge_code, feedback }`, réponse 201 |

Les données peuvent provenir d’une vue SQL `vue_performances_collecteur` qui calcule : total période, moyenne, progression, objectifs atteints (%), meilleures taxes.

---

### 9. QR Code (nouveau)
| Endpoint | Description | Champs JSON attendus |
|----------|-------------|----------------------|
| `GET /api/contribuables/qr/{qr_code}` | Récupérer un contribuable par QR code | Même schéma que `GET /api/contribuables/{id}` |
| `GET /api/collectes/qr/{qr_code}` | Vérifier un reçu par QR code | Même schéma que `GET /api/collectes/{id}` |

**Voir documentation complète** : `ENDPOINTS_QR_LOCATION_NOTIFICATIONS.md`

---

### 10. Géolocalisation (nouveau)
| Endpoint | Description | Champs JSON attendus |
|----------|-------------|----------------------|
| `POST /api/collectes/{id}/location` | Enregistrer la position GPS d'une collecte | Body: `{ latitude, longitude, accuracy?, altitude?, heading?, speed?, timestamp? }` |
| `GET /api/collectes/{id}/location` | Récupérer la position d'une collecte | `{ id, collecte_id, latitude, longitude, accuracy, altitude, heading, speed, timestamp, created_at }` |
| `GET /api/collecteurs/{id}/zones` | Récupérer les zones autorisées | `[{ id, collecteur_id, nom, latitude, longitude, radius, description, actif }]` |

**Voir documentation complète** : `ENDPOINTS_QR_LOCATION_NOTIFICATIONS.md`

---

### 11. Notifications (nouveau)
| Endpoint | Description | Champs JSON attendus |
|----------|-------------|----------------------|
| `POST /api/notifications/register` | Enregistrer le token FCM | Body: `{ token, platform }` |
| `GET /api/notifications` | Récupérer les notifications | Query: `unread_only?`, `skip?`, `limit?` → `[{ id, user_id, type, title, message, read, data, created_at }]` |
| `PUT /api/notifications/{id}/read` | Marquer comme lu | `{ id, read, updated_at }` |
| `DELETE /api/notifications/{id}` | Supprimer une notification | `{ message }` |
| `GET /api/notifications/count` | Nombre de notifications non lues | `{ count }` |

**Voir documentation complète** : `ENDPOINTS_QR_LOCATION_NOTIFICATIONS.md`

---

### 12. Endpoints utilitaires
| Endpoint | Usage | Notes |
|----------|-------|-------|
| `POST /api/auth/change-password` | Changement de mot de passe | Body JSON `{ old_password, new_password }` |
| `GET /health` | Health check | Pas d'authentification |

---

### Résumé des colonnes critiques par modèle
- **Collecte** : `id`, `contribuable_id`, `taxe_id`, `collecteur_id`, `montant`, `commission`, `reference`, `type_paiement`, `statut`, `date_collecte`, `billetage`, `annule`.
- **Contribuable** : `id`, `nom`, `prenom`, `telephone`, `adresse`, `actif`, `collecteur_id`, `qr_code` (nouveau).
- **Taxe** : `id`, `nom`, `code`, `description`, `montant`, `commission_pourcentage`, `montant_variable`, `periodicite`, `actif`.
- **Collecteur** : `id`, `nom`, `prenom`, `matricule`, `email`, `telephone`, `statut`, `etat`, `actif`, `zone_id`, `heure_cloture`.
- **StatistiquesCollecteur** : `collecteur_id`, `total_collecte`, `commission_totale`, `nombre_collectes`, `collectes_completes`, `collectes_en_attente`.
- **PreferencesCollecteur** : `collecteur_id`, `theme`, `contraste`, `taille_police`, `animations`, `sons`, `lang`.
- **PerformancesCollecteur** : `collecteur_id`, `periode`, `objectif`, `montant_realise`, `progression`, `badge_code`, `badge_statut`.
- **CollecteLocation** (nouveau) : `id`, `collecte_id`, `latitude`, `longitude`, `accuracy`, `altitude`, `heading`, `speed`, `timestamp`.
- **CollecteurZone** (nouveau) : `id`, `collecteur_id`, `nom`, `latitude`, `longitude`, `radius`, `description`, `actif`.
- **Notification** (nouveau) : `id`, `user_id`, `type`, `title`, `message`, `read`, `data` (JSONB), `created_at`.
- **NotificationToken** (nouveau) : `id`, `user_id`, `token`, `platform`, `created_at`, `updated_at`.

---

### Processus d’ajout
1. Créer les vues SQL nécessaires (ou requêtes optimisées) et les documenter.
2. Ajouter les routes FastAPI correspondantes dans les routers dédiés.
3. Tester en local (`/docs`, `curl`, tests automatisés).
4. Déployer sur Render (push Git), vérifier les logs et tester en production.
5. Confirmer côté mobile que chaque endpoint renvoie bien les champs listés ci‑dessus (sinon l’application tombera sur les parsers de secours ou sur le calcul local).

Ce fichier sert de contrat entre l’équipe backend et l’équipe mobile pour garantir la disponibilité des données nécessaires à l’application e_taxe.

