"""
Routes pour la gestion des impayés
"""

from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session, joinedload
from sqlalchemy import func, and_, or_, case, text
from typing import List, Optional
from database.database import get_db
from database.models import (
    DossierImpaye, Contribuable, AffectationTaxe, InfoCollecte,
    StatutCollecteEnum, Taxe, Collecteur
)
from schemas.dossier_impaye import (
    DossierImpayeCreate, DossierImpayeUpdate, DossierImpayeResponse,
    DossierImpayeListResponse, CalculPenalitesRequest, CalculPenalitesResponse
)
from datetime import datetime, date, timedelta
from decimal import Decimal

router = APIRouter(prefix="/api/impayes", tags=["impayes"])


def calculer_penalites(montant_initial: Decimal, date_echeance: datetime, taux_journalier: Decimal = Decimal("0.5")) -> tuple[Decimal, int]:
    """Calcule les pénalités de retard"""
    aujourdhui = datetime.utcnow()
    jours_retard = max(0, (aujourdhui - date_echeance).days)
    
    if jours_retard <= 0:
        return Decimal("0"), 0
    
    # Pénalité = montant_initial * (taux_journalier / 100) * jours_retard
    penalites = montant_initial * (taux_journalier / Decimal("100")) * Decimal(str(jours_retard))
    
    return penalites, jours_retard


def calculer_montant_paye(contribuable_id: int, taxe_id: int, date_debut: datetime, db: Session) -> Decimal:
    """Calcule le montant déjà payé pour une affectation"""
    montant_paye = db.query(func.sum(InfoCollecte.montant)).filter(
        InfoCollecte.contribuable_id == contribuable_id,
        InfoCollecte.taxe_id == taxe_id,
        InfoCollecte.statut == StatutCollecteEnum.COMPLETED,
        InfoCollecte.annule == False,
        InfoCollecte.date_collecte >= date_debut
    ).scalar() or Decimal("0")
    
    return montant_paye


@router.post("/calculer-penalites", response_model=CalculPenalitesResponse)
def calculer_penalites_endpoint(request: CalculPenalitesRequest):
    """Calcule les pénalités pour un montant et une date d'échéance"""
    taux = request.taux_penalite_journalier or Decimal("0.5")
    
    if request.jours_retard is not None:
        jours_retard = request.jours_retard
    else:
        jours_retard = max(0, (datetime.utcnow() - request.date_echeance).days)
    
    if jours_retard <= 0:
        penalites = Decimal("0")
    else:
        penalites = request.montant_initial * (taux / Decimal("100")) * Decimal(str(jours_retard))
    
    montant_total = request.montant_initial + penalites
    
    return CalculPenalitesResponse(
        montant_initial=request.montant_initial,
        jours_retard=jours_retard,
        taux_penalite_journalier=taux,
        penalites_calculees=penalites,
        montant_total=montant_total
    )


@router.post("/detecter-impayes", response_model=List[DossierImpayeResponse])
def detecter_impayes(
    jours_retard_min: int = Query(7, ge=0, description="Nombre minimum de jours de retard"),
    taux_penalite: Decimal = Query(Decimal("0.5"), description="Taux de pénalité journalier en %"),
    db: Session = Depends(get_db)
):
    """Détecte automatiquement les impayés et crée les dossiers"""
    date_limite = datetime.utcnow() - timedelta(days=jours_retard_min)
    
    # Trouver les affectations actives avec échéance dépassée
    affectations = db.query(AffectationTaxe).filter(
        AffectationTaxe.actif == True,
        AffectationTaxe.date_debut <= date_limite
    ).all()
    
    dossiers_crees = []
    
    for affectation in affectations:
        # Calculer la date d'échéance selon la périodicité
        date_echeance = affectation.date_debut
        if affectation.taxe.periodicite == "mensuelle":
            date_echeance = affectation.date_debut + timedelta(days=30)
        elif affectation.taxe.periodicite == "hebdomadaire":
            date_echeance = affectation.date_debut + timedelta(days=7)
        elif affectation.taxe.periodicite == "trimestrielle":
            date_echeance = affectation.date_debut + timedelta(days=90)
        
        # Vérifier si l'échéance est dépassée
        if date_echeance < datetime.utcnow():
            # Calculer le montant initial
            montant_initial = affectation.montant_custom if affectation.montant_custom else affectation.taxe.montant
            
            # Calculer le montant payé
            montant_paye = calculer_montant_paye(
                affectation.contribuable_id,
                affectation.taxe_id,
                affectation.date_debut,
                db
            )
            
            # Si pas complètement payé
            if montant_paye < montant_initial:
                montant_restant = montant_initial - montant_paye
                
                # Calculer les pénalités
                penalites, jours_retard = calculer_penalites(montant_restant, date_echeance, taux_penalite)
                
                # Déterminer la priorité
                if jours_retard > 90:
                    priorite = "urgente"
                elif jours_retard > 60:
                    priorite = "elevee"
                elif jours_retard > 30:
                    priorite = "normale"
                else:
                    priorite = "faible"
                
                # Vérifier si un dossier existe déjà
                dossier_existant = db.query(DossierImpaye).filter(
                    DossierImpaye.affectation_taxe_id == affectation.id,
                    DossierImpaye.statut.in_(["en_cours", "partiellement_paye"])
                ).first()
                
                if not dossier_existant:
                    # Créer le dossier
                    nouveau_dossier = DossierImpaye(
                        contribuable_id=affectation.contribuable_id,
                        affectation_taxe_id=affectation.id,
                        montant_initial=montant_initial,
                        montant_paye=montant_paye,
                        montant_restant=montant_restant,
                        penalites=penalites,
                        date_echeance=date_echeance,
                        jours_retard=jours_retard,
                        priorite=priorite,
                        statut="en_cours"
                    )
                    db.add(nouveau_dossier)
                    dossiers_crees.append(nouveau_dossier)
                else:
                    # Mettre à jour le dossier existant
                    dossier_existant.montant_paye = montant_paye
                    dossier_existant.montant_restant = montant_restant
                    dossier_existant.penalites = penalites
                    dossier_existant.jours_retard = jours_retard
                    dossier_existant.priorite = priorite
                    dossier_existant.updated_at = datetime.utcnow()
                    dossiers_crees.append(dossier_existant)
    
    db.commit()
    
    # Recharger avec les relations et convertir en schémas
    dossiers_ids = [d.id for d in dossiers_crees]
    dossiers_chargees = db.query(DossierImpaye).options(
        joinedload(DossierImpaye.contribuable),
        joinedload(DossierImpaye.affectation_taxe).joinedload(AffectationTaxe.taxe),
        joinedload(DossierImpaye.collecteur)
    ).filter(DossierImpaye.id.in_(dossiers_ids)).all()
    
    from schemas.dossier_impaye import DossierImpayeResponse
    return [DossierImpayeResponse.model_validate(dossier, from_attributes=True) for dossier in dossiers_chargees]


@router.get("/", response_model=DossierImpayeListResponse)
@router.get("", response_model=DossierImpayeListResponse)
def get_impayes(
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=1000),
    contribuable_id: Optional[int] = None,
    collecteur_id: Optional[int] = None,
    statut: Optional[str] = None,
    priorite: Optional[str] = None,
    jours_retard_min: Optional[int] = None,
    db: Session = Depends(get_db)
):
    """Récupère la liste des dossiers d'impayés avec filtres"""
    query = db.query(DossierImpaye).options(
        joinedload(DossierImpaye.contribuable),
        joinedload(DossierImpaye.affectation_taxe).joinedload(AffectationTaxe.taxe),
        joinedload(DossierImpaye.collecteur)
    )
    
    if contribuable_id:
        query = query.filter(DossierImpaye.contribuable_id == contribuable_id)
    if collecteur_id:
        query = query.filter(DossierImpaye.assigne_a == collecteur_id)
    if statut:
        query = query.filter(DossierImpaye.statut == statut)
    if priorite:
        query = query.filter(DossierImpaye.priorite == priorite)
    if jours_retard_min:
        query = query.filter(DossierImpaye.jours_retard >= jours_retard_min)
    
    total = query.count()
    dossiers = query.order_by(
        DossierImpaye.priorite.desc(),
        DossierImpaye.jours_retard.desc()
    ).offset(skip).limit(limit).all()
    
    # Convertir les objets SQLAlchemy en schémas Pydantic
    from schemas.dossier_impaye import DossierImpayeResponse
    dossiers_data = [DossierImpayeResponse.model_validate(dossier, from_attributes=True) for dossier in dossiers]
    
    return DossierImpayeListResponse(
        items=dossiers_data,
        total=total,
        skip=skip,
        limit=limit
    )


@router.get("/{dossier_id}", response_model=DossierImpayeResponse)
def get_dossier_impaye(dossier_id: int, db: Session = Depends(get_db)):
    """Récupère un dossier d'impayé par son ID"""
    dossier = db.query(DossierImpaye).options(
        joinedload(DossierImpaye.contribuable),
        joinedload(DossierImpaye.affectation_taxe).joinedload(AffectationTaxe.taxe),
        joinedload(DossierImpaye.collecteur)
    ).filter(DossierImpaye.id == dossier_id).first()
    
    if not dossier:
        raise HTTPException(status_code=404, detail="Dossier d'impayé non trouvé")
    from schemas.dossier_impaye import DossierImpayeResponse
    return DossierImpayeResponse.model_validate(dossier, from_attributes=True)


@router.post("/", response_model=DossierImpayeResponse, status_code=201)
def create_dossier_impaye(dossier: DossierImpayeCreate, db: Session = Depends(get_db)):
    """Crée un nouveau dossier d'impayé"""
    # Vérifier que le contribuable existe
    contribuable = db.query(Contribuable).filter(Contribuable.id == dossier.contribuable_id).first()
    if not contribuable:
        raise HTTPException(status_code=404, detail="Contribuable non trouvé")
    
    # Vérifier l'affectation
    affectation = db.query(AffectationTaxe).filter(AffectationTaxe.id == dossier.affectation_taxe_id).first()
    if not affectation:
        raise HTTPException(status_code=404, detail="Affectation de taxe non trouvée")
    
    # Calculer le montant payé
    montant_paye = calculer_montant_paye(
        dossier.contribuable_id,
        affectation.taxe_id,
        affectation.date_debut,
        db
    )
    
    # Calculer le montant restant
    montant_restant = dossier.montant_initial - montant_paye
    
    # Calculer les pénalités
    penalites, jours_retard = calculer_penalites(dossier.montant_initial, dossier.date_echeance)
    
    # Déterminer la priorité
    if jours_retard > 90:
        priorite = "urgente"
    elif jours_retard > 60:
        priorite = "elevee"
    elif jours_retard > 30:
        priorite = "normale"
    else:
        priorite = "faible"
    
    db_dossier = DossierImpaye(
        **dossier.dict(),
        montant_paye=montant_paye,
        montant_restant=montant_restant,
        penalites=penalites,
        jours_retard=jours_retard,
        priorite=priorite,
        statut="en_cours"
    )
    db.add(db_dossier)
    db.commit()
    # Recharger avec les relations
    db_dossier = db.query(DossierImpaye).options(
        joinedload(DossierImpaye.contribuable),
        joinedload(DossierImpaye.affectation_taxe).joinedload(AffectationTaxe.taxe),
        joinedload(DossierImpaye.collecteur)
    ).filter(DossierImpaye.id == db_dossier.id).first()
    from schemas.dossier_impaye import DossierImpayeResponse
    return DossierImpayeResponse.model_validate(db_dossier, from_attributes=True)


@router.put("/{dossier_id}", response_model=DossierImpayeResponse)
def update_dossier_impaye(dossier_id: int, dossier_update: DossierImpayeUpdate, db: Session = Depends(get_db)):
    """Met à jour un dossier d'impayé"""
    db_dossier = db.query(DossierImpaye).filter(DossierImpaye.id == dossier_id).first()
    if not db_dossier:
        raise HTTPException(status_code=404, detail="Dossier d'impayé non trouvé")
    
    update_data = dossier_update.dict(exclude_unset=True)
    
    # Si le montant payé change, recalculer le montant restant
    if "montant_paye" in update_data:
        montant_paye = update_data["montant_paye"]
        montant_restant = db_dossier.montant_initial - montant_paye
        update_data["montant_restant"] = montant_restant
        
        # Mettre à jour le statut
        if montant_restant <= 0:
            update_data["statut"] = "paye"
            update_data["date_cloture"] = datetime.utcnow()
        elif montant_paye > 0:
            update_data["statut"] = "partiellement_paye"
    
    for field, value in update_data.items():
        setattr(db_dossier, field, value)
    
    db_dossier.updated_at = datetime.utcnow()
    db.commit()
    # Recharger avec les relations
    db_dossier = db.query(DossierImpaye).options(
        joinedload(DossierImpaye.contribuable),
        joinedload(DossierImpaye.affectation_taxe).joinedload(AffectationTaxe.taxe),
        joinedload(DossierImpaye.collecteur)
    ).filter(DossierImpaye.id == dossier_id).first()
    from schemas.dossier_impaye import DossierImpayeResponse
    return DossierImpayeResponse.model_validate(db_dossier, from_attributes=True)


@router.patch("/{dossier_id}/assigner", response_model=DossierImpayeResponse)
def assigner_dossier(
    dossier_id: int,
    collecteur_id: int = Query(..., description="ID du collecteur à assigner"),
    db: Session = Depends(get_db)
):
    """Assigne un dossier d'impayé à un collecteur"""
    db_dossier = db.query(DossierImpaye).filter(DossierImpaye.id == dossier_id).first()
    if not db_dossier:
        raise HTTPException(status_code=404, detail="Dossier d'impayé non trouvé")
    
    collecteur = db.query(Collecteur).filter(Collecteur.id == collecteur_id).first()
    if not collecteur:
        raise HTTPException(status_code=404, detail="Collecteur non trouvé")
    
    db_dossier.assigne_a = collecteur_id
    db_dossier.date_assignation = datetime.utcnow()
    db_dossier.updated_at = datetime.utcnow()
    db.commit()
    # Recharger avec les relations
    db_dossier = db.query(DossierImpaye).options(
        joinedload(DossierImpaye.contribuable),
        joinedload(DossierImpaye.affectation_taxe).joinedload(AffectationTaxe.taxe),
        joinedload(DossierImpaye.collecteur)
    ).filter(DossierImpaye.id == dossier_id).first()
    from schemas.dossier_impaye import DossierImpayeResponse
    return DossierImpayeResponse.model_validate(db_dossier, from_attributes=True)


@router.patch("/{dossier_id}/cloturer", response_model=DossierImpayeResponse)
def cloturer_dossier(
    dossier_id: int,
    db: Session = Depends(get_db)
):
    """Clôture un dossier d'impayé"""
    db_dossier = db.query(DossierImpaye).filter(DossierImpaye.id == dossier_id).first()
    if not db_dossier:
        raise HTTPException(status_code=404, detail="Dossier d'impayé non trouvé")
    
    db_dossier.statut = "archive"
    db_dossier.date_cloture = datetime.utcnow()
    db_dossier.updated_at = datetime.utcnow()
    db.commit()
    # Recharger avec les relations
    db_dossier = db.query(DossierImpaye).options(
        joinedload(DossierImpaye.contribuable),
        joinedload(DossierImpaye.affectation_taxe).joinedload(AffectationTaxe.taxe),
        joinedload(DossierImpaye.collecteur)
    ).filter(DossierImpaye.id == dossier_id).first()
    from schemas.dossier_impaye import DossierImpayeResponse
    return DossierImpayeResponse.model_validate(db_dossier, from_attributes=True)


@router.get("/statistiques/globales", response_model=dict)
def get_statistiques_impayes(
    db: Session = Depends(get_db)
):
    """Récupère les statistiques globales sur les impayés"""
    total_dossiers = db.query(DossierImpaye).filter(
        DossierImpaye.statut.in_(["en_cours", "partiellement_paye"])
    ).count()
    
    total_montant_du = db.query(func.sum(DossierImpaye.montant_restant + DossierImpaye.penalites)).filter(
        DossierImpaye.statut.in_(["en_cours", "partiellement_paye"])
    ).scalar() or Decimal("0")
    
    total_penalites = db.query(func.sum(DossierImpaye.penalites)).filter(
        DossierImpaye.statut.in_(["en_cours", "partiellement_paye"])
    ).scalar() or Decimal("0")
    
    # Par priorité
    par_priorite = {}
    for priorite in ["urgente", "elevee", "normale", "faible"]:
        count = db.query(DossierImpaye).filter(
            DossierImpaye.priorite == priorite,
            DossierImpaye.statut.in_(["en_cours", "partiellement_paye"])
        ).count()
        par_priorite[priorite] = count
    
    # Par statut
    par_statut = {}
    for statut in ["en_cours", "partiellement_paye", "paye", "archive"]:
        count = db.query(DossierImpaye).filter(DossierImpaye.statut == statut).count()
        par_statut[statut] = count
    
    # Moyenne des jours de retard
    moyenne_retard = db.query(func.avg(DossierImpaye.jours_retard)).filter(
        DossierImpaye.statut.in_(["en_cours", "partiellement_paye"])
    ).scalar() or 0
    
    return {
        "total_dossiers_actifs": total_dossiers,
        "total_montant_du": float(total_montant_du),
        "total_penalites": float(total_penalites),
        "moyenne_jours_retard": round(float(moyenne_retard), 1) if moyenne_retard else 0,
        "par_priorite": par_priorite,
        "par_statut": par_statut
    }


# --- Endpoints pour interroger la vue impayes_view ---

@router.get("/vue/liste", response_model=dict)
def get_impayes_depuis_vue(
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=1000),
    statut: Optional[str] = Query(None, description="Filtrer par statut: PAYE, PARTIEL, IMPAYE, RETARD"),
    contribuable_id: Optional[int] = Query(None, description="Filtrer par contribuable"),
    taxe_id: Optional[int] = Query(None, description="Filtrer par taxe"),
    collecteur_id: Optional[int] = Query(None, description="Filtrer par collecteur assigné"),
    zone_nom: Optional[str] = Query(None, description="Filtrer par zone"),
    quartier_nom: Optional[str] = Query(None, description="Filtrer par quartier"),
    db: Session = Depends(get_db)
):
    """
    Récupère les impayés depuis la vue impayes_view (calcul automatique en temps réel).
    Cette vue ne nécessite aucune synchronisation et est toujours à jour.
    """
    # Construire la requête SQL
    query = "SELECT * FROM impayes_view WHERE 1=1"
    params = {}

    if statut:
        query += " AND statut = :statut"
        params["statut"] = statut

    if contribuable_id:
        query += " AND contribuable_id = :contribuable_id"
        params["contribuable_id"] = contribuable_id

    if taxe_id:
        query += " AND taxe_id = :taxe_id"
        params["taxe_id"] = taxe_id

    # Note: Pour filtrer par collecteur, la vue doit avoir le champ collecteur_id
    # Actuellement elle a collecteur_nom et collecteur_prenom

    if zone_nom:
        query += " AND zone_nom = :zone_nom"
        params["zone_nom"] = zone_nom

    if quartier_nom:
        query += " AND quartier_nom = :quartier_nom"
        params["quartier_nom"] = quartier_nom

    # Compter le total
    count_query = f"SELECT COUNT(*) as total FROM ({query}) as count_subquery"
    total_result = db.execute(text(count_query), params).fetchone()
    total = total_result[0] if total_result else 0

    # Ajouter la pagination
    query += " ORDER BY montant_restant DESC, date_echeance ASC"
    query += " LIMIT :limit OFFSET :skip"
    params["limit"] = limit
    params["skip"] = skip

    # Exécuter la requête
    result = db.execute(text(query), params)
    columns = result.keys()

    # Convertir les résultats en dictionnaires
    items = []
    for row in result:
        item = {}
        for i, col in enumerate(columns):
            value = row[i]
            # Convertir les Decimal en float pour JSON
            if isinstance(value, Decimal):
                value = float(value)
            # Convertir les datetime en ISO string
            elif isinstance(value, (datetime, date)):
                value = value.isoformat()
            item[col] = value
        items.append(item)

    return {
        "items": items,
        "total": total,
        "skip": skip,
        "limit": limit
    }


@router.get("/vue/contribuable/{contribuable_id}", response_model=dict)
def get_impayes_contribuable_depuis_vue(
    contribuable_id: int,
    db: Session = Depends(get_db)
):
    """
    Récupère tous les impayés d'un contribuable depuis la vue impayes_view.
    Inclut les taxes payées, partielles, impayées et en retard.
    """
    query = """
        SELECT * FROM impayes_view
        WHERE contribuable_id = :contribuable_id
        ORDER BY
            CASE statut
                WHEN 'RETARD' THEN 1
                WHEN 'IMPAYE' THEN 2
                WHEN 'PARTIEL' THEN 3
                WHEN 'PAYE' THEN 4
            END,
            montant_restant DESC
    """

    result = db.execute(text(query), {"contribuable_id": contribuable_id})
    columns = result.keys()

    items = []
    for row in result:
        item = {}
        for i, col in enumerate(columns):
            value = row[i]
            if isinstance(value, Decimal):
                value = float(value)
            elif isinstance(value, (datetime, date)):
                value = value.isoformat()
            item[col] = value
        items.append(item)

    # Calculer les totaux pour ce contribuable
    totaux = {
        "montant_total_attendu": sum(item["montant_attendu"] for item in items),
        "montant_total_paye": sum(item["montant_paye"] for item in items),
        "montant_total_restant": sum(item["montant_restant"] for item in items),
        "nombre_taxes_total": len(items),
        "nombre_taxes_payees": sum(1 for item in items if item["statut"] == "PAYE"),
        "nombre_taxes_impayees": sum(1 for item in items if item["statut"] in ["IMPAYE", "RETARD"]),
        "nombre_taxes_partielles": sum(1 for item in items if item["statut"] == "PARTIEL"),
    }

    return {
        "contribuable_id": contribuable_id,
        "contribuable_nom": items[0]["contribuable_nom"] if items else None,
        "contribuable_prenom": items[0]["contribuable_prenom"] if items else None,
        "items": items,
        "totaux": totaux
    }


@router.get("/vue/statistiques", response_model=dict)
def get_statistiques_depuis_vue(
    db: Session = Depends(get_db)
):
    """
    Récupère les statistiques globales depuis la vue impayes_view.
    Ces statistiques sont calculées en temps réel et toujours à jour.
    """
    # Statistiques globales
    stats_query = """
        SELECT
            COUNT(*) as total_affectations,
            COUNT(CASE WHEN statut = 'PAYE' THEN 1 END) as total_paye,
            COUNT(CASE WHEN statut = 'PARTIEL' THEN 1 END) as total_partiel,
            COUNT(CASE WHEN statut = 'IMPAYE' THEN 1 END) as total_impaye,
            COUNT(CASE WHEN statut = 'RETARD' THEN 1 END) as total_retard,
            SUM(montant_attendu) as montant_total_attendu,
            SUM(montant_paye) as montant_total_paye,
            SUM(montant_restant) as montant_total_restant,
            SUM(CASE WHEN statut IN ('IMPAYE', 'RETARD', 'PARTIEL') THEN montant_restant ELSE 0 END) as montant_impaye_total
        FROM impayes_view
    """

    result = db.execute(text(stats_query)).fetchone()

    # Statistiques par zone
    stats_zone_query = """
        SELECT
            zone_nom,
            COUNT(*) as nb_affectations,
            COUNT(CASE WHEN statut IN ('IMPAYE', 'RETARD') THEN 1 END) as nb_impayes,
            SUM(montant_restant) as montant_restant_total
        FROM impayes_view
        WHERE statut IN ('IMPAYE', 'RETARD', 'PARTIEL')
        GROUP BY zone_nom
        ORDER BY montant_restant_total DESC
    """

    zones_result = db.execute(text(stats_zone_query))
    zones = []
    for row in zones_result:
        zones.append({
            "zone_nom": row[0],
            "nb_affectations": row[1],
            "nb_impayes": row[2],
            "montant_restant_total": float(row[3]) if row[3] else 0
        })

    # Statistiques par collecteur
    stats_collecteur_query = """
        SELECT
            collecteur_nom,
            collecteur_prenom,
            COUNT(*) as nb_affectations,
            COUNT(CASE WHEN statut IN ('IMPAYE', 'RETARD') THEN 1 END) as nb_impayes,
            SUM(CASE WHEN statut IN ('IMPAYE', 'RETARD', 'PARTIEL') THEN montant_restant ELSE 0 END) as montant_a_recouvrer
        FROM impayes_view
        GROUP BY collecteur_nom, collecteur_prenom
        ORDER BY montant_a_recouvrer DESC
    """

    collecteurs_result = db.execute(text(stats_collecteur_query))
    collecteurs = []
    for row in collecteurs_result:
        collecteurs.append({
            "collecteur_nom": row[0],
            "collecteur_prenom": row[1],
            "nb_affectations": row[2],
            "nb_impayes": row[3],
            "montant_a_recouvrer": float(row[4]) if row[4] else 0
        })

    return {
        "globales": {
            "total_affectations": result[0] or 0,
            "total_paye": result[1] or 0,
            "total_partiel": result[2] or 0,
            "total_impaye": result[3] or 0,
            "total_retard": result[4] or 0,
            "montant_total_attendu": float(result[5]) if result[5] else 0,
            "montant_total_paye": float(result[6]) if result[6] else 0,
            "montant_total_restant": float(result[7]) if result[7] else 0,
            "montant_impaye_total": float(result[8]) if result[8] else 0,
        },
        "par_zone": zones,
        "par_collecteur": collecteurs
    }

