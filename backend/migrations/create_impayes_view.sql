-- Migration pour créer la vue des impayés
-- Date: 2026-01-27
-- Description: Vue pour calculer automatiquement les impayés par contribuable et taxe

-- Supprimer la vue si elle existe déjà
DROP VIEW IF EXISTS impayes_view;

-- Créer la vue des impayés
CREATE OR REPLACE VIEW impayes_view AS
SELECT
    -- IDs
    at.id AS affectation_id,
    at.contribuable_id,
    at.taxe_id,

    -- Informations contribuable
    c.nom AS contribuable_nom,
    c.prenom AS contribuable_prenom,
    c.telephone AS contribuable_telephone,
    c.numero_identification AS contribuable_numero_identification,
    c.actif AS contribuable_actif,

    -- Informations taxe
    t.nom AS taxe_nom,
    t.code AS taxe_code,
    t.periodicite AS taxe_periodicite,
    t.montant AS taxe_montant_base,

    -- Informations type de taxe et service
    tt.nom AS type_taxe_nom,
    s.nom AS service_nom,

    -- Informations quartier et zone
    q.nom AS quartier_nom,
    z.nom AS zone_nom,

    -- Informations collecteur
    col.nom AS collecteur_nom,
    col.prenom AS collecteur_prenom,

    -- Montants
    COALESCE(at.montant_custom, t.montant) AS montant_attendu,
    COALESCE(
        (SELECT SUM(ic.montant)
         FROM info_collecte ic
         WHERE ic.contribuable_id = at.contribuable_id
           AND ic.taxe_id = at.taxe_id),
        0
    ) AS montant_paye,
    COALESCE(at.montant_custom, t.montant) - COALESCE(
        (SELECT SUM(ic.montant)
         FROM info_collecte ic
         WHERE ic.contribuable_id = at.contribuable_id
           AND ic.taxe_id = at.taxe_id),
        0
    ) AS montant_restant,

    -- Calcul du statut
    CASE
        -- Payé complètement
        WHEN COALESCE(
            (SELECT SUM(ic.montant)
             FROM info_collecte ic
             WHERE ic.contribuable_id = at.contribuable_id
               AND ic.taxe_id = at.taxe_id),
            0
        ) >= COALESCE(at.montant_custom, t.montant) THEN 'PAYE'

        -- En retard (date_fin dépassée et non payé complètement)
        WHEN at.date_fin IS NOT NULL
         AND at.date_fin < NOW()
         AND COALESCE(
            (SELECT SUM(ic.montant)
             FROM info_collecte ic
             WHERE ic.contribuable_id = at.contribuable_id
               AND ic.taxe_id = at.taxe_id),
            0
        ) < COALESCE(at.montant_custom, t.montant) THEN 'RETARD'

        -- Partiellement payé
        WHEN COALESCE(
            (SELECT SUM(ic.montant)
             FROM info_collecte ic
             WHERE ic.contribuable_id = at.contribuable_id
               AND ic.taxe_id = at.taxe_id),
            0
        ) > 0 THEN 'PARTIEL'

        -- Impayé
        ELSE 'IMPAYE'
    END AS statut,

    -- Dates
    at.date_debut AS date_debut,
    at.date_fin AS date_echeance,
    at.created_at AS affectation_created_at,
    at.updated_at AS affectation_updated_at,

    -- Statut de l'affectation
    at.actif AS affectation_active,

    -- Dernière collecte
    (SELECT MAX(ic.date_collecte)
     FROM info_collecte ic
     WHERE ic.contribuable_id = at.contribuable_id
       AND ic.taxe_id = at.taxe_id) AS date_derniere_collecte,

    -- Nombre de paiements
    (SELECT COUNT(*)
     FROM info_collecte ic
     WHERE ic.contribuable_id = at.contribuable_id
       AND ic.taxe_id = at.taxe_id) AS nombre_paiements

FROM affectation_taxe at
INNER JOIN contribuable c ON at.contribuable_id = c.id
INNER JOIN taxe t ON at.taxe_id = t.id
LEFT JOIN type_taxe tt ON t.type_taxe_id = tt.id
LEFT JOIN service s ON t.service_id = s.id
LEFT JOIN quartier q ON c.quartier_id = q.id
LEFT JOIN zone z ON q.zone_id = z.id
LEFT JOIN collecteur col ON c.collecteur_id = col.id

-- On inclut toutes les affectations actives
WHERE at.actif = true
  AND c.actif = true
  AND t.actif = true;

-- Créer des index pour améliorer les performances
CREATE INDEX IF NOT EXISTS idx_impayes_contribuable ON affectation_taxe(contribuable_id) WHERE actif = true;
CREATE INDEX IF NOT EXISTS idx_impayes_taxe ON affectation_taxe(taxe_id) WHERE actif = true;
CREATE INDEX IF NOT EXISTS idx_impayes_collecte_lookup ON info_collecte(contribuable_id, taxe_id, montant);

-- Ajouter des commentaires
COMMENT ON VIEW impayes_view IS 'Vue calculant automatiquement les impayés par contribuable et taxe';
