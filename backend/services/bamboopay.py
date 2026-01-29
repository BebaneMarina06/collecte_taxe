"""
Service pour l'intégration avec l'API BambooPay
"""

import os
import base64
import httpx
import logging
from typing import Optional, Dict, Any
from datetime import datetime

logger = logging.getLogger(__name__)


class BambooPayService:
    """Service pour interagir avec l'API BambooPay"""
    
    def __init__(self):
        self.base_url = os.getenv("BAMBOOPAY_BASE_URL", "https://client.bamboopay-ga.com/api")
        # Par convention BambooPay : le « Numéro du marchand » sert également de username Basic Auth
        self.merchant_id = "6008889"
        self.merchant_secret = "12345678"
        self.merchant_username = "6008889"
        self.debug_mode = os.getenv("BAMBOOPAY_DEBUG", "false").lower() == "true"
        
        # Version correcte (celle du repo)
        if (not os.getenv("BAMBOOPAY_MERCHANT_ID") or not os.getenv("BAMBOOPAY_MERCHANT_SECRET")):
            logger.warning("Identifiants BambooPay non fournis dans l'environnement, utilisation des valeurs ITAXE par défaut.")
    
    def _get_auth_header(self) -> str:
        """Génère l'en-tête d'authentification Basic"""
        credentials = f"{self.merchant_username}:{self.merchant_secret}"
        encoded = base64.b64encode(credentials.encode()).decode()
        return f"Basic {encoded}"
    
    def _get_headers(self) -> Dict[str, str]:
        """Retourne les en-têtes HTTP pour les requêtes"""
        return {
            "Content-Type": "application/json",
            "Authorization": self._get_auth_header()
        }
    
    async def initier_paiement(
        self,
        payer_name: str,
        matricule: str,
        billing_id: str,
        transaction_amount: str,
        phone: str,
        raison_sociale: Optional[str] = None,
        return_url: Optional[str] = None,
        update_status_url: Optional[str] = None
    ) -> Dict[str, Any]:
        """
        Initie une transaction de paiement via BambooPay
        """
        url = f"{self.base_url}/send"
        
        payload = {
            "payerName": payer_name,
            "matricule": matricule,
            "billingId": billing_id,
            "transactionAmount": str(transaction_amount),
            "merchant_id": self.merchant_id,
            "phone": phone
        }
        
        if raison_sociale:
            payload["raisonSociale"] = raison_sociale
        if return_url:
            payload["return_url"] = return_url
        if update_status_url:
            payload["update_status_url"] = update_status_url
        
        if self.debug_mode:
            logger.info(f"Appel BambooPay /send: {url}")
            logger.debug(f"Payload: {payload}")
        
        try:
            async with httpx.AsyncClient(timeout=30.0) as client:
                response = await client.post(
                    url,
                    json=payload,
                    headers=self._get_headers()
                )
                
                if response.status_code == 200:
                    data = response.json()
                    if self.debug_mode:
                        logger.info(f"Paiement initié avec succès: {data.get('redirect_url', 'N/A')}")
                    return {
                        "success": True,
                        "redirect_url": data.get("redirect_url"),
                        "data": data
                    }
                else:
                    error_data = {}
                    try:
                        error_data = response.json()
                    except:
                        error_data = {"message": response.text}
                    
                    logger.error(f"Erreur BambooPay /send ({response.status_code}): {error_data}")
                    return {
                        "success": False,
                        "error": error_data.get("message", f"Erreur {response.status_code}"),
                        "code": response.status_code,
                        "data": error_data
                    }
        except httpx.TimeoutException:
            logger.error("Timeout lors de l'appel à BambooPay")
            return {
                "success": False,
                "error": "Timeout lors de la connexion à BambooPay",
                "code": 408
            }
        except Exception as e:
            logger.error(f"Exception lors de l'appel BambooPay: {str(e)}", exc_info=True)
            return {
                "success": False,
                "error": f"Erreur lors de l'appel à BambooPay: {str(e)}",
                "code": 500
            }
    
    async def paiement_instantane(
        self,
        phone: str,
        amount: str,
        payer_name: str,
        reference: str,
        callback_url: str,
        operateur: Optional[str] = None,
        merchant_id: Optional[str] = None
    ) -> Dict[str, Any]:
        """
        Effectue un paiement instantané via mobile money
        """
        url = f"{self.base_url}/mobile/instant-payment"
        
        # Utiliser le merchant_id fourni ou celui par défaut
        merchant_id_to_use = merchant_id or self.merchant_id
        
        payload = {
            "phone": phone,
            "amount": str(amount),
            "payer_name": payer_name,
            "reference": reference,
            "merchant_id": merchant_id_to_use,
            "callback_url": callback_url
        }
        
        if operateur:
            payload["operateur"] = operateur
        
        if self.debug_mode:
            logger.info(f"Appel BambooPay /mobile/instant-payment: {url}")
            logger.debug(f"Payload: {payload}")
        
        try:
            async with httpx.AsyncClient(timeout=30.0) as client:
                response = await client.post(
                    url,
                    json=payload,
                    headers=self._get_headers()
                )
                
                if response.status_code == 202:
                    data = response.json()
                    if self.debug_mode:
                        logger.info(f"Paiement instantané initié: {data.get('reference_bp', 'N/A')}")
                    return {
                        "success": data.get("status", False),
                        "reference_bp": data.get("reference_bp"),
                        "reference": data.get("reference"),
                        "message": data.get("message"),
                        "data": data
                    }
                else:
                    error_data = {}
                    try:
                        error_data = response.json()
                    except:
                        error_data = {"message": response.text}
                    
                    logger.error(f"Erreur BambooPay /mobile/instant-payment ({response.status_code}): {error_data}")
                    return {
                        "success": False,
                        "error": error_data.get("message", f"Erreur {response.status_code}"),
                        "code": response.status_code,
                        "data": error_data
                    }
        except httpx.TimeoutException:
            logger.error("Timeout lors de l'appel à BambooPay")
            return {
                "success": False,
                "error": "Timeout lors de la connexion à BambooPay",
                "code": 408
            }
        except Exception as e:
            logger.error(f"Exception lors de l'appel BambooPay: {str(e)}", exc_info=True)
            return {
                "success": False,
                "error": f"Erreur lors de l'appel à BambooPay: {str(e)}",
                "code": 500
            }
    
    async def verifier_statut(self, transaction_id: str) -> Dict[str, Any]:
        """
        Vérifie le statut d'une transaction
        """
        url = f"{self.base_url}/check-status/{transaction_id}"
        
        if self.debug_mode:
            logger.info(f"Appel BambooPay /check-status: {url}")
        
        try:
            async with httpx.AsyncClient(timeout=30.0) as client:
                response = await client.post(
                    url,
                    headers=self._get_headers()
                )
                
                if response.status_code == 200:
                    data = response.json()
                    transaction = data.get("transaction", {})
                    if self.debug_mode:
                        logger.info(f"Statut transaction {transaction_id}: {transaction.get('status', 'N/A')}")
                    return {
                        "success": True,
                        "status": transaction.get("status"),
                        "code": transaction.get("code"),
                        "message": transaction.get("message"),
                        "data": data
                    }
                else:
                    error_data = {}
                    try:
                        error_data = response.json()
                    except:
                        error_data = {"message": response.text}
                    
                    logger.error(f"Erreur BambooPay /check-status ({response.status_code}): {error_data}")
                    return {
                        "success": False,
                        "error": error_data.get("message", f"Erreur {response.status_code}"),
                        "code": response.status_code,
                        "data": error_data
                    }
        except httpx.TimeoutException:
            logger.error("Timeout lors de la vérification du statut")
            return {
                "success": False,
                "error": "Timeout lors de la connexion à BambooPay",
                "code": 408
            }
        except Exception as e:
            logger.error(f"Exception lors de la vérification du statut: {str(e)}", exc_info=True)
            return {
                "success": False,
                "error": f"Erreur lors de la vérification: {str(e)}",
                "code": 500
            }


# Instance globale du service
bamboopay_service = BambooPayService()
