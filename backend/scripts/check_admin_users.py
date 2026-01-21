"""
Script pour vérifier les utilisateurs admin dans la base locale
"""

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent.parent))

from database.database import SessionLocal
from database.models import Utilisateur


def check_admin_users():
    """Affiche tous les utilisateurs admin"""
    db = SessionLocal()
    
    try:
        print("=" * 60)
        print("  Utilisateurs Admin dans la base locale")
        print("=" * 60)
        print()
        
        # Récupérer tous les utilisateurs
        users = db.query(Utilisateur).all()
        
        if not users:
            print("❌ Aucun utilisateur trouvé dans la base de données")
            return
        
        print(f"📊 Total: {len(users)} utilisateur(s)\n")
        
        for user in users:
            role_display = user.role if hasattr(user, 'role') else 'N/A'
            actif_display = "✅ Actif" if user.actif else "❌ Inactif"
            
            print(f"👤 {user.nom} {user.prenom}")
            print(f"   Email: {user.email}")
            print(f"   Rôle: {role_display}")
            print(f"   Statut: {actif_display}")
            print(f"   ID: {user.id}")
            print()
        
        # Afficher les admins en particulier
        admin_users = [u for u in users if hasattr(u, 'role') and u.role == 'admin']
        
        if admin_users:
            print("=" * 60)
            print("  👑 Utilisateurs ADMIN")
            print("=" * 60)
            print()
            for admin in admin_users:
                print(f"✅ {admin.email} - {admin.nom} {admin.prenom}")
            print()
            print("💡 Utilisez l'un de ces emails pour vous connecter")
        else:
            print("⚠️ Aucun utilisateur avec le rôle 'admin' trouvé")
            print("💡 Vous pouvez utiliser n'importe quel email d'utilisateur actif")
        
    except Exception as e:
        print(f"❌ Erreur: {e}")
        import traceback
        traceback.print_exc()
    finally:
        db.close()


if __name__ == "__main__":
    check_admin_users()

