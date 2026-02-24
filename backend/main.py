"""
Application FastAPI principale
Application de Collecte de Taxe Municipale - Mairie de Libreville
"""

from fastapi import FastAPI, Request, Response
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from fastapi.responses import JSONResponse
from database.database import init_db
from routers import (
    taxes,
    taxations,
    contribuables,
    collecteurs,
    collectes,
    references,
    auth,
    utilisateurs,
    zones_geographiques,
    uploads,
    parametrage,
    rapports,
    relances,
    impayes,
    paiements_client,
    cartographie,
    statistiques,
    app_preferences,
    localisation,
    caisses,
    journal,
    qr_code,
    geolocalisation,
    notifications,
    demandes_citoyens,
    cron_taxes,
    citoyen,
    services,
    transactions_bamboopay,
)
from pathlib import Path
import json

# Flag pour tracker l'initialisation de la BD
db_initialized = False

app = FastAPI(
    title="API Collecte Taxe Municipale",
    description="API pour la gestion de la collecte de taxes municipales - Mairie de Libreville",
    version="1.0.0",
    redirect_slashes=False
)

# Middleware pour initialiser la BD à la première requête
@app.middleware("http")
async def init_db_on_first_request(request: Request, call_next):
    """Initialise la BD à la première requête si pas déjà fait"""
    global db_initialized
    
    if not db_initialized:
        try:
            init_db()
            db_initialized = True
            print("✅ Base de données initialisée avec succès")
        except Exception as e:
            print(f"⚠️  Tentative d'initialisation de la BD échouée: {str(e)}")
            db_initialized = True  # Ne pas réessayer à chaque requête
    
    response = await call_next(request)
    return response

# Middleware pour forcer l'encodage UTF-8 dans les réponses
@app.middleware("http")
async def add_utf8_encoding(request: Request, call_next):
    response = await call_next(request)
    # Ajouter le charset UTF-8 dans les headers Content-Type
    if response.headers.get("content-type") and "application/json" in response.headers.get("content-type", ""):
        if "charset" not in response.headers.get("content-type", ""):
            response.headers["content-type"] = response.headers["content-type"].replace(
                "application/json", "application/json; charset=utf-8"
            )
    return response

# Configuration CORS pour permettre les requêtes depuis toutes les applications
import os
cors_origins = ["*"]  # Accepter toutes les origines (collecteur, admin, mobile, etc.)

app.add_middleware(
    CORSMiddleware,
    allow_origins=cors_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Inclusion des routers
app.include_router(auth.router)
app.include_router(utilisateurs.router)
app.include_router(taxes.router)
app.include_router(taxations.router)
app.include_router(contribuables.router)
app.include_router(collecteurs.router)
app.include_router(collectes.router)
app.include_router(references.router)
app.include_router(zones_geographiques.router)
app.include_router(uploads.router)
app.include_router(parametrage.router)
app.include_router(rapports.router)
app.include_router(relances.router)
app.include_router(impayes.router)
app.include_router(paiements_client.router)
app.include_router(cartographie.router)
app.include_router(statistiques.router)
app.include_router(app_preferences.router)
app.include_router(localisation.router)
app.include_router(caisses.router)
app.include_router(journal.router)
app.include_router(qr_code.router)
app.include_router(geolocalisation.router)
app.include_router(notifications.router)
# Inclure le router demandes_citoyens avec les deux préfixes pour compatibilité
app.include_router(demandes_citoyens.router, prefix="/api/demandes")
app.include_router(demandes_citoyens.router, prefix="/api/demandes-citoyens")
app.include_router(cron_taxes.router)
app.include_router(citoyen.router)
app.include_router(services.router)
app.include_router(transactions_bamboopay.router)

# Servir les fichiers statiques (photos uploadées)
uploads_dir = Path(__file__).parent / "uploads"
uploads_dir.mkdir(exist_ok=True)
app.mount("/uploads", StaticFiles(directory=str(uploads_dir)), name="uploads")


@app.on_event("startup")
async def startup_event():
    """Configure le scheduler CRON (la BD sera initialisée à la première requête)"""
    print("🚀 Application en démarrage...")
    
    # Configurer le scheduler pour les tâches CRON
    try:
        from apscheduler.schedulers.background import BackgroundScheduler
        from apscheduler.triggers.cron import CronTrigger
        from services.cron_taxes import generer_dettes_mensuelles
        from database.database import SessionLocal
        
        scheduler = BackgroundScheduler()
        
        # Planifier la génération mensuelle des dettes (le 1er de chaque mois à 00:00)
        def generer_dettes_job():
            """Job CRON pour générer les dettes mensuelles"""
            db = SessionLocal()
            try:
                generer_dettes_mensuelles(db)
            except Exception as e:
                print(f"Erreur lors de l'exécution du CRON de génération des dettes: {str(e)}")
            finally:
                db.close()
        
        scheduler.add_job(
            generer_dettes_job,
            trigger=CronTrigger(day=1, hour=0, minute=0),  # Le 1er de chaque mois à 00:00
            id='generer_dettes_mensuelles',
            name='Génération mensuelle des dettes de taxe',
            replace_existing=True
        )
        
        scheduler.start()
        print("✅ Scheduler CRON configuré pour la génération mensuelle des dettes")

    except ImportError:
        print("⚠️  APScheduler non installé. Les tâches CRON ne seront pas automatiques.")
        print("   Installez avec: pip install apscheduler")
    except Exception as e:
        print(f"⚠️  Erreur lors de la configuration du scheduler: {str(e)}")


@app.get("/")
async def root():
    """Point d'entrée de l'API"""
    return {
        "message": "API Collecte Taxe Municipale - Mairie de Libreville",
        "version": "1.0.0",
        "docs": "/docs"
    }


@app.get("/health")
async def health_check():
    """Vérification de santé de l'API"""
    return {"status": "healthy"}


@app.post("/admin/init-db")
async def init_database():
    """
    Initialiser la base de données manuellement.
    ⚠️ À utiliser en production avec prudence!
    """
    global db_initialized
    
    try:
        init_db()
        
        # Charger les seeders
        try:
            from database.run_seeders import run_all_seeders
            run_all_seeders()
            print("✅ Seeders chargés avec succès")
        except Exception as e:
            print(f"⚠️  Erreur lors du chargement des seeders: {str(e)}")
        
        db_initialized = True
        return {
            "status": "success",
            "message": "Base de données initialisée avec succès"
        }
    except Exception as e:
        return {
            "status": "error",
            "message": f"Erreur lors de l'initialisation: {str(e)}"
        }