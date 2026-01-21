-- Migration: Ajouter les champs nécessaires pour l'authentification des citoyens
-- Date: 2024-01-XX

-- Ajouter le champ mot_de_passe_hash si il n'existe pas
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'contribuable' AND column_name = 'mot_de_passe_hash'
    ) THEN
        ALTER TABLE contribuable ADD COLUMN mot_de_passe_hash VARCHAR(255);
        -- Initialiser avec un hash par défaut pour les contribuables existants
        -- Les contribuables devront réinitialiser leur mot de passe
        UPDATE contribuable SET mot_de_passe_hash = '$2b$12$default_hash_placeholder' WHERE mot_de_passe_hash IS NULL;
    END IF;
END $$;

-- Ajouter le champ matricule si il n'existe pas
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'contribuable' AND column_name = 'matricule'
    ) THEN
        ALTER TABLE contribuable ADD COLUMN matricule VARCHAR(50);
    END IF;
END $$;

-- Créer un index sur le champ telephone pour améliorer les performances de recherche
CREATE INDEX IF NOT EXISTS idx_contribuable_telephone ON contribuable(telephone);

