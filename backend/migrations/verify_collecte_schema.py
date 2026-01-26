#!/usr/bin/env python3
"""
Script pour vérifier et corriger le schéma des collectes
"""

import os
import sys
from pathlib import Path

# Ajouter le répertoire parent au chemin
sys.path.insert(0, str(Path(__file__).parent.parent))

from database.database import engine
from sqlalchemy import inspect, text
from database.models import InfoCollecte, CollecteItem, Taxe

def check_schema():
    """Vérifie l'état du schéma"""
    inspector = inspect(engine)
    
    print("=" * 60)
    print("VÉRIFICATION DU SCHÉMA DES COLLECTES")
    print("=" * 60)
    
    # Vérifier la table info_collecte
    print("\n✓ Table info_collecte:")
    if "info_collecte" in inspector.get_table_names():
        columns = inspector.get_columns("info_collecte")
        for col in columns:
            print(f"  - {col['name']}: {col['type']}")
    else:
        print("  ✗ Table info_collecte non trouvée!")
        return False
    
    # Vérifier la table collecte_item
    print("\n✓ Table collecte_item:")
    if "collecte_item" in inspector.get_table_names():
        columns = inspector.get_columns("collecte_item")
        for col in columns:
            print(f"  - {col['name']}: {col['type']}")
        
        # Vérifier les ForeignKeys
        fks = inspector.get_foreign_keys("collecte_item")
        print(f"\n  Foreign Keys: {len(fks)}")
        for fk in fks:
            print(f"    - {fk['constrained_columns']} -> {fk['referred_table']}")
    else:
        print("  ✗ Table collecte_item non trouvée!")
        print("  → Vous devez exécuter la migration add_collecte_items_table.sql")
        return False
    
    # Vérifier les models SQLAlchemy
    print("\n✓ Modèles SQLAlchemy:")
    try:
        # Vérifier que InfoCollecte a bien la relation items_collecte
        mapper = inspect(InfoCollecte)
        if 'items_collecte' in [rel.key for rel in mapper.relationships]:
            print("  ✓ InfoCollecte.items_collecte relation OK")
        else:
            print("  ✗ Relation items_collecte manquante sur InfoCollecte")
            return False
        
        # Vérifier que CollecteItem existe
        mapper = inspect(CollecteItem)
        print("  ✓ CollecteItem model OK")
        
        # Vérifier que Taxe a la relation collecte_items
        mapper = inspect(Taxe)
        if 'collecte_items' in [rel.key for rel in mapper.relationships]:
            print("  ✓ Taxe.collecte_items relation OK")
        else:
            print("  ✗ Relation collecte_items manquante sur Taxe")
            return False
    except Exception as e:
        print(f"  ✗ Erreur lors de la vérification des modèles: {e}")
        return False
    
    print("\n" + "=" * 60)
    print("✓ SCHÉMA VALIDE - Prêt pour les collectes multi-taxes")
    print("=" * 60)
    return True

def run_migration():
    """Exécute la migration SQL"""
    migration_file = Path(__file__).parent / "add_collecte_items_table.sql"
    
    if not migration_file.exists():
        print(f"✗ Fichier de migration non trouvé: {migration_file}")
        return False
    
    print(f"\nExécution de la migration: {migration_file}")
    
    with open(migration_file, 'r', encoding='utf-8') as f:
        sql_content = f.read()
    
    try:
        with engine.connect() as connection:
            # Exécuter chaque instruction SQL
            for statement in sql_content.split(';'):
                statement = statement.strip()
                if statement and not statement.startswith('--'):
                    print(f"  → Exécution: {statement[:60]}...")
                    connection.execute(text(statement))
            connection.commit()
        print("✓ Migration exécutée avec succès")
        return True
    except Exception as e:
        print(f"✗ Erreur lors de la migration: {e}")
        return False

def main():
    print("\n🔧 OUTIL DE VÉRIFICATION DU SCHÉMA DES COLLECTES\n")
    
    # Vérifier d'abord
    if not check_schema():
        print("\n⚠ Le schéma n'est pas valide")
        print("🔄 Tentative d'exécution de la migration...")
        if run_migration():
            print("\n✓ Migration exécutée")
            print("🔄 Nouvelle vérification...")
            check_schema()
        else:
            print("✗ La migration a échoué")
            sys.exit(1)

if __name__ == "__main__":
    main()
