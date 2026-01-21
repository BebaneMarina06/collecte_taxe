export interface TaxePaiementStatGlobal {
  montant_espere: number;
  montant_collecte: number;
  montant_restant_du: number;
  taux_collecte: number; // en pourcentage
  nombre_contribuables_avec_taxes: number;
}

export interface TaxePaiementStatParTaxe {
  taxe_id: number;
  taxe_nom: string;
  nombre_contribuables: number;
  montant_espere: number;
  montant_collecte: number;
  montant_restant_du: number;
  taux_collecte: number; // en pourcentage
}

export interface TaxePaiementStatistiquesResponse {
  global: TaxePaiementStatGlobal;
  par_taxe: TaxePaiementStatParTaxe[];
}