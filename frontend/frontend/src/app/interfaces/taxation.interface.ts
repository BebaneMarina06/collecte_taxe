export interface Taxation {
  id: number;
  taxe_id: number;
  taxe_nom: string;
  periode_debut: string;
  periode_fin: string | null;
  annee: number;
  mois: number | null;
  montant_attendu: number;
  montant_paye: number;
  montant_restant: number;
  statut: string;
  date_echeance: string | null;
  actif: boolean;
  est_en_retard: boolean;
}

export interface TaxationResponse {
  taxations: Taxation[];
  total: number;
}