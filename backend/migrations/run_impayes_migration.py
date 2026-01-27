"""
Script pour exécuter la migration de création de la vue impayes_view
Usage: python migrations/run_impayes_migration.py
"""

import os
import sys

# Ajouter le répertoire parent au path
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from sqlalchemy import create_engine, text
from database.database import DATABASE_URL

def run_migration():
    """Exécute la migration SQL pour créer la vue des impayés"""
    print("Démarrage de la migration de la vue des impayés...")

    # Créer la connexion
    engine = create_engine(DATABASE_URL)

    # Lire le fichier SQL
    migration_file = os.path.join(os.path.dirname(__file__), "create_impayes_view.sql")

    with open(migration_file, 'r', encoding='utf-8') as f:
        sql_script = f.read()

    # Exécuter la migration
    try:
        with engine.connect() as connection:
            # Diviser le script en commandes individuelles
            statements = [s.strip() for s in sql_script.split(';') if s.strip()]

            for statement in statements:
                if statement:
                    # Afficher seulement les commandes principales
                    if any(keyword in statement.upper() for keyword in ['DROP VIEW', 'CREATE', 'COMMENT']):
                        cmd_type = statement.split()[0].upper()
                        print(f"Exécution: {cmd_type}...")
                    connection.execute(text(statement))

            connection.commit()
            print("Migration de la vue des impayés exécutée avec succès!")
            print("")
            print("Vous pouvez maintenant utiliser la vue avec:")
            print("  SELECT * FROM impayes_view WHERE statut = 'IMPAYE';")
            print("  SELECT * FROM impayes_view WHERE statut = 'RETARD';")
            print("  SELECT * FROM impayes_view WHERE contribuable_id = 123;")

    except Exception as e:
        print(f"Erreur lors de la migration: {e}")
        sys.exit(1)

if __name__ == "__main__":
    run_migration()
