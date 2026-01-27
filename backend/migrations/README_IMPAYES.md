# Documentation - Gestion des Impayés

## Vue d'ensemble

Il existe **deux approches** pour gérer les impayés dans le système:

### 1. ✅ **Vue SQL `impayes_view` (RECOMMANDÉ)**
Une vue calculée automatiquement basée sur les tables existantes.

**Avantages:**
- ✅ Toujours à jour automatiquement
- ✅ Pas de duplication de données
- ✅ Pas de maintenance requise
- ✅ Performance optimale avec index
- ✅ Source unique de vérité

**Comment ça marche:**
```
Impayé = affectation_taxe (montant attendu) - SUM(info_collecte.montant)
```

### 2. Table `dossier_impaye` (Existante)
Une table séparée pour créer des dossiers de suivi d'impayés.

**Avantages:**
- Permet d'ajouter des notes, assignations, historique
- Suivi du workflow de recouvrement
- Gestion des pénalités personnalisées

**Inconvénients:**
- ❌ Nécessite une synchronisation manuelle
- ❌ Risque de désynchronisation avec les données réelles
- ❌ Duplication d'information

---

## Installation de la vue `impayes_view`

### Étape 1: Créer la vue

```bash
# Depuis le dossier backend
python migrations/run_impayes_migration.py
```

### Étape 2: Vérifier la création

```sql
-- Vérifier que la vue existe
SELECT * FROM impayes_view LIMIT 5;

-- Compter les impayés par statut
SELECT statut, COUNT(*)
FROM impayes_view
GROUP BY statut;
```

---

## Utilisation de la vue

### Requêtes SQL courantes

```sql
-- Tous les impayés (non payés)
SELECT * FROM impayes_view
WHERE statut IN ('IMPAYE', 'RETARD');

-- Impayés d'un contribuable
SELECT * FROM impayes_view
WHERE contribuable_id = 123;

-- Impayés en retard
SELECT * FROM impayes_view
WHERE statut = 'RETARD'
ORDER BY montant_restant DESC;

-- Top 10 des plus gros impayés
SELECT
    contribuable_nom,
    contribuable_prenom,
    taxe_nom,
    montant_restant,
    date_echeance
FROM impayes_view
WHERE statut != 'PAYE'
ORDER BY montant_restant DESC
LIMIT 10;

-- Statistiques par zone
SELECT
    zone_nom,
    COUNT(*) as nb_impayes,
    SUM(montant_restant) as total_impaye
FROM impayes_view
WHERE statut IN ('IMPAYE', 'RETARD')
GROUP BY zone_nom
ORDER BY total_impaye DESC;

-- Impayés par collecteur
SELECT
    collecteur_nom,
    collecteur_prenom,
    COUNT(*) as nb_impayes,
    SUM(montant_restant) as total_a_recouvrer
FROM impayes_view
WHERE statut IN ('IMPAYE', 'RETARD')
GROUP BY collecteur_nom, collecteur_prenom
ORDER BY total_a_recouvrer DESC;
```

---

## Structure de la vue `impayes_view`

### Colonnes disponibles:

**Identifiants:**
- `affectation_id` - ID de l'affectation de taxe
- `contribuable_id` - ID du contribuable
- `taxe_id` - ID de la taxe

**Contribuable:**
- `contribuable_nom` - Nom
- `contribuable_prenom` - Prénom
- `contribuable_telephone` - Téléphone
- `contribuable_numero_identification` - Numéro d'identification

**Taxe:**
- `taxe_nom` - Nom de la taxe
- `taxe_code` - Code de la taxe
- `taxe_periodicite` - Périodicité (mensuelle, trimestrielle, etc.)
- `type_taxe_nom` - Type de taxe
- `service_nom` - Service concerné

**Localisation:**
- `quartier_nom` - Quartier du contribuable
- `zone_nom` - Zone du contribuable

**Collecteur:**
- `collecteur_nom` - Nom du collecteur assigné
- `collecteur_prenom` - Prénom du collecteur

**Montants (calculés automatiquement):**
- `montant_attendu` - Montant total à payer
- `montant_paye` - Montant déjà payé
- `montant_restant` - Montant encore dû

**Statut (calculé automatiquement):**
- `statut` - PAYE, PARTIEL, IMPAYE ou RETARD
  - `PAYE`: Entièrement payé
  - `PARTIEL`: Partiellement payé
  - `IMPAYE`: Aucun paiement
  - `RETARD`: Date d'échéance dépassée et non payé

**Dates:**
- `date_debut` - Date de début de l'affectation
- `date_echeance` - Date limite de paiement
- `date_derniere_collecte` - Date du dernier paiement
- `nombre_paiements` - Nombre de paiements effectués

---

## Quand utiliser quelle approche?

### Utilisez la **VUE** (`impayes_view`) pour:
- ✅ Afficher les impayés en temps réel
- ✅ Rapports et statistiques
- ✅ Dashboard de suivi
- ✅ Listes de contribuables à contacter
- ✅ Tableaux de bord des collecteurs

### Utilisez la **TABLE** (`dossier_impaye`) pour:
- 📋 Créer des dossiers de recouvrement formels
- 📋 Suivre l'historique des actions de recouvrement
- 📋 Ajouter des notes et commentaires
- 📋 Assigner des dossiers à des collecteurs
- 📋 Calculer des pénalités personnalisées

---

## Combinaison des deux approches

La meilleure pratique est d'utiliser les deux:

1. **Vue `impayes_view`** pour identifier les impayés
2. **Table `dossier_impaye`** pour créer des dossiers de recouvrement seulement quand nécessaire

```sql
-- Exemple: Créer un dossier de recouvrement pour les gros impayés
INSERT INTO dossier_impaye (contribuable_id, affectation_taxe_id, montant_initial, date_echeance)
SELECT
    contribuable_id,
    affectation_id,
    montant_attendu,
    date_echeance
FROM impayes_view
WHERE statut = 'RETARD'
  AND montant_restant > 50000  -- Seuil pour créer un dossier
  AND affectation_id NOT IN (SELECT affectation_taxe_id FROM dossier_impaye);
```

---

## Performance et Index

La vue utilise des index pour optimiser les performances:

- `idx_impayes_contribuable` - Index sur `contribuable_id`
- `idx_impayes_taxe` - Index sur `taxe_id`
- `idx_impayes_collecte_lookup` - Index composite pour les calculs

Ces index accélèrent considérablement les requêtes sur la vue.

---

## Maintenance

### La vue ne nécessite AUCUNE maintenance!

Elle se met à jour automatiquement quand:
- Une nouvelle affectation de taxe est créée
- Un paiement est enregistré dans `info_collecte`
- Les montants changent
- Les dates d'échéance sont modifiées

### Pour recréer la vue (si nécessaire):

```bash
python migrations/run_impayes_migration.py
```

---

## Migration depuis l'ancienne approche

Si vous utilisez actuellement uniquement la table `dossier_impaye`, vous pouvez:

1. Créer la vue avec la migration
2. Comparer les données entre la vue et la table
3. Migrer progressivement vers l'utilisation de la vue
4. Garder la table uniquement pour les dossiers de recouvrement actifs

---

## Questions fréquentes

**Q: La vue est-elle mise à jour en temps réel?**
R: Oui, chaque fois que vous interrogez la vue, elle calcule les valeurs à partir des données actuelles.

**Q: La vue ralentit-elle les performances?**
R: Non, grâce aux index, les requêtes sont très rapides même avec beaucoup de données.

**Q: Puis-je modifier les données de la vue?**
R: Non, une vue est en lecture seule. Pour modifier, il faut modifier les tables sous-jacentes (`affectation_taxe` ou `info_collecte`).

**Q: Comment ajouter une colonne à la vue?**
R: Modifiez le fichier SQL `create_impayes_view.sql` et ré-exécutez la migration.

**Q: La vue fonctionne-t-elle avec toutes les périodicités?**
R: Oui, la vue calcule les impayés pour toutes les périodicités définies dans les taxes.
