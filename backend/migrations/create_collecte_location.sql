-- Migration pour créer la table collecte_location
-- Date: 2026-01-27
-- Description: Table pour stocker la géolocalisation des collectes

-- Créer la table collecte_location
CREATE TABLE IF NOT EXISTS collecte_location (
    id SERIAL PRIMARY KEY,
    collecte_id INTEGER NOT NULL UNIQUE,
    latitude NUMERIC(10, 8) NOT NULL,
    longitude NUMERIC(11, 8) NOT NULL,
    accuracy NUMERIC(10, 2),
    altitude NUMERIC(10, 2),
    heading NUMERIC(5, 2),
    speed NUMERIC(10, 2),
    timestamp TIMESTAMP WITHOUT TIME ZONE,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT (NOW() AT TIME ZONE 'utc'),
    updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT (NOW() AT TIME ZONE 'utc'),

    -- Foreign key constraint
    CONSTRAINT fk_collecte_location_collecte
        FOREIGN KEY (collecte_id)
        REFERENCES info_collecte(id)
        ON DELETE CASCADE
);

-- Créer un index sur collecte_id pour améliorer les performances
CREATE INDEX IF NOT EXISTS idx_collecte_location_collecte_id ON collecte_location(collecte_id);

-- Ajouter un commentaire sur la table
COMMENT ON TABLE collecte_location IS 'Position GPS enregistrée lors d''une collecte';
COMMENT ON COLUMN collecte_location.latitude IS 'Latitude en degrés décimaux';
COMMENT ON COLUMN collecte_location.longitude IS 'Longitude en degrés décimaux';
COMMENT ON COLUMN collecte_location.accuracy IS 'Précision de la position en mètres';
COMMENT ON COLUMN collecte_location.altitude IS 'Altitude en mètres';
COMMENT ON COLUMN collecte_location.heading IS 'Direction en degrés (0-360)';
COMMENT ON COLUMN collecte_location.speed IS 'Vitesse en mètres par seconde';
COMMENT ON COLUMN collecte_location.timestamp IS 'Horodatage de la position GPS';
