-- ==================== TABLE DEMANDE_CITOYEN ====================
CREATE TYPE statut_demande_enum AS ENUM ('envoyee', 'en_traitement', 'complete', 'rejetee');

CREATE TABLE IF NOT EXISTS demande_citoyen (
    id SERIAL PRIMARY KEY,
    contribuable_id INTEGER NOT NULL REFERENCES contribuable(id) ON DELETE CASCADE,
    type_demande VARCHAR(100) NOT NULL,
    sujet VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    statut statut_demande_enum DEFAULT 'envoyee',
    reponse TEXT,
    traite_par_id INTEGER REFERENCES utilisateur(id) ON DELETE SET NULL,
    date_traitement TIMESTAMP,
    pieces_jointes JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_demande_citoyen_contribuable ON demande_citoyen(contribuable_id);
CREATE INDEX idx_demande_citoyen_statut ON demande_citoyen(statut);
CREATE INDEX idx_demande_citoyen_created_at ON demande_citoyen(created_at DESC);

