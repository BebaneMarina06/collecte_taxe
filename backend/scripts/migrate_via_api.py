"""
Migration des données via l'API REST (contourne les problèmes de connexion directe)
Cette méthode utilise l'API pour créer les données au lieu d'une connexion SQL directe
"""

import os
import sys
from pathlib import Path
import json
import requests
from typing import List, Dict, Any
from datetime import datetime

# Ajouter le répertoire parent au path
sys.path.insert(0, str(Path(__file__).parent.parent))

from database.database import SessionLocal, DATABASE_URL
from database.models import (
    Service, TypeTaxe, Zone, Quartier, TypeContribuable,
    Collecteur, Contribuable, Taxe, AffectationTaxe,
    InfoCollecte, Utilisateur
)


def get_local_data():
    """
    Récupère toutes les données de la base locale
    """
    print("📤 Récupération des données de la base locale...")
    
    db = SessionLocal()
    data = {}
    
    try:
        # Services
        services = db.query(Service).all()
        data['services'] = [{
            'nom': s.nom,
            'code': s.code,
            'description': s.description,
            'actif': s.actif
        } for s in services]
        print(f"   ✅ Services: {len(data['services'])}")
        
        # Types de taxes
        types_taxes = db.query(TypeTaxe).all()
        data['types_taxes'] = [{
            'nom': t.nom,
            'code': t.code,
            'description': t.description,
            'actif': t.actif
        } for t in types_taxes]
        print(f"   ✅ Types de taxes: {len(data['types_taxes'])}")
        
        # Zones
        zones = db.query(Zone).all()
        data['zones'] = [{
            'nom': z.nom,
            'code': z.code,
            'description': z.description,
            'actif': z.actif
        } for z in zones]
        print(f"   ✅ Zones: {len(data['zones'])}")
        
        # Quartiers
        quartiers = db.query(Quartier).all()
        data['quartiers'] = [{
            'nom': q.nom,
            'code': q.code,
            'zone_id': q.zone_id,
            'description': q.description,
            'actif': q.actif,
            'latitude': float(q.latitude) if q.latitude else None,
            'longitude': float(q.longitude) if q.longitude else None
        } for q in quartiers]
        print(f"   ✅ Quartiers: {len(data['quartiers'])}")
        
        # Types de contribuables
        types_contribuables = db.query(TypeContribuable).all()
        data['types_contribuables'] = [{
            'nom': t.nom,
            'code': t.code,
            'description': t.description,
            'actif': t.actif
        } for t in types_contribuables]
        print(f"   ✅ Types de contribuables: {len(data['types_contribuables'])}")
        
        # Collecteurs
        collecteurs = db.query(Collecteur).all()
        data['collecteurs'] = [{
            'nom': c.nom,
            'prenom': c.prenom,
            'email': c.email,
            'telephone': c.telephone,
            'matricule': c.matricule,
            'zone_id': c.zone_id,
            'latitude': float(c.latitude) if c.latitude else None,
            'longitude': float(c.longitude) if c.longitude else None,
            'heure_cloture': c.heure_cloture,
            'actif': c.actif
        } for c in collecteurs]
        print(f"   ✅ Collecteurs: {len(data['collecteurs'])}")
        
        # Contribuables
        contribuables = db.query(Contribuable).all()
        data['contribuables'] = [{
            'nom': c.nom,
            'prenom': c.prenom,
            'email': c.email,
            'telephone': c.telephone,
            'type_contribuable_id': c.type_contribuable_id,
            'quartier_id': c.quartier_id,
            'collecteur_id': c.collecteur_id,
            'adresse': c.adresse,
            'latitude': float(c.latitude) if c.latitude else None,
            'longitude': float(c.longitude) if c.longitude else None,
            'nom_activite': c.nom_activite,
            'numero_identification': c.numero_identification,
            'actif': c.actif
        } for c in contribuables]
        print(f"   ✅ Contribuables: {len(data['contribuables'])}")
        
        # Taxes
        taxes = db.query(Taxe).all()
        data['taxes'] = [{
            'nom': t.nom,
            'code': t.code,
            'service_id': t.service_id,
            'type_taxe_id': t.type_taxe_id,
            'montant': float(t.montant) if t.montant else None,
            'periodicite': t.periodicite.value if t.periodicite else None,
            'commission_pourcentage': float(t.commission_pourcentage) if t.commission_pourcentage else None,
            'actif': t.actif
        } for t in taxes]
        print(f"   ✅ Taxes: {len(data['taxes'])}")
        
        print(f"\n✅ Total: {sum(len(v) for v in data.values())} enregistrements")
        return data
        
    except Exception as e:
        print(f"❌ Erreur lors de la récupération: {e}")
        return None
    finally:
        db.close()


def login_to_api(api_url: str, email: str, password: str) -> str:
    """
    Se connecte à l'API et retourne le token
    """
    print(f"\n🔐 Connexion à l'API: {api_url}")
    
    try:
        response = requests.post(
            f"{api_url}/api/auth/login",
            data={
                "username": email,
                "password": password
            },
            headers={"Content-Type": "application/x-www-form-urlencoded"},
            timeout=30
        )
        
        if response.status_code == 200:
            token = response.json()["access_token"]
            print("✅ Connexion réussie!")
            return token
        else:
            print(f"❌ Erreur de connexion: {response.status_code}")
            print(f"   {response.text}")
            return None
    except Exception as e:
        print(f"❌ Erreur: {e}")
        return None


def migrate_via_api(api_url: str, token: str, data: Dict[str, List]):
    """
    Migre les données via l'API REST
    """
    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json"
    }
    
    print(f"\n📥 Migration via l'API...")
    
    # Mapping des zones (ancien ID -> nouveau ID)
    zone_mapping = {}
    
    # 1. Migrer les zones
    if 'zones' in data and data['zones']:
        print(f"\n📍 Migration des zones ({len(data['zones'])} zones)...")
        for zone in data['zones']:
            try:
                response = requests.post(
                    f"{api_url}/api/references/zones",
                    json=zone,
                    headers=headers,
                    timeout=30
                )
                if response.status_code in [200, 201]:
                    new_zone = response.json()
                    zone_mapping[zone.get('id', zone['code'])] = new_zone['id']
                    print(f"   ✅ Zone '{zone['nom']}' créée (ID: {new_zone['id']})")
                elif response.status_code == 400 and 'existe déjà' in response.text:
                    # La zone existe déjà, récupérer son ID
                    get_response = requests.get(
                        f"{api_url}/api/references/zones?code={zone['code']}",
                        headers=headers,
                        timeout=30
                    )
                    if get_response.status_code == 200:
                        zones = get_response.json()
                        if zones:
                            zone_mapping[zone.get('id', zone['code'])] = zones[0]['id']
                            print(f"   ℹ️ Zone '{zone['nom']}' existe déjà (ID: {zones[0]['id']})")
                else:
                    print(f"   ⚠️ Erreur pour zone '{zone['nom']}': {response.status_code}")
            except Exception as e:
                print(f"   ❌ Erreur: {e}")
    
    # 2. Migrer les collecteurs
    if 'collecteurs' in data and data['collecteurs']:
        print(f"\n👤 Migration des collecteurs ({len(data['collecteurs'])} collecteurs)...")
        collecteur_mapping = {}
        
        for collecteur in data['collecteurs']:
            try:
                # Mapper zone_id si nécessaire
                if collecteur.get('zone_id') and collecteur['zone_id'] in zone_mapping:
                    collecteur['zone_id'] = zone_mapping[collecteur['zone_id']]
                elif collecteur.get('zone_id'):
                    collecteur['zone_id'] = None  # Zone non trouvée
                
                response = requests.post(
                    f"{api_url}/api/collecteurs",
                    json=collecteur,
                    headers=headers,
                    timeout=30
                )
                
                if response.status_code in [200, 201]:
                    new_collecteur = response.json()
                    collecteur_mapping[collecteur.get('id', collecteur['matricule'])] = new_collecteur['id']
                    print(f"   ✅ Collecteur '{collecteur['nom']} {collecteur['prenom']}' créé (ID: {new_collecteur['id']})")
                elif response.status_code == 400 and 'existe déjà' in response.text:
                    # Le collecteur existe déjà
                    get_response = requests.get(
                        f"{api_url}/api/collecteurs?email={collecteur['email']}",
                        headers=headers,
                        timeout=30
                    )
                    if get_response.status_code == 200:
                        collecteurs = get_response.json()
                        if collecteurs:
                            collecteur_mapping[collecteur.get('id', collecteur['matricule'])] = collecteurs[0]['id']
                            print(f"   ℹ️ Collecteur '{collecteur['nom']} {collecteur['prenom']}' existe déjà")
                else:
                    print(f"   ⚠️ Erreur pour collecteur '{collecteur['nom']}': {response.status_code} - {response.text[:100]}")
            except Exception as e:
                print(f"   ❌ Erreur: {e}")
    
    print(f"\n✅ Migration terminée!")
    print(f"💡 Note: Cette méthode migre les données principales.")
    print(f"   Pour les données complexes (collectes, affectations, etc.),")
    print(f"   utilisez le fichier dump SQL avec une connexion directe.")


if __name__ == "__main__":
    import argparse
    
    parser = argparse.ArgumentParser(description="Migrer les données via l'API REST")
    parser.add_argument(
        "--api-url",
        type=str,
        required=True,
        help="URL de l'API Render (ex: https://votre-app.onrender.com)"
    )
    parser.add_argument(
        "--email",
        type=str,
        required=True,
        help="Email de l'administrateur"
    )
    parser.add_argument(
        "--password",
        type=str,
        required=True,
        help="Mot de passe de l'administrateur"
    )
    
    args = parser.parse_args()
    
    print("=" * 60)
    print("  Migration des données via l'API REST")
    print("=" * 60)
    print()
    
    # Étape 1: Récupérer les données locales
    data = get_local_data()
    
    if not data:
        print("❌ Impossible de récupérer les données locales")
        sys.exit(1)
    
    # Étape 2: Se connecter à l'API
    token = login_to_api(args.api_url, args.email, args.password)
    
    if not token:
        print("❌ Impossible de se connecter à l'API")
        sys.exit(1)
    
    # Étape 3: Migrer les données
    migrate_via_api(args.api_url, token, data)
    
    print("\n✅ Migration terminée!")

