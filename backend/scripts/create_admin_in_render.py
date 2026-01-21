"""
Script pour créer un utilisateur admin dans Render si il n'existe pas
"""

import requests
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent.parent))

from database.database import SessionLocal
from database.models import Utilisateur
from auth.security import get_password_hash


def get_local_admin():
    """Récupère l'admin de la base locale"""
    db = SessionLocal()
    try:
        admin = db.query(Utilisateur).filter(
            Utilisateur.email == "admin@mairie-libreville.ga"
        ).first()
        return admin
    finally:
        db.close()


def create_admin_via_api(api_url: str, temp_token: str = None):
    """
    Crée l'utilisateur admin dans Render
    Si temp_token est fourni, l'utilise. Sinon, essaie de se connecter avec un autre compte.
    """
    print("👤 Création de l'utilisateur admin dans Render...")
    
    # D'abord, essayer de se connecter avec un compte existant
    if not temp_token:
        print("   Tentative de connexion avec un compte existant...")
        # Essayer avec user5 qui est admin
        try:
            response = requests.post(
                f"{api_url}/api/auth/login",
                data={
                    "username": "user5@mairie-libreville.ga",
                    "password": "password123"
                },
                headers={"Content-Type": "application/x-www-form-urlencoded"},
                timeout=60
            )
            if response.status_code == 200:
                temp_token = response.json()["access_token"]
                print("   ✅ Connexion réussie avec user5")
            else:
                print("   ⚠️ Impossible de se connecter avec user5")
        except:
            pass
    
    if not temp_token:
        print("   ❌ Impossible d'obtenir un token. Création manuelle nécessaire.")
        print("\n💡 Solutions:")
        print("   1. Créez l'admin manuellement via Swagger:")
        print(f"      {api_url}/docs")
        print("   2. Ou connectez-vous avec un autre compte admin existant")
        return False
    
    headers = {
        "Authorization": f"Bearer {temp_token}",
        "Content-Type": "application/json"
    }
    
    # Récupérer l'admin local
    local_admin = get_local_admin()
    if not local_admin:
        print("   ❌ Admin local non trouvé")
        return False
    
    # Créer l'admin dans Render
    admin_data = {
        "nom": local_admin.nom,
        "prenom": local_admin.prenom,
        "email": local_admin.email,
        "telephone": local_admin.telephone,
        "role": "admin",
        "actif": True,
        "mot_de_passe": "admin123"  # Le mot de passe sera hashé par l'API
    }
    
    try:
        response = requests.post(
            f"{api_url}/api/utilisateurs",
            json=admin_data,
            headers=headers,
            timeout=30
        )
        
        if response.status_code in [200, 201]:
            print("   ✅ Utilisateur admin créé avec succès!")
            print(f"      Email: {local_admin.email}")
            print(f"      Password: admin123")
            return True
        elif response.status_code == 400:
            error_msg = response.text
            if "existe déjà" in error_msg or "already exists" in error_msg.lower():
                print("   ℹ️ L'utilisateur admin existe déjà dans Render")
                print("   💡 Le mot de passe peut être différent")
                print("   💡 Essayez de réinitialiser le mot de passe via l'interface")
                return True
            else:
                print(f"   ❌ Erreur: {error_msg}")
                return False
        else:
            print(f"   ❌ Erreur {response.status_code}: {response.text}")
            return False
    except Exception as e:
        print(f"   ❌ Erreur: {e}")
        return False


def test_login(api_url: str, email: str, password: str):
    """Teste la connexion"""
    print(f"\n🔐 Test de connexion avec {email}...")
    
    try:
        response = requests.post(
            f"{api_url}/api/auth/login",
            data={
                "username": email.strip(),  # Enlever les espaces
                "password": password
            },
            headers={"Content-Type": "application/x-www-form-urlencoded"},
            timeout=60
        )
        
        if response.status_code == 200:
            print("   ✅ Connexion réussie!")
            return True
        else:
            print(f"   ❌ Erreur {response.status_code}: {response.text}")
            return False
    except Exception as e:
        print(f"   ❌ Erreur: {e}")
        return False


if __name__ == "__main__":
    import argparse
    
    parser = argparse.ArgumentParser(description="Créer l'admin dans Render")
    parser.add_argument("--api-url", type=str, required=True, help="URL de l'API")
    parser.add_argument("--test-login", action="store_true", help="Tester la connexion")
    parser.add_argument("--email", type=str, help="Email pour test")
    parser.add_argument("--password", type=str, help="Password pour test")
    
    args = parser.parse_args()
    
    print("=" * 60)
    print("  Création de l'utilisateur admin dans Render")
    print("=" * 60)
    print()
    
    if args.test_login:
        if not args.email or not args.password:
            print("❌ --email et --password requis pour --test-login")
            sys.exit(1)
        test_login(args.api_url, args.email, args.password)
    else:
        # Essayer de créer l'admin
        success = create_admin_via_api(args.api_url)
        
        if success:
            print("\n✅ Vous pouvez maintenant vous connecter avec:")
            print("   Email: admin@mairie-libreville.ga")
            print("   Password: admin123")
        else:
            print("\n💡 Créez l'admin manuellement via Swagger:")
            print(f"   {args.api_url}/docs")

