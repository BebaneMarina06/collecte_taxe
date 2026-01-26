# Code à ajouter à la fin de contribuables.py

@router.get("/{contribuable_id}/taxations")
def get_contribuable_taxations(contribuable_id: int, db: Session = Depends(get_db)):
    """
    Récupère toutes les affectations de taxes d'un contribuable.
    Utilisé pour afficher et gérer les taxes assignées à un contribuable.
    """
    from sqlalchemy.orm import joinedload
    from database.models import AffectationTaxe, Taxe

    # Vérifier que le contribuable existe
    contribuable = db.query(Contribuable).filter(Contribuable.id == contribuable_id).first()
    if not contribuable:
        raise HTTPException(status_code=404, detail="Contribuable non trouvé")

    # Récupérer toutes les affectations (actives et inactives)
    affectations = db.query(AffectationTaxe).options(
        joinedload(AffectationTaxe.taxe).joinedload(Taxe.type_taxe),
        joinedload(AffectationTaxe.taxe).joinedload(Taxe.service)
    ).filter(
        AffectationTaxe.contribuable_id == contribuable_id
    ).all()

    # Formater les affectations pour le frontend
    result = []
    for affectation in affectations:
        taxe = affectation.taxe
        if taxe:
            result.append({
                "id": affectation.id,
                "affectation_id": affectation.id,
                "taxe_id": taxe.id,
                "taxe_nom": taxe.nom,
                "taxe_code": taxe.code,
                "montant": float(taxe.montant),
                "montant_custom": float(affectation.montant_custom) if affectation.montant_custom else None,
                "periodicite": taxe.periodicite.value if hasattr(taxe.periodicite, 'value') else str(taxe.periodicite),
                "description": taxe.description or "",
                "commission_pourcentage": float(taxe.commission_pourcentage),
                "type_taxe": taxe.type_taxe.nom if taxe.type_taxe else None,
                "service": taxe.service.nom if taxe.service else None,
                "actif": affectation.actif,
                "date_debut": affectation.date_debut.isoformat() if affectation.date_debut else None,
                "date_fin": affectation.date_fin.isoformat() if affectation.date_fin else None,
                "created_at": affectation.created_at.isoformat() if affectation.created_at else None,
                "updated_at": affectation.updated_at.isoformat() if affectation.updated_at else None
            })

    return result
