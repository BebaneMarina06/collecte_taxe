-- Table pour l'authentification des appareils des collecteurs

CREATE TABLE IF NOT EXISTS appareil_collecteur (
    id SERIAL PRIMARY KEY,
    collecteur_id INTEGER NOT NULL REFERENCES collecteur(id) ON DELETE CASCADE,
    device_id VARCHAR(255) NOT NULL,
    plateforme VARCHAR(50),
    device_info TEXT,
    authorized BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_appareil_collecteur UNIQUE (collecteur_id, device_id)
);


