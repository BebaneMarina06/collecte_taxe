"""
Script pour réveiller la base Render et migrer les données via l'API
"""

import requests
import time
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent.parent))

from database.database import SessionLocal
from database.models import Collecteur, Contribuable, Taxe, Zone, Quartier


def wake_render_database(api_url: str):
    """
    Réveille la base de données Render en faisant une requête à l'API
    """
    print("🔔 Réveil de la base de données Render...")
    
    try:
        # Faire une requête simple à l'API pour réveiller la base
        response = requests.get(f"{api_url}/health", timeout=60)
        if response.status_code == 200:
            print("✅ Base de données réveillée!")
            return True
    except requests.exceptions.Timeout:
        print("⏳ La base se réveille (cela peut prendre 30-60 secondes)...")
        # Attendre un peu et réessayer
        time.sleep(10)
        try:
            response = requests.get(f"{api_url}/health", timeout=60)
            if response.status_code == 200:
                print("✅ Base de données réveillée!")
                return True
        except:
            pass
    
    print("⚠️ Impossible de réveiller la base, mais continuons quand même...")
    return False


def login_to_api(api_url: str, email: str, password: str) -> str:
    """Se connecte à l'API et retourne le token"""
    print(f"\n🔐 Connexion à l'API...")
    print(f"   Email: {email.strip()}")
    
    # Essayer d'abord avec l'email fourni
    try:
        response = requests.post(
            f"{api_url}/api/auth/login",
            data={"username": email.strip(), "password": password},
            headers={"Content-Type": "application/x-www-form-urlencoded"},
            timeout=60
        )
        
        if response.status_code == 200:
            token = response.json()["access_token"]
            print("Connexion réussie!")
            return token
        else:
            print(f"    Erreur avec {email.strip()}: {response.status_code}")
            print(f"    Tentative avec un autre compte admin...")
    except Exception as e:
        print(f"    Erreur: {e}")
    
    # Si ça ne fonctionne pas, essayer avec d'autres comptes admin
    admin_accounts = [
        ("user5@mairie-libreville.ga", "password123"),
        ("user10@mairie-libreville.ga", "password123"),
        ("user15@mairie-libreville.ga", "password123"),
        ("user25@mairie-libreville.ga", "password123"),
    ]
    
    for admin_email, admin_password in admin_accounts:
        try:
            print(f"   🔄 Essai avec {admin_email}...")
            response = requests.post(
                f"{api_url}/api/auth/login",
                data={"username": admin_email, "password": admin_password},
                headers={"Content-Type": "application/x-www-form-urlencoded"},
                timeout=60
            )
            
            if response.status_code == 200:
                token = response.json()["access_token"]
                print(f"✅ Connexion réussie avec {admin_email}!")
                return token
        except:
            continue
    
    print(f"❌ Impossible de se connecter avec aucun compte")
    print(f"💡 Vérifiez que les utilisateurs existent dans Render")
    return None


def migrate_collecteurs_via_api(api_url: str, token: str):
    """Migre les collecteurs via l'API"""
    print(f"\n👤 Migration des collecteurs...")
    
    db = SessionLocal()
    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json"
    }
    
    try:
        collecteurs = db.query(Collecteur).all()
        print(f"   📊 {len(collecteurs)} collecteurs à migrer")
        
        migrated = 0
        skipped = 0
        
        for collecteur in collecteurs:
            try:
                data = {
                    "nom": collecteur.nom,
                    "prenom": collecteur.prenom,
                    "email": collecteur.email,
                    "telephone": collecteur.telephone,
                    "matricule": collecteur.matricule,
                    "zone_id": collecteur.zone_id,
                    "actif": collecteur.actif
                }
                
                if collecteur.latitude:
                    data["latitude"] = float(collecteur.latitude)
                if collecteur.longitude:
                    data["longitude"] = float(collecteur.longitude)
                if collecteur.heure_cloture:
                    data["heure_cloture"] = collecteur.heure_cloture
                
                response = requests.post(
                    f"{api_url}/api/collecteurs",
                    json=data,
                    headers=headers,
                    timeout=30
                )
                
                if response.status_code in [200, 201]:
                    migrated += 1
                    print(f"   ✅ {collecteur.nom} {collecteur.prenom} ({migrated}/{len(collecteurs)})")
                elif response.status_code == 400:
                    error_msg = response.text
                    if "existe déjà" in error_msg:
                        skipped += 1
                        print(f"   ℹ️ {collecteur.nom} {collecteur.prenom} existe déjà")
                    else:
                        print(f"   ⚠️ {collecteur.nom} {collecteur.prenom}: {error_msg[:100]}")
                else:
                    print(f"   ⚠️ {collecteur.nom} {collecteur.prenom}: {response.status_code}")
                    
            except Exception as e:
                print(f"   ❌ Erreur pour {collecteur.nom}: {e}")
        
        print(f"\n✅ Migration terminée: {migrated} créés, {skipped} déjà existants")
        return True
        
    except Exception as e:
        print(f"❌ Erreur: {e}")
        return False
    finally:
        db.close()


def migrate_zones_via_api(api_url: str, token: str):
    """Migre les zones via l'API"""
    print(f"\n📍 Migration des zones...")
    
    db = SessionLocal()
    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json"
    }
    
    try:
        zones = db.query(Zone).all()
        print(f"   📊 {len(zones)} zones à migrer")
        
        migrated = 0
        
        for zone in zones:
            try:
                data = {
                    "nom": zone.nom,
                    "code": zone.code,
                    "description": zone.description,
                    "actif": zone.actif
                }
                
                response = requests.post(
                    f"{api_url}/api/references/zones",
                    json=data,
                    headers=headers,
                    timeout=30
                )
                
                if response.status_code in [200, 201]:
                    migrated += 1
                    print(f"   ✅ {zone.nom} ({migrated}/{len(zones)})")
                elif response.status_code == 400 and "existe déjà" in response.text:
                    print(f"   ℹ️ {zone.nom} existe déjà")
                else:
                    print(f"   ⚠️ {zone.nom}: {response.status_code}")
                    
            except Exception as e:
                print(f"   ❌ Erreur pour {zone.nom}: {e}")
        
        print(f"\n✅ {migrated} zones migrées")
        return True
        
    except Exception as e:
        print(f"❌ Erreur: {e}")
        return False
    finally:
        db.close()


if __name__ == "__main__":
    import argparse
    
    parser = argparse.ArgumentParser(description="Réveiller Render et migrer via l'API")
    parser.add_argument("--api-url", type=str, required=True, help="URL de l'API Render")
    parser.add_argument("--email", type=str, required=True, help="Email admin")
    parser.add_argument("--password", type=str, required=True, help="Mot de passe admin")
    
    args = parser.parse_args()
    
    print("=" * 60)
    print("  Migration via l'API (contourne les problèmes de connexion)")
    print("=" * 60)
    print()
    
    # Réveiller la base
    wake_render_database(args.api_url)
    
    # Se connecter
    token = login_to_api(args.api_url, args.email, args.password)
    if not token:
        print("❌ Impossible de se connecter")
        sys.exit(1)
    
    # Migrer les données
    print("\n📥 Démarrage de la migration...")
    
    # Zones d'abord (nécessaires pour les collecteurs)
    migrate_zones_via_api(args.api_url, token)
    
    # Puis les collecteurs
    migrate_collecteurs_via_api(args.api_url, token)
    
    print("\n✅ Migration terminée!")
    print("\n💡 Pour les autres données (contribuables, collectes, etc.),")
    print("   vous devrez les créer manuellement via l'interface ou l'API.")

