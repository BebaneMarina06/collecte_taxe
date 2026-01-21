"""
Service CRON pour générer automatiquement les dettes de taxe mensuelles
"""

from datetime import datetime, timedelta
from decimal import Decimal
from sqlalchemy.orm import Session
from database.models import (
    Contribuable,
    AffectationTaxe,
    Taxe,
    PeriodiciteEnum
)
import logging

logger = logging.getLogger(__name__)


def generer_dettes_mensuelles(db: Session) -> dict:
    """
    Génère automatiquement les dettes de taxe pour chaque contribuable
    selon leur affectation de taxes actives.
    
    Cette fonction doit être appelée mensuellement (via CRON ou scheduler).
    """
    try:
        logger.info("Début de la génération mensuelle des dettes de taxe")
        
        # Récupérer tous les contribuables actifs
        contribuables = db.query(Contribuable).filter(
            Contribuable.actif == True
        ).all()
        
        dettes_creees = 0
        dettes_existantes = 0
        erreurs = 0
        
        for contribuable in contribuables:
            # Récupérer les affectations de taxes actives pour ce contribuable
            affectations = db.query(AffectationTaxe).filter(
                AffectationTaxe.contribuable_id == contribuable.id,
                AffectationTaxe.actif == True,
                AffectationTaxe.date_debut <= datetime.utcnow(),
                (
                    (AffectationTaxe.date_fin.is_(None)) |
                    (AffectationTaxe.date_fin >= datetime.utcnow())
                )
            ).all()
            
            for affectation in affectations:
                # Vérifier si la taxe est mensuelle
                if affectation.taxe.periodicite != PeriodiciteEnum.MENSUELLE:
                    continue  # Ne générer que pour les taxes mensuelles
                
                # Calculer la date de début du mois en cours
                date_debut_mois = datetime.utcnow().replace(day=1, hour=0, minute=0, second=0, microsecond=0)
                
                # Vérifier si une affectation existe déjà pour ce mois
                affectation_existante = db.query(AffectationTaxe).filter(
                    AffectationTaxe.contribuable_id == contribuable.id,
                    AffectationTaxe.taxe_id == affectation.taxe_id,
                    AffectationTaxe.date_debut >= date_debut_mois,
                    AffectationTaxe.date_debut < date_debut_mois + timedelta(days=32)
                ).first()
                
                if affectation_existante:
                    dettes_existantes += 1
                    continue
                
                # Créer une nouvelle affectation pour le mois en cours
                try:
                    nouvelle_affectation = AffectationTaxe(
                        contribuable_id=contribuable.id,
                        taxe_id=affectation.taxe_id,
                        date_debut=date_debut_mois,
                        date_fin=None,  # Pas de date de fin pour les taxes mensuelles récurrentes
                        montant_custom=affectation.montant_custom,  # Conserver le montant personnalisé si existant
                        actif=True
                    )
                    
                    db.add(nouvelle_affectation)
                    dettes_creees += 1
                    
                except Exception as e:
                    logger.error(f"Erreur lors de la création de la dette pour contribuable {contribuable.id}, taxe {affectation.taxe_id}: {str(e)}")
                    erreurs += 1
                    continue
        
        # Commit toutes les nouvelles affectations
        db.commit()
        
        resultat = {
            "date_execution": datetime.utcnow().isoformat(),
            "dettes_creees": dettes_creees,
            "dettes_existantes": dettes_existantes,
            "erreurs": erreurs,
            "total_contribuables": len(contribuables)
        }
        
        logger.info(f"Génération mensuelle terminée: {resultat}")
        
        return resultat
        
    except Exception as e:
        logger.error(f"Erreur lors de la génération mensuelle des dettes: {str(e)}")
        db.rollback()
        raise


def generer_dettes_pour_periodicite(db: Session, periodicite: PeriodiciteEnum) -> dict:
    """
    Génère les dettes pour une périodicité spécifique (mensuelle, hebdomadaire, etc.)
    """
    try:
        logger.info(f"Début de la génération des dettes pour la périodicité: {periodicite.value}")
        
        # Récupérer tous les contribuables actifs
        contribuables = db.query(Contribuable).filter(
            Contribuable.actif == True
        ).all()
        
        dettes_creees = 0
        dettes_existantes = 0
        erreurs = 0
        
        # Calculer la date de début selon la périodicité
        maintenant = datetime.utcnow()
        
        if periodicite == PeriodiciteEnum.MENSUELLE:
            date_debut_periode = maintenant.replace(day=1, hour=0, minute=0, second=0, microsecond=0)
            date_fin_periode = date_debut_periode + timedelta(days=32)
        elif periodicite == PeriodiciteEnum.HEBDOMADAIRE:
            # Début de la semaine (lundi)
            jours_jusqu_lundi = (maintenant.weekday()) % 7
            date_debut_periode = (maintenant - timedelta(days=jours_jusqu_lundi)).replace(hour=0, minute=0, second=0, microsecond=0)
            date_fin_periode = date_debut_periode + timedelta(days=7)
        elif periodicite == PeriodiciteEnum.TRIMESTRIELLE:
            # Début du trimestre
            trimestre = (maintenant.month - 1) // 3
            mois_debut_trimestre = trimestre * 3 + 1
            date_debut_periode = maintenant.replace(month=mois_debut_trimestre, day=1, hour=0, minute=0, second=0, microsecond=0)
            date_fin_periode = date_debut_periode + timedelta(days=93)
        else:  # JOURNALIERE
            date_debut_periode = maintenant.replace(hour=0, minute=0, second=0, microsecond=0)
            date_fin_periode = date_debut_periode + timedelta(days=1)
        
        for contribuable in contribuables:
            # Récupérer les affectations de taxes actives pour ce contribuable avec la périodicité spécifiée
            affectations = db.query(AffectationTaxe).join(Taxe).filter(
                AffectationTaxe.contribuable_id == contribuable.id,
                AffectationTaxe.actif == True,
                Taxe.periodicite == periodicite,
                AffectationTaxe.date_debut <= datetime.utcnow(),
                (
                    (AffectationTaxe.date_fin.is_(None)) |
                    (AffectationTaxe.date_fin >= datetime.utcnow())
                )
            ).all()
            
            for affectation in affectations:
                # Vérifier si une affectation existe déjà pour cette période
                affectation_existante = db.query(AffectationTaxe).filter(
                    AffectationTaxe.contribuable_id == contribuable.id,
                    AffectationTaxe.taxe_id == affectation.taxe_id,
                    AffectationTaxe.date_debut >= date_debut_periode,
                    AffectationTaxe.date_debut < date_fin_periode
                ).first()
                
                if affectation_existante:
                    dettes_existantes += 1
                    continue
                
                # Créer une nouvelle affectation pour la période
                try:
                    nouvelle_affectation = AffectationTaxe(
                        contribuable_id=contribuable.id,
                        taxe_id=affectation.taxe_id,
                        date_debut=date_debut_periode,
                        date_fin=None,
                        montant_custom=affectation.montant_custom,
                        actif=True
                    )
                    
                    db.add(nouvelle_affectation)
                    dettes_creees += 1
                    
                except Exception as e:
                    logger.error(f"Erreur lors de la création de la dette pour contribuable {contribuable.id}, taxe {affectation.taxe_id}: {str(e)}")
                    erreurs += 1
                    continue
        
        # Commit toutes les nouvelles affectations
        db.commit()
        
        resultat = {
            "date_execution": datetime.utcnow().isoformat(),
            "periodicite": periodicite.value,
            "dettes_creees": dettes_creees,
            "dettes_existantes": dettes_existantes,
            "erreurs": erreurs,
            "total_contribuables": len(contribuables)
        }
        
        logger.info(f"Génération des dettes terminée: {resultat}")
        
        return resultat
        
    except Exception as e:
        logger.error(f"Erreur lors de la génération des dettes: {str(e)}")
        db.rollback()
        raise

