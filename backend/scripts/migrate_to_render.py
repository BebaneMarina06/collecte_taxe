"""
Script de migration des données de la base locale vers Render
Exporte toutes les données de la base PostgreSQL locale et les importe dans Render
"""

import os
import sys
import subprocess
from pathlib import Path
from urllib.parse import urlparse
import psycopg2
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT
from datetime import datetime

# Ajouter le répertoire parent au path
sys.path.insert(0, str(Path(__file__).parent.parent))

from database.database import DATABASE_URL


def export_local_database(local_db_url: str, output_file: str = None):
    """
    Exporte toutes les données de la base de données locale vers un fichier SQL
    """
    if output_file is None:
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        output_file = Path(__file__).parent.parent / f"migration_render_{timestamp}.sql"
    
    print(f"📤 Exportation de la base de données locale...")
    print(f"   Fichier de sortie: {output_file}")
    
    # Parser l'URL
    parsed = urlparse(local_db_url)
    db_name = parsed.path.lstrip('/')
    db_user = parsed.username or 'postgres'
    db_password = parsed.password or ''
    db_host = parsed.hostname or 'localhost'
    db_port = parsed.port or 5432
    
    print(f"   Base de données: {db_name}")
    print(f"   Host: {db_host}")
    
    try:
        # Utiliser pg_dump pour exporter
        env = os.environ.copy()
        if db_password:
            env['PGPASSWORD'] = db_password
        
        cmd = [
            'pg_dump',
            '-h', db_host,
            '-p', str(db_port),
            '-U', db_user,
            '-d', db_name,
            '--data-only',  # Seulement les données, pas le schéma
            '--inserts',    # Format INSERT plutôt que COPY
            '--encoding', 'UTF8',
            '-f', str(output_file)
        ]
        
        print(f"\n🔄 Exécution de pg_dump...")
        result = subprocess.run(
            cmd,
            env=env,
            capture_output=True,
            text=True,
            encoding='utf-8'
        )
        
        if result.returncode == 0:
            file_size = os.path.getsize(output_file) / 1024 / 1024
            print(f"✅ Exportation réussie!")
            print(f"   Taille du fichier: {file_size:.2f} MB")
            return str(output_file)
        else:
            print(f"❌ Erreur lors de l'exportation:")
            print(f"   {result.stderr}")
            return None
            
    except FileNotFoundError:
        print("❌ pg_dump n'est pas trouvé dans le PATH")
        print("💡 Installez PostgreSQL ou ajoutez pg_dump au PATH")
        return None
    except Exception as e:
        print(f"❌ Erreur: {e}")
        return None


def export_with_python(local_db_url: str, output_file: str = None):
    """
    Exporte les données en utilisant Python (alternative si pg_dump n'est pas disponible)
    """
    if output_file is None:
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        output_file = Path(__file__).parent.parent / f"migration_render_{timestamp}.sql"
    
    print(f"📤 Exportation avec Python...")
    
    parsed = urlparse(local_db_url)
    db_name = parsed.path.lstrip('/')
    db_user = parsed.username or 'postgres'
    db_password = parsed.password or ''
    db_host = parsed.hostname or 'localhost'
    db_port = parsed.port or 5432
    
    try:
        conn = psycopg2.connect(
            host=db_host,
            port=db_port,
            database=db_name,
            user=db_user,
            password=db_password
        )
        cursor = conn.cursor()
        
        # Liste des tables à exporter (ordre important pour les clés étrangères)
        tables = [
            'service', 'type_taxe', 'zone', 'quartier', 'type_contribuable',
            'collecteur', 'contribuable', 'taxe', 'affectation_taxe',
            'info_collecte', 'utilisateur', 'zone_geographique',
            'dossier_impaye', 'relance', 'caisse', 'operation_caisse',
            'journal', 'coupure', 'transaction_bamboopay'
        ]
        
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write("-- Migration vers Render\n")
            f.write(f"-- Exporté le: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n")
            f.write("-- ============================================\n\n")
            
            for table in tables:
                try:
                    # Vérifier si la table existe
                    cursor.execute(f"""
                        SELECT EXISTS (
                            SELECT FROM information_schema.tables 
                            WHERE table_schema = 'public' 
                            AND table_name = %s
                        );
                    """, (table,))
                    
                    if not cursor.fetchone()[0]:
                        print(f"   ⚠️ Table '{table}' n'existe pas, ignorée")
                        continue
                    
                    # Compter les lignes
                    cursor.execute(f"SELECT COUNT(*) FROM {table};")
                    count = cursor.fetchone()[0]
                    
                    if count == 0:
                        print(f"   ⚠️ Table '{table}' est vide, ignorée")
                        continue
                    
                    print(f"   📋 Exportation de '{table}' ({count} lignes)...")
                    
                    # Récupérer les données
                    cursor.execute(f"SELECT * FROM {table};")
                    columns = [desc[0] for desc in cursor.description]
                    
                    f.write(f"\n-- Table: {table}\n")
                    f.write(f"-- {count} lignes\n")
                    f.write(f"TRUNCATE TABLE {table} CASCADE;\n\n")
                    
                    # Générer les INSERT
                    rows = cursor.fetchall()
                    for row in rows:
                        values = []
                        for val in row:
                            if val is None:
                                values.append('NULL')
                            elif isinstance(val, str):
                                # Échapper les apostrophes
                                val_escaped = val.replace("'", "''")
                                values.append(f"'{val_escaped}'")
                            elif isinstance(val, (int, float)):
                                values.append(str(val))
                            elif isinstance(val, bool):
                                values.append('TRUE' if val else 'FALSE')
                            else:
                                values.append(f"'{str(val)}'")
                        
                        columns_str = ', '.join(columns)
                        values_str = ', '.join(values)
                        f.write(f"INSERT INTO {table} ({columns_str}) VALUES ({values_str});\n")
                    
                    f.write("\n")
                    
                except Exception as e:
                    print(f"   ❌ Erreur lors de l'exportation de '{table}': {e}")
                    continue
        
        cursor.close()
        conn.close()
        
        file_size = os.path.getsize(output_file) / 1024 / 1024
        print(f"✅ Exportation réussie!")
        print(f"   Taille du fichier: {file_size:.2f} MB")
        return str(output_file)
        
    except Exception as e:
        print(f"❌ Erreur lors de l'exportation: {e}")
        return None


def import_to_render(dump_file: str, render_db_url: str):
    """
    Importe le dump SQL dans la base de données Render
    """
    print(f"\n📥 Importation vers Render...")
    
    parsed = urlparse(render_db_url)
    db_name = parsed.path.lstrip('/')
    db_user = parsed.username or 'postgres'
    db_password = parsed.password or ''
    db_host = parsed.hostname or 'localhost'
    db_port = parsed.port or 5432
    
    print(f"   Host: {db_host}")
    print(f"   Database: {db_name}")
    print(f"   User: {db_user}")
    
    try:
        # Connexion à Render
        conn = psycopg2.connect(
            host=db_host,
            port=db_port,
            database=db_name,
            user=db_user,
            password=db_password,
            connect_timeout=10
        )
        conn.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
        cursor = conn.cursor()
        
        # Activer PostGIS si nécessaire
        print("   🔧 Activation de PostGIS...")
        try:
            cursor.execute("CREATE EXTENSION IF NOT EXISTS postgis;")
            print("   ✅ PostGIS activé")
        except Exception as e:
            print(f"   ⚠️ PostGIS: {e}")
        
        # Lire et exécuter le dump
        print(f"   📖 Lecture du fichier dump...")
        with open(dump_file, 'r', encoding='utf-8') as f:
            dump_content = f.read()
        
        # Diviser en commandes (simplifié)
        print(f"   ⚙️ Exécution des commandes SQL...")
        
        # Exécuter par blocs pour éviter les problèmes de mémoire
        commands = dump_content.split(';')
        total_commands = len([c for c in commands if c.strip() and not c.strip().startswith('--')])
        executed = 0
        
        for cmd in commands:
            cmd = cmd.strip()
            if not cmd or cmd.startswith('--'):
                continue
            
            try:
                cursor.execute(cmd)
                executed += 1
                if executed % 100 == 0:
                    print(f"   ⏳ {executed}/{total_commands} commandes exécutées...")
            except Exception as e:
                # Ignorer certaines erreurs (doublons, etc.)
                if 'duplicate key' in str(e).lower() or 'already exists' in str(e).lower():
                    continue
                print(f"   ⚠️ Erreur: {e}")
                print(f"   Commande: {cmd[:100]}...")
        
        cursor.close()
        conn.close()
        
        print(f"✅ Importation réussie! ({executed} commandes exécutées)")
        return True
        
    except Exception as e:
        print(f"❌ Erreur lors de l'importation: {e}")
        print(f"\n💡 Solutions possibles:")
        print(f"   1. Vérifiez que l'URL de Render est correcte")
        print(f"   2. Vérifiez que la base de données Render est accessible")
        print(f"   3. Utilisez l'External Database URL de Render")
        return False


def verify_migration(render_db_url: str):
    """
    Vérifie que les données ont été migrées correctement
    """
    print(f"\n🔍 Vérification de la migration...")
    
    parsed = urlparse(render_db_url)
    db_name = parsed.path.lstrip('/')
    db_user = parsed.username or 'postgres'
    db_password = parsed.password or ''
    db_host = parsed.hostname or 'localhost'
    db_port = parsed.port or 5432
    
    try:
        conn = psycopg2.connect(
            host=db_host,
            port=db_port,
            database=db_name,
            user=db_user,
            password=db_password
        )
        cursor = conn.cursor()
        
        tables = ['contribuable', 'collecteur', 'taxe', 'info_collecte', 'utilisateur']
        
        for table in tables:
            try:
                cursor.execute(f"SELECT COUNT(*) FROM {table};")
                count = cursor.fetchone()[0]
                print(f"   ✅ {table}: {count} lignes")
            except Exception as e:
                print(f"   ⚠️ {table}: {e}")
        
        cursor.close()
        conn.close()
        
        print(f"\n✅ Vérification terminée!")
        
    except Exception as e:
        print(f"❌ Erreur lors de la vérification: {e}")


if __name__ == "__main__":
    import argparse
    
    parser = argparse.ArgumentParser(description="Migrer les données de la base locale vers Render")
    parser.add_argument(
        "--local-db-url",
        type=str,
        help="URL de la base de données locale (défaut: depuis .env)"
    )
    parser.add_argument(
        "--render-db-url",
        type=str,
        required=True,
        help="URL de la base de données Render (External Database URL)"
    )
    parser.add_argument(
        "--export-only",
        action="store_true",
        help="Exporter uniquement sans importer"
    )
    parser.add_argument(
        "--import-only",
        type=str,
        help="Importer uniquement depuis un fichier dump"
    )
    parser.add_argument(
        "--use-python",
        action="store_true",
        help="Utiliser Python au lieu de pg_dump pour l'export"
    )
    
    args = parser.parse_args()
    
    # URL de la base locale
    local_db_url = args.local_db_url or DATABASE_URL
    
    print("=" * 60)
    print("  Migration des données vers Render")
    print("=" * 60)
    print()
    
    if args.import_only:
        # Import uniquement
        print(f"📥 Importation depuis: {args.import_only}")
        success = import_to_render(args.import_only, args.render_db_url)
        if success:
            verify_migration(args.render_db_url)
    elif args.export_only:
        # Export uniquement
        if args.use_python:
            dump_file = export_with_python(local_db_url)
        else:
            dump_file = export_local_database(local_db_url)
        
        if dump_file:
            print(f"\n✅ Fichier dump créé: {dump_file}")
            print(f"💡 Pour l'importer dans Render, utilisez:")
            print(f"   python migrate_to_render.py --import-only {dump_file} --render-db-url {args.render_db_url}")
    else:
        # Export puis import
        print("Étape 1: Exportation de la base locale...")
        if args.use_python:
            dump_file = export_with_python(local_db_url)
        else:
            dump_file = export_local_database(local_db_url)
        
        if dump_file:
            print(f"\nÉtape 2: Importation vers Render...")
            success = import_to_render(dump_file, args.render_db_url)
            
            if success:
                verify_migration(args.render_db_url)
                print(f"\n✅ Migration terminée avec succès!")
            else:
                print(f"\n❌ L'importation a échoué")
                print(f"💡 Le fichier dump est sauvegardé: {dump_file}")
                print(f"   Vous pouvez réessayer avec:")
                print(f"   python migrate_to_render.py --import-only {dump_file} --render-db-url {args.render_db_url}")
        else:
            print(f"\n❌ L'exportation a échoué")

