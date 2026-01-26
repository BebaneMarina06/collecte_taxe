-- Migration: Ajouter la table collecte_item pour supporter plusieurs taxes par collecte
-- Date: 2026-01-26
-- Description: Modifie info_collecte pour supporter plusieurs taxes et crée la table de liaison

-- 1. Créer la table collecte_item
CREATE TABLE IF NOT EXISTS collecte_item (
    id SERIAL PRIMARY KEY,
    collecte_id INTEGER NOT NULL,
    taxe_id INTEGER NOT NULL,
    montant NUMERIC(12, 2) NOT NULL,
    commission NUMERIC(12, 2) DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (collecte_id) REFERENCES info_collecte(id) ON DELETE CASCADE,
    FOREIGN KEY (taxe_id) REFERENCES taxe(id)
);

-- 2. Ajouter les colonnes montant_total et commission_total à info_collecte (si elles n'existent pas)
ALTER TABLE info_collecte 
ADD COLUMN IF NOT EXISTS montant_total NUMERIC(12, 2),
ADD COLUMN IF NOT EXISTS commission_total NUMERIC(12, 2) DEFAULT 0.00;

-- 3. Mettre à jour montant_total et commission_total avec les valeurs de montant et commission
UPDATE info_collecte 
SET 
    montant_total = montant,
    commission_total = commission
WHERE montant_total IS NULL;

-- 4. Créer des indices pour les performances
CREATE INDEX IF NOT EXISTS idx_collecte_item_collecte_id ON collecte_item(collecte_id);
CREATE INDEX IF NOT EXISTS idx_collecte_item_taxe_id ON collecte_item(taxe_id);

-- 5. Créer un trigger pour mettre à jour updated_at
CREATE OR REPLACE FUNCTION update_collecte_item_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_collecte_item_updated_at ON collecte_item;
CREATE TRIGGER trigger_collecte_item_updated_at
BEFORE UPDATE ON collecte_item
FOR EACH ROW
EXECUTE FUNCTION update_collecte_item_timestamp();

-- Note: Les colonnes taxe_id et montant dans info_collecte peuvent être dépréciées mais conservées pour compatibilité
-- Les clients doivent utiliser collecte_item pour les nouvelles collectes
