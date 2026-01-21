-- Table pour stocker les OTP des contribuables (authentification sans mot de passe)
CREATE TABLE IF NOT EXISTS otp_citoyen (
    id SERIAL PRIMARY KEY,
    contribuable_id INTEGER NOT NULL REFERENCES contribuable(id) ON DELETE CASCADE,
    code_hash VARCHAR(255) NOT NULL,
    expires_at TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    used BOOLEAN DEFAULT FALSE,
    channel VARCHAR(20) DEFAULT 'email',
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_otp_citoyen_contribuable ON otp_citoyen(contribuable_id);
CREATE INDEX IF NOT EXISTS idx_otp_citoyen_expires ON otp_citoyen(expires_at);
