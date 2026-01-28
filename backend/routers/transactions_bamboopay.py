"""
Routes pour la gestion des transactions BambooPay (backoffice/admin)
"""

from fastapi import APIRouter, Depends, HTTPException, Query, Request
from fastapi.responses import JSONResponse
from sqlalchemy.orm import Session, joinedload
from sqlalchemy import func, desc, or_
from typing import List, Optional
from database.database import get_db
from database.models import TransactionBambooPay, StatutTransactionEnum, Contribuable, Taxe
from services.bamboopay import bamboopay_service
from datetime import datetime, date
from decimal import Decimal
from pydantic import BaseModel
from auth.security import get_current_active_user
import logging

logger = logging.getLogger(__name__)

router = APIRouter(
    prefix="/api/transactions-bamboopay",
    tags=["transactions-bamboopay"],
    dependencies=[Depends(get_current_active_user)],
)


class TransactionListResponse(BaseModel):
    """Réponse pour la liste des transactions"""
    id: int
    billing_id: str
    payer_name: str
    phone: str
    matricule: Optional[str] = None
    raison_sociale: Optional[str] = None
    transaction_amount: Decimal
    statut: str
    statut_message: Optional[str] = None
    reference_bp: Optional[str] = None
    transaction_id: Optional[str] = None
    operateur: Optional[str] = None
    payment_method: Optional[str] = None
    date_initiation: datetime
    date_paiement: Optional[datetime] = None
    date_callback: Optional[datetime] = None
    contribuable_id: Optional[int] = None
    contribuable_nom: Optional[str] = None
    taxe_id: Optional[int] = None
    taxe_nom: Optional[str] = None

    class Config:
        from_attributes = True


class TransactionStats(BaseModel):
    """Statistiques des transactions"""
    total_transactions: int
    total_success: int
    total_pending: int
    total_failed: int
    total_cancelled: int
    montant_total_success: Decimal
    montant_total_pending: Decimal


@router.get("/", response_model=List[TransactionListResponse])
@router.get("", response_model=List[TransactionListResponse])
def get_transactions(
    skip: int = Query(0, ge=0),
    limit: int = Query(50, ge=1, le=500),
    statut: Optional[str] = None,
    date_debut: Optional[date] = None,
    date_fin: Optional[date] = None,
    search: Optional[str] = None,
    contribuable_id: Optional[int] = None,
    taxe_id: Optional[int] = None,
    payment_method: Optional[str] = None,
    order_by: str = Query("-date_initiation", description="Champ de tri (préfixe - pour desc)"),
    db: Session = Depends(get_db)
):
    """
    Récupère la liste des transactions BambooPay avec filtres et pagination
    """
    query = db.query(TransactionBambooPay).options(
        joinedload(TransactionBambooPay.contribuable),
        joinedload(TransactionBambooPay.taxe)
    )

    # Filtres
    if statut:
        try:
            statut_enum = StatutTransactionEnum(statut)
            query = query.filter(TransactionBambooPay.statut == statut_enum)
        except ValueError:
            raise HTTPException(status_code=400, detail="Statut invalide")

    if date_debut:
        query = query.filter(
            func.date(TransactionBambooPay.date_initiation) >= date_debut
        )

    if date_fin:
        query = query.filter(
            func.date(TransactionBambooPay.date_initiation) <= date_fin
        )

    if contribuable_id:
        query = query.filter(TransactionBambooPay.contribuable_id == contribuable_id)

    if taxe_id:
        query = query.filter(TransactionBambooPay.taxe_id == taxe_id)

    if payment_method:
        query = query.filter(TransactionBambooPay.payment_method == payment_method)

    if search:
        search_pattern = f"%{search}%"
        query = query.filter(
            or_(
                TransactionBambooPay.payer_name.ilike(search_pattern),
                TransactionBambooPay.phone.ilike(search_pattern),
                TransactionBambooPay.billing_id.ilike(search_pattern),
                TransactionBambooPay.reference_bp.ilike(search_pattern),
                TransactionBambooPay.matricule.ilike(search_pattern)
            )
        )

    # Tri
    if order_by.startswith("-"):
        order_field = order_by[1:]
        order_direction = desc
    else:
        order_field = order_by
        order_direction = lambda x: x

    if hasattr(TransactionBambooPay, order_field):
        query = query.order_by(order_direction(getattr(TransactionBambooPay, order_field)))
    else:
        query = query.order_by(desc(TransactionBambooPay.date_initiation))

    transactions = query.offset(skip).limit(limit).all()

    # Formater les résultats
    result = []
    for t in transactions:
        result.append(TransactionListResponse(
            id=t.id,
            billing_id=t.billing_id,
            payer_name=t.payer_name,
            phone=t.phone,
            matricule=t.matricule,
            raison_sociale=t.raison_sociale,
            transaction_amount=t.transaction_amount,
            statut=t.statut.value if t.statut else "pending",
            statut_message=t.statut_message,
            reference_bp=t.reference_bp,
            transaction_id=t.transaction_id,
            operateur=t.operateur,
            payment_method=t.payment_method,
            date_initiation=t.date_initiation,
            date_paiement=t.date_paiement,
            date_callback=t.date_callback,
            contribuable_id=t.contribuable_id,
            contribuable_nom=f"{t.contribuable.nom} {t.contribuable.prenom or ''}".strip() if t.contribuable else None,
            taxe_id=t.taxe_id,
            taxe_nom=t.taxe.nom if t.taxe else None
        ))

    return result


@router.get("/stats", response_model=TransactionStats)
def get_transactions_stats(
    date_debut: Optional[date] = None,
    date_fin: Optional[date] = None,
    db: Session = Depends(get_db)
):
    """
    Récupère les statistiques des transactions
    """
    query = db.query(TransactionBambooPay)

    if date_debut:
        query = query.filter(
            func.date(TransactionBambooPay.date_initiation) >= date_debut
        )

    if date_fin:
        query = query.filter(
            func.date(TransactionBambooPay.date_initiation) <= date_fin
        )

    # Compter par statut
    total = query.count()
    success = query.filter(TransactionBambooPay.statut == StatutTransactionEnum.SUCCESS).count()
    pending = query.filter(TransactionBambooPay.statut == StatutTransactionEnum.PENDING).count()
    failed = query.filter(TransactionBambooPay.statut == StatutTransactionEnum.FAILED).count()
    cancelled = query.filter(TransactionBambooPay.statut == StatutTransactionEnum.CANCELLED).count()

    # Calculer les montants
    montant_success = db.query(func.sum(TransactionBambooPay.transaction_amount)).filter(
        TransactionBambooPay.statut == StatutTransactionEnum.SUCCESS
    )
    montant_pending = db.query(func.sum(TransactionBambooPay.transaction_amount)).filter(
        TransactionBambooPay.statut == StatutTransactionEnum.PENDING
    )

    if date_debut:
        montant_success = montant_success.filter(
            func.date(TransactionBambooPay.date_initiation) >= date_debut
        )
        montant_pending = montant_pending.filter(
            func.date(TransactionBambooPay.date_initiation) >= date_debut
        )

    if date_fin:
        montant_success = montant_success.filter(
            func.date(TransactionBambooPay.date_initiation) <= date_fin
        )
        montant_pending = montant_pending.filter(
            func.date(TransactionBambooPay.date_initiation) <= date_fin
        )

    return TransactionStats(
        total_transactions=total,
        total_success=success,
        total_pending=pending,
        total_failed=failed,
        total_cancelled=cancelled,
        montant_total_success=montant_success.scalar() or Decimal("0.00"),
        montant_total_pending=montant_pending.scalar() or Decimal("0.00")
    )


@router.get("/{transaction_id}", response_model=TransactionListResponse)
def get_transaction(
    transaction_id: int,
    db: Session = Depends(get_db)
):
    """
    Récupère une transaction par son ID
    """
    transaction = db.query(TransactionBambooPay).options(
        joinedload(TransactionBambooPay.contribuable),
        joinedload(TransactionBambooPay.taxe)
    ).filter(TransactionBambooPay.id == transaction_id).first()

    if not transaction:
        raise HTTPException(status_code=404, detail="Transaction non trouvée")

    return TransactionListResponse(
        id=transaction.id,
        billing_id=transaction.billing_id,
        payer_name=transaction.payer_name,
        phone=transaction.phone,
        matricule=transaction.matricule,
        raison_sociale=transaction.raison_sociale,
        transaction_amount=transaction.transaction_amount,
        statut=transaction.statut.value if transaction.statut else "pending",
        statut_message=transaction.statut_message,
        reference_bp=transaction.reference_bp,
        transaction_id=transaction.transaction_id,
        operateur=transaction.operateur,
        payment_method=transaction.payment_method,
        date_initiation=transaction.date_initiation,
        date_paiement=transaction.date_paiement,
        date_callback=transaction.date_callback,
        contribuable_id=transaction.contribuable_id,
        contribuable_nom=f"{transaction.contribuable.nom} {transaction.contribuable.prenom or ''}".strip() if transaction.contribuable else None,
        taxe_id=transaction.taxe_id,
        taxe_nom=transaction.taxe.nom if transaction.taxe else None
    )


@router.post("/{transaction_id}/refresh")
async def refresh_transaction_status(
    transaction_id: int,
    db: Session = Depends(get_db)
):
    """
    Actualise le statut d'une transaction en interrogeant BambooPay
    """
    transaction = db.query(TransactionBambooPay).filter(
        TransactionBambooPay.id == transaction_id
    ).first()

    if not transaction:
        raise HTTPException(status_code=404, detail="Transaction non trouvée")

    if not transaction.reference_bp and not transaction.transaction_id:
        raise HTTPException(status_code=400, detail="Aucune référence BambooPay disponible")

    # Vérifier le statut auprès de BambooPay
    ref = transaction.transaction_id or transaction.reference_bp
    result = await bamboopay_service.verifier_statut(ref)

    old_statut = transaction.statut.value if transaction.statut else "pending"

    if result.get("success"):
        statut_bp = result.get("status", "").lower()
        if statut_bp in ["success", "completed", "paid"]:
            transaction.statut = StatutTransactionEnum.SUCCESS
            if not transaction.date_paiement:
                transaction.date_paiement = datetime.utcnow()
        elif statut_bp in ["failed", "error"]:
            transaction.statut = StatutTransactionEnum.FAILED
        elif statut_bp in ["cancelled", "canceled"]:
            transaction.statut = StatutTransactionEnum.CANCELLED

        transaction.statut_message = result.get("message")
        transaction.updated_at = datetime.utcnow()
        db.commit()

    return {
        "success": result.get("success", False),
        "transaction_id": transaction_id,
        "old_statut": old_statut,
        "new_statut": transaction.statut.value if transaction.statut else "pending",
        "message": result.get("message"),
        "bamboopay_response": result
    }


@router.get("/by-billing-id/{billing_id}", response_model=TransactionListResponse)
def get_transaction_by_billing_id(
    billing_id: str,
    db: Session = Depends(get_db)
):
    """
    Récupère une transaction par son billing_id
    """
    transaction = db.query(TransactionBambooPay).options(
        joinedload(TransactionBambooPay.contribuable),
        joinedload(TransactionBambooPay.taxe)
    ).filter(TransactionBambooPay.billing_id == billing_id).first()

    if not transaction:
        raise HTTPException(status_code=404, detail="Transaction non trouvée")

    return TransactionListResponse(
        id=transaction.id,
        billing_id=transaction.billing_id,
        payer_name=transaction.payer_name,
        phone=transaction.phone,
        matricule=transaction.matricule,
        raison_sociale=transaction.raison_sociale,
        transaction_amount=transaction.transaction_amount,
        statut=transaction.statut.value if transaction.statut else "pending",
        statut_message=transaction.statut_message,
        reference_bp=transaction.reference_bp,
        transaction_id=transaction.transaction_id,
        operateur=transaction.operateur,
        payment_method=transaction.payment_method,
        date_initiation=transaction.date_initiation,
        date_paiement=transaction.date_paiement,
        date_callback=transaction.date_callback,
        contribuable_id=transaction.contribuable_id,
        contribuable_nom=f"{transaction.contribuable.nom} {transaction.contribuable.prenom or ''}".strip() if transaction.contribuable else None,
        taxe_id=transaction.taxe_id,
        taxe_nom=transaction.taxe.nom if transaction.taxe else None
    )
