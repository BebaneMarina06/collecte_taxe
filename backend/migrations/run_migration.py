"""
Script pour exécuter la migration de création de la table collecte_location
Usage: python migrations/run_migration.py
"""

import os
import sys

# Ajouter le répertoire parent au path
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from sqlalchemy import create_engine, text
from database.database import DATABASE_URL

def run_migration():
    """Exécute la migration SQL"""
    print("Démarrage de la migration...")

    # Créer la connexion
    engine = create_engine(DATABASE_URL)

    # Lire le fichier SQL
    migration_file = os.path.join(os.path.dirname(__file__), "create_collecte_location.sql")

    with open(migration_file, 'r', encoding='utf-8') as f:
        sql_script = f.read()

    # Exécuter la migration
    try:
        with engine.connect() as connection:
            # Diviser le script en commandes individuelles
            statements = [s.strip() for s in sql_script.split(';') if s.strip()]

            for statement in statements:
                if statement:
                    print(f"Exécution: {statement[:60]}...")
                    connection.execute(text(statement))

            connection.commit()
            print("Migration exécutée avec succès!")

    except Exception as e:
        print(f"Erreur lors de la migration: {e}")
        sys.exit(1)

if __name__ == "__main__":
    run_migration()
