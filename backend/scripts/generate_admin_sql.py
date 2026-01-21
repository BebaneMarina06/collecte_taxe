"""
Génère la requête SQL pour créer l'admin dans Render avec le bon hash de mot de passe
"""

from auth.security import get_password_hash

password = "admin123"
hashed = get_password_hash(password)

print("=" * 60)
print("  Requête SQL pour créer l'admin dans Render")
print("=" * 60)
print()
print("Exécutez cette requête dans Render (via DBeaver ou autre) :")
print()
print("```sql")
print(f"INSERT INTO utilisateur (nom, prenom, email, telephone, mot_de_passe_hash, role, actif)")
print(f"VALUES (")
print(f"    'Admin',")
print(f"    'Système',")
print(f"    'admin@mairie-libreville.ga',")
print(f"    '+241062345678',")
print(f"    '{hashed}',")
print(f"    'admin',")
print(f"    true")
print(f") ON CONFLICT (email) DO NOTHING;")
print("```")
print()
print(f"Hash généré pour le mot de passe 'admin123':")
print(f"{hashed}")

