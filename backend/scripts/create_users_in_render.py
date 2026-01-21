"""
Script pour créer les utilisateurs directement dans Render via SQL
Contourne le problème d'authentification en créant directement dans la base
"""

import sys
from pathlib import Path
import psycopg2
from urllib.parse import urlparse

sys.path.insert(0, str(Path(__file__).parent.parent))

from database.database import SessionLocal
from database.models import Utilisateur
from auth.security import get_password_hash


def create_users_in_render(render_db_url: str, create_all: bool = False):
    """
    Crée les utilisateurs directement dans Render via SQL
    """
    print("=" * 60)
    print("  Création des utilisateurs dans Render")
    print("=" * 60)
    print()
    
    # Parser l'URL
    parsed = urlparse(render_db_url)
    db_name = parsed.path.lstrip('/')
    db_user = parsed.username or 'postgres'
    db_password = parsed.password or ''
    db_host = parsed.hostname or 'localhost'
    db_port = parsed.port or 5432
    
    print(f"🔌 Connexion à Render...")
    print(f"   Host: {db_host}")
    print(f"   Database: {db_name}")
    
    try:
        # Connexion à Render
        conn = psycopg2.connect(
            host=db_host,
            port=db_port,
            database=db_name,
            user=db_user,
            password=db_password,
            connect_timeout=30
        )
        cursor = conn.cursor()
        print("✅ Connexion réussie!")
        
        # Récupérer les utilisateurs de la base locale
        print("\n📤 Récupération des utilisateurs de la base locale...")
        db = SessionLocal()
        
        if create_all:
            users = db.query(Utilisateur).all()
            print(f"   {len(users)} utilisateurs à créer")
        else:
            # Créer seulement l'admin
            admin = db.query(Utilisateur).filter(
                Utilisateur.email == "admin@mairie-libreville.ga"
            ).first()
            users = [admin] if admin else []
            print(f"   Création de l'utilisateur admin uniquement")
        
        db.close()
        
        if not users:
            print("❌ Aucun utilisateur à créer")
            return False
        
        # Créer les utilisateurs dans Render
        print(f"\n👤 Création des utilisateurs dans Render...")
        created = 0
        skipped = 0
        
        for user in users:
            try:
                # Vérifier si l'utilisateur existe déjà
                cursor.execute(
                    "SELECT id FROM utilisateur WHERE email = %s",
                    (user.email,)
                )
                existing = cursor.fetchone()
                
                if existing:
                    print(f"   ℹ️ {user.email} existe déjà (ID: {existing[0]})")
                    skipped += 1
                    continue
                
                # Générer le hash du mot de passe
                # Pour l'admin, utiliser "admin123", pour les autres "password123"
                if user.email == "admin@mairie-libreville.ga":
                    password = "admin123"
                else:
                    password = "password123"
                
                password_hash = get_password_hash(password)
                
                # Récupérer le rôle
                role_value = user.role.value if hasattr(user.role, 'value') else str(user.role)
                
                # Insérer l'utilisateur
                cursor.execute("""
                    INSERT INTO utilisateur (
                        nom, prenom, email, telephone, 
                        mot_de_passe_hash, role, actif
                    ) VALUES (%s, %s, %s, %s, %s, %s, %s)
                    RETURNING id
                """, (
                    user.nom,
                    user.prenom,
                    user.email,
                    user.telephone,
                    password_hash,
                    role_value,
                    user.actif
                ))
                
                new_id = cursor.fetchone()[0]
                conn.commit()
                
                created += 1
                print(f"   ✅ {user.email} créé (ID: {new_id}, Password: {password})")
                
            except Exception as e:
                print(f"   ❌ Erreur pour {user.email}: {e}")
                conn.rollback()
                continue
        
        cursor.close()
        conn.close()
        
        print(f"\n✅ Terminé: {created} créés, {skipped} déjà existants")
        
        if created > 0:
            print(f"\n💡 Vous pouvez maintenant vous connecter avec:")
            if create_all:
                print(f"   - admin@mairie-libreville.ga / admin123")
                print(f"   - user5@mairie-libreville.ga / password123")
                print(f"   - ou tout autre utilisateur créé")
            else:
                print(f"   - admin@mairie-libreville.ga / admin123")
        
        return True
        
    except psycopg2.OperationalError as e:
        if "timeout" in str(e).lower() or "timed out" in str(e).lower():
            print(f"❌ Timeout de connexion")
            print(f"💡 La base Render est peut-être en veille")
            print(f"💡 Réveillez-la en visitant: https://taxe-municipale.onrender.com/health")
            print(f"💡 Puis réessayez dans 30-60 secondes")
        else:
            print(f"❌ Erreur de connexion: {e}")
        return False
    except Exception as e:
        print(f"❌ Erreur: {e}")
        import traceback
        traceback.print_exc()
        return False


if __name__ == "__main__":
    import argparse
    
    parser = argparse.ArgumentParser(description="Créer les utilisateurs dans Render")
    parser.add_argument(
        "--render-db-url",
        type=str,
        required=True,
        help="External Database URL de Render"
    )
    parser.add_argument(
        "--all",
        action="store_true",
        help="Créer tous les utilisateurs (sinon seulement l'admin)"
    )
    
    args = parser.parse_args()
    
    success = create_users_in_render(args.render_db_url, create_all=args.all)
    
    if not success:
        print("\n💡 Alternative: Utilisez le script SQL généré")
        print("   python generate_admin_sql.py")
        sys.exit(1)

