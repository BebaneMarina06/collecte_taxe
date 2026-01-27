"""
Script pour modifier les données de la base de données PostgreSQL sur Render
Installation: pip install psycopg2-binary bcrypt
"""

import psycopg2
from psycopg2.extras import RealDictCursor
import bcrypt

# URL de connexion à la base de données
DATABASE_URL = "postgresql://taxe_municipale_user:q72VWjL8sldJTl8MGOodumckupqKg7qj@dpg-d4hac1qli9vc73e32ru0-a.singapore-postgres.render.com/taxe_municipale"

def connect():
    """Établit une connexion à la base de données"""
    try:
        conn = psycopg2.connect(DATABASE_URL)
        print("✅ Connexion réussie à la base de données")
        return conn
    except Exception as e:
        print(f"❌ Erreur de connexion: {e}")
        return None

def list_tables(conn):
    """Liste toutes les tables de la base de données"""
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute("""
        SELECT table_name 
        FROM information_schema.tables 
        WHERE table_schema = 'public'
        ORDER BY table_name;
    """)
    tables = cur.fetchall()
    print("\n📋 Tables disponibles:")
    for table in tables:
        print(f"  - {table['table_name']}")
    cur.close()

def list_users(conn):
    """Liste tous les utilisateurs"""
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute("SELECT * FROM utilisateur ORDER BY id;")
    users = cur.fetchall()
    print("\n👥 Utilisateurs:")
    for user in users:
        print(f"  ID: {user['id']}, Email: {user['email']}, Nom: {user['nom']}, Prénom: {user['prenom']}, Rôle: {user['role']}, Actif: {user['actif']}")
    cur.close()

def list_collecteurs(conn):
    """Liste tous les collecteurs"""
    cur = conn.cursor(cursor_factory=RealDictCursor)
    cur.execute("SELECT * FROM collecteur ORDER BY id;")
    collecteurs = cur.fetchall()
    print("\n👤 Collecteurs:")
    for col in collecteurs:
        print(f"  ID: {col['id']}, Nom: {col['nom']}, Prénom: {col['prenom']}, Email: {col['email']}, Matricule: {col['matricule']}")
    cur.close()

def hash_password(password):
    """Hash un mot de passe avec bcrypt"""
    return bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt()).decode('utf-8')

def create_complete_collecteur(conn, email, password, nom, prenom, telephone, matricule, zone_id=None):
    """
    Crée un utilisateur ET un collecteur, et les lie ensemble
    """
    cur = conn.cursor()
    try:
        # 1. Hasher le mot de passe
        password_hash = hash_password(password)
        print(f"🔐 Mot de passe hashé créé")
        
        # 2. Créer l'utilisateur dans la table utilisateur
        cur.execute("""
            INSERT INTO utilisateur (email, mot_de_passe_hash, nom, prenom, telephone, role, actif)
            VALUES (%s, %s, %s, %s, %s, 'collecteur', true)
            RETURNING id;
        """, (email, password_hash, nom, prenom, telephone))
        user_id = cur.fetchone()[0]
        print(f"✅ Utilisateur créé avec l'ID: {user_id}")
        
        # 3. Créer le collecteur dans la table collecteur
        # Note: La table s'appelle 'collecteur' (singulier) selon votre schéma
        cur.execute("""
            INSERT INTO collecteur (nom, prenom, email, telephone, matricule, statut, etat, zone_id, actif)
            VALUES (%s, %s, %s, %s, %s, 'active', 'deconnecte', %s, true)
            RETURNING id;
        """, (nom, prenom, email, telephone, matricule, zone_id))
        collecteur_id = cur.fetchone()[0]
        print(f"✅ Collecteur créé avec l'ID: {collecteur_id}")
        
        # 4. Lier l'utilisateur au collecteur
        # Vérifier si la table collecteur a un champ user_id ou utilisateur_id
        # Si oui, on met à jour, sinon on suppose que c'est via l'email
        try:
            # Essayer d'ajouter le champ user_id si il n'existe pas
            cur.execute("""
                DO $$ 
                BEGIN
                    IF NOT EXISTS (
                        SELECT 1 FROM information_schema.columns 
                        WHERE table_name='collecteur' AND column_name='user_id'
                    ) THEN
                        ALTER TABLE collecteur ADD COLUMN user_id INTEGER;
                    END IF;
                END $$;
            """)
            
            # Mettre à jour avec user_id
            cur.execute("""
                UPDATE collecteur 
                SET user_id = %s 
                WHERE id = %s;
            """, (user_id, collecteur_id))
            print(f"✅ Lien créé: user_id={user_id} -> collecteur_id={collecteur_id}")
        except Exception as e:
            print(f"⚠️  Note: Impossible de créer le lien user_id: {e}")
            print(f"   Le lien se fait via l'email: {email} (les deux tables partagent le même email)")
        
        conn.commit()
        print(f"\n✅ Collecteur complet créé avec succès!")
        print(f"   Email: {email}")
        print(f"   Mot de passe: {password}")
        print(f"   User ID: {user_id}")
        print(f"   Collecteur ID: {collecteur_id}")
        
        return user_id, collecteur_id
        
    except Exception as e:
        conn.rollback()
        print(f"❌ Erreur lors de la création: {e}")
        import traceback
        traceback.print_exc()
        return None, None
    finally:
        cur.close()

def create_test_collecteur_user(conn, email, password, nom, prenom, telephone=None):
    """Crée un utilisateur collecteur de test"""
    cur = conn.cursor()
    try:
        # Hasher le mot de passe
        password_hash = hash_password(password)
        
        # Créer l'utilisateur
        cur.execute("""
            INSERT INTO utilisateur (email, mot_de_passe_hash, nom, prenom, telephone, role, actif)
            VALUES (%s, %s, %s, %s, %s, 'collecteur', true)
            RETURNING id;
        """, (email, password_hash, nom, prenom, telephone))
        user_id = cur.fetchone()[0]
        conn.commit()
        print(f"✅ Utilisateur créé avec l'ID: {user_id}")
        print(f"   Email: {email}")
        print(f"   Mot de passe: {password}")
        return user_id
    except Exception as e:
        conn.rollback()
        print(f"❌ Erreur lors de la création de l'utilisateur: {e}")
        import traceback
        traceback.print_exc()
        return None
    finally:
        cur.close()

def update_user_email(conn, user_id, new_email):
    """Met à jour l'email d'un utilisateur"""
    cur = conn.cursor()
    try:
        cur.execute("""
            UPDATE utilisateur 
            SET email = %s 
            WHERE id = %s
        """, (new_email, user_id))
        conn.commit()
        print(f"✅ Email mis à jour pour l'utilisateur ID {user_id}")
    except Exception as e:
        conn.rollback()
        print(f"❌ Erreur lors de la mise à jour: {e}")
    finally:
        cur.close()

def link_collecteur_to_user(conn, collecteur_id, user_id):
    """Lie un collecteur à un utilisateur via user_id"""
    cur = conn.cursor()
    try:
        # Ajouter la colonne user_id si elle n'existe pas
        cur.execute("""
            DO $$ 
            BEGIN
                IF NOT EXISTS (
                    SELECT 1 FROM information_schema.columns 
                    WHERE table_name='collecteur' AND column_name='user_id'
                ) THEN
                    ALTER TABLE collecteur ADD COLUMN user_id INTEGER;
                END IF;
            END $$;
        """)
        
        # Mettre à jour le collecteur
        cur.execute("""
            UPDATE collecteur 
            SET user_id = %s 
            WHERE id = %s;
        """, (user_id, collecteur_id))
        conn.commit()
        print(f"✅ Collecteur {collecteur_id} lié à l'utilisateur {user_id}")
        return True
    except Exception as e:
        conn.rollback()
        print(f"❌ Erreur lors de la liaison: {e}")
        import traceback
        traceback.print_exc()
        return False
    finally:
        cur.close()

def get_collecteurs_with_users(conn):
    """Affiche tous les collecteurs avec leurs utilisateurs associés"""
    cur = conn.cursor(cursor_factory=RealDictCursor)
    try:
        # Lier par email (car user_id n'existe peut-être pas encore)
        cur.execute("""
            SELECT c.*, u.id as user_id, u.email as user_email, u.role as user_role, u.actif as user_actif
            FROM collecteur c
            LEFT JOIN utilisateur u ON c.email = u.email
            ORDER BY c.id;
        """)
        results = cur.fetchall()
        print("\n👥 Collecteurs avec leurs utilisateurs:")
        for row in results:
            if row['user_email']:
                print(f"  Collecteur ID {row['id']}: {row['prenom']} {row['nom']} ({row['email']})")
                print(f"    -> Utilisateur: {row['user_email']} (Rôle: {row['user_role']}, Actif: {row['user_actif']})")
            else:
                print(f"  Collecteur ID {row['id']}: {row['prenom']} {row['nom']} ({row['email']}) - ⚠️  Pas d'utilisateur associé")
        return results
    except Exception as e:
        print(f"❌ Erreur: {e}")
        import traceback
        traceback.print_exc()
        return []
    finally:
        cur.close()

def execute_custom_query(conn, query, params=None):
    """Exécute une requête SQL personnalisée"""
    cur = conn.cursor(cursor_factory=RealDictCursor)
    try:
        if params:
            cur.execute(query, params)
        else:
            cur.execute(query)
        
        if query.strip().upper().startswith('SELECT'):
            results = cur.fetchall()
            return results
        else:
            conn.commit()
            print(f"✅ Requête exécutée avec succès")
            return None
    except Exception as e:
        conn.rollback()
        print(f"❌ Erreur lors de l'exécution de la requête: {e}")
        return None
    finally:
        cur.close()

if __name__ == "__main__":
    # Connexion
    conn = connect()
    if not conn:
        exit(1)
    
    try:
        # Exemples d'utilisation
        print("\n" + "="*50)
        
        # Lister les tables
        list_tables(conn)
        
        # Lister les utilisateurs
        list_users(conn)
        
        # Lister les collecteurs
        list_collecteurs(conn)
        
        # ============================================
        # EXEMPLE : Créer un collecteur complet
        # ============================================
        # Décommentez les lignes ci-dessous pour créer un collecteur de test
        # 
        # create_complete_collecteur(
        #     conn=conn,
        #     email="collecteur@test.com",
        #     password="motdepasse123",  # Le mot de passe sera hashé automatiquement
        #     nom="Doe",
        #     prenom="John",
        #     telephone="+24101234567",
        #     matricule="COL001",
        #     zone_id=None  # Optionnel
        # )
        
        # Exemple : Mettre à jour un email
        # update_user_email(conn, 1, "nouveau@email.com")
        
        # Afficher les collecteurs avec leurs utilisateurs
        get_collecteurs_with_users(conn)
        
        # Exemple : Requête personnalisée
        # results = execute_custom_query(conn, "SELECT * FROM utilisateur WHERE role = 'collecteur'")
        # if results:
        #     for row in results:
        #         print(row)
        
        # Exemple : Lier un collecteur existant à un utilisateur existant
        # link_collecteur_to_user(conn, collecteur_id=1, user_id=1)
        
    finally:
        conn.close()
        print("\n✅ Connexion fermée")

