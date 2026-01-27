"""
Script simple pour créer un collecteur de test complet
Usage: python create_test_collecteur.py
"""

from modify_database import connect, create_complete_collecteur

if __name__ == "__main__":
    print("="*60)
    print("Création d'un collecteur de test")
    print("="*60)
    
    # Connexion
    conn = connect()
    if not conn:
        exit(1)
    
    try:
        # Créer un collecteur de test
        user_id, collecteur_id = create_complete_collecteur(
            conn=conn,
            email="test.collecteur@mairie-libreville.ga",
            password="test123",  # Mot de passe simple pour les tests
            nom="Test",
            prenom="Collecteur",
            telephone="+24101234567",
            matricule="TEST-001",
            zone_id=None
        )
        
        if user_id and collecteur_id:
            print("\n" + "="*60)
            print("✅ Collecteur de test créé avec succès !")
            print("="*60)
            print(f"\n📧 Email: test.collecteur@mairie-libreville.ga")
            print(f"🔑 Mot de passe: test123")
            print(f"👤 User ID: {user_id}")
            print(f"📋 Collecteur ID: {collecteur_id}")
            print("\n💡 Vous pouvez maintenant vous connecter dans l'application mobile")
            print("   avec ces identifiants.")
        else:
            print("\n❌ Échec de la création du collecteur")
            
    finally:
        conn.close()
        print("\n✅ Connexion fermée")

