DROP VIEW IF EXISTS cartographie_contribuable_view;

CREATE OR REPLACE VIEW cartographie_contribuable_view AS
WITH taxes_dues AS (
    SELECT
        at.contribuable_id,
        COALESCE(SUM(
            CASE
                WHEN at.montant_custom IS NOT NULL THEN at.montant_custom
                ELSE t.montant
            END
        ), 0)::numeric(12,2) AS montant_total_due,
        COUNT(*) AS nombre_taxes_actives
    FROM affectation_taxe at
    JOIN taxe t ON t.id = at.taxe_id
    WHERE at.actif = TRUE
      AND at.date_debut <= NOW()
      AND (at.date_fin IS NULL OR at.date_fin >= NOW())
    GROUP BY at.contribuable_id
),
collectes_stats AS (
    SELECT
        ic.contribuable_id,
        COUNT(*) FILTER (WHERE ic.statut = 'completed' AND ic.annule = FALSE) AS nombre_collectes,
        COALESCE(SUM(
            CASE
                WHEN ic.statut = 'completed' AND ic.annule = FALSE THEN ic.montant
                ELSE 0
            END
        ), 0)::numeric(12,2) AS total_collecte,
        MAX(
            CASE
                WHEN ic.statut = 'completed' AND ic.annule = FALSE THEN ic.date_collecte
                ELSE NULL
            END
        ) AS derniere_collecte,
        BOOL_OR(
            ic.statut = 'completed'
            AND ic.annule = FALSE
            AND ic.date_collecte >= date_trunc('month', now())
        ) AS a_paye
    FROM info_collecte ic
    GROUP BY ic.contribuable_id
),
statut_paiement AS (
    SELECT
        COALESCE(td.contribuable_id, cs.contribuable_id) AS contribuable_id,
        CASE
            WHEN td.montant_total_due = 0 THEN 'paye'  -- Pas de taxes dues
            WHEN COALESCE(cs.total_collecte, 0) >= td.montant_total_due THEN 'paye'  -- Totalement payé
            WHEN COALESCE(cs.total_collecte, 0) > 0 THEN 'partiel'  -- Partiellement payé
            ELSE 'impaye'  -- Non payé
        END AS statut_paiement
    FROM taxes_dues td
    FULL OUTER JOIN collectes_stats cs ON cs.contribuable_id = td.contribuable_id
),
taxes_impayees AS (
    SELECT
        at.contribuable_id,
        json_agg(DISTINCT t.nom) AS taxes
    FROM affectation_taxe at
    JOIN taxe t ON t.id = at.taxe_id
    WHERE at.actif = TRUE
    GROUP BY at.contribuable_id
),
base_contribuables AS (
    SELECT
        c.id,
        c.nom,
        c.prenom,
        c.nom_activite,
        c.telephone,
        c.adresse,
        CASE
            WHEN c.latitude BETWEEN -5 AND 5
             AND c.longitude BETWEEN 6 AND 16 THEN c.latitude::float
            WHEN q.geom IS NOT NULL THEN ST_Y(q.geom)::float
            ELSE NULL
        END AS latitude,
        CASE
            WHEN c.latitude BETWEEN -5 AND 5
             AND c.longitude BETWEEN 6 AND 16 THEN c.longitude::float
            WHEN q.geom IS NOT NULL THEN ST_X(q.geom)::float
            ELSE NULL
        END AS longitude,
        c.photo_url,
        c.actif,
        tc.nom AS type_contribuable,
        q.nom AS quartier,
        z.nom AS zone,
        CONCAT(cl.nom, ' ', COALESCE(cl.prenom, '')) AS collecteur
    FROM contribuable c
    LEFT JOIN quartier q ON q.id = c.quartier_id
    LEFT JOIN zone z ON z.id = q.zone_id
    LEFT JOIN type_contribuable tc ON tc.id = c.type_contribuable_id
    LEFT JOIN collecteur cl ON cl.id = c.collecteur_id
)
SELECT
    bc.id,
    bc.nom,
    bc.prenom,
    bc.nom_activite,
    bc.telephone,
    bc.adresse,
    bc.latitude,
    bc.longitude,
    bc.photo_url,
    bc.actif,
    bc.type_contribuable,
    bc.quartier,
    bc.zone,
    bc.collecteur,
    COALESCE(cs.a_paye, FALSE) AS a_paye,
    COALESCE(sp.statut_paiement, 'impaye') AS statut_paiement,
    COALESCE(cs.total_collecte, 0)::numeric(12,2) AS total_collecte,
    COALESCE(td.montant_total_due, 0)::numeric(12,2) AS montant_total_due,
    COALESCE(cs.nombre_collectes, 0) AS nombre_collectes,
    cs.derniere_collecte,
    COALESCE(ti.taxes, '[]'::json) AS taxes_impayees
FROM base_contribuables bc
LEFT JOIN collectes_stats cs ON cs.contribuable_id = bc.id
LEFT JOIN taxes_dues td ON td.contribuable_id = bc.id
LEFT JOIN statut_paiement sp ON sp.contribuable_id = bc.id
LEFT JOIN taxes_impayees ti ON ti.contribuable_id = bc.id
WHERE bc.latitude IS NOT NULL
  AND bc.longitude IS NOT NULL;