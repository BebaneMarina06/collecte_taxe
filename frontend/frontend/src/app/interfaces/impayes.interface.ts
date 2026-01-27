/**
 * Interfaces pour la gestion des impayés basées sur la vue impayes_view
 */

export type StatutImpaye = 'PAYE' | 'PARTIEL' | 'IMPAYE' | 'RETARD';

export interface ImpayeVue {
  affectation_id: number;
  contribuable_id: number;
  contribuable_nom: string;
  contribuable_prenom: string;
  contribuable_telephone: string;
  contribuable_email: string;
  zone_nom: string;
  quartier_nom: string;
  taxe_id: number;
  taxe_nom: string;
  taxe_code: string;
  montant_attendu: number;
  montant_paye: number;
  montant_restant: number;
  pourcentage_paye: number;
  statut: StatutImpaye;
  date_echeance: string;
  jours_retard: number;
  collecteur_nom: string;
  collecteur_prenom: string;
  collecteur_telephone: string;
}

export interface ImpayesFiltres {
  skip?: number;
  limit?: number;
  statut?: StatutImpaye;
  contribuable_id?: number;
  taxe_id?: number;
  collecteur_id?: number;
  zone_nom?: string;
  quartier_nom?: string;
}

export interface ImpayeListeResponse {
  items: ImpayeVue[];
  total: number;
  skip: number;
  limit: number;
}

export interface TotauxContribuable {
  montant_total_attendu: number;
  montant_total_paye: number;
  montant_total_restant: number;
  nombre_taxes_total: number;
  nombre_taxes_payees: number;
  nombre_taxes_impayees: number;
  nombre_taxes_partielles: number;
}

export interface ImpayeContribuableResponse {
  contribuable_id: number;
  contribuable_nom: string;
  contribuable_prenom: string;
  items: ImpayeVue[];
  totaux: TotauxContribuable;
}

export interface StatistiquesGlobales {
  total_affectations: number;
  total_paye: number;
  total_partiel: number;
  total_impaye: number;
  total_retard: number;
  montant_total_attendu: number;
  montant_total_paye: number;
  montant_total_restant: number;
  montant_impaye_total: number;
}

export interface StatistiquesZone {
  zone_nom: string;
  nb_affectations: number;
  nb_impayes: number;
  montant_restant_total: number;
}

export interface StatistiquesCollecteur {
  collecteur_nom: string;
  collecteur_prenom: string;
  nb_affectations: number;
  nb_impayes: number;
  montant_a_recouvrer: number;
}

export interface StatistiquesImpayesResponse {
  globales: StatistiquesGlobales;
  par_zone: StatistiquesZone[];
  par_collecteur: StatistiquesCollecteur[];
}