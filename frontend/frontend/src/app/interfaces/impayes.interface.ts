/**
 * Interfaces pour la gestion des impayés
 */

export type StatutImpaye = 'PAYE' | 'PARTIEL' | 'IMPAYE' | 'RETARD';

export interface ImpayeVue {
  affectation_id: number;
  contribuable_id: number;
  taxe_id: number;

  // Informations contribuable
  contribuable_nom: string;
  contribuable_prenom: string;
  contribuable_telephone: string | null;
  contribuable_numero_identification: string | null;
  contribuable_actif: boolean;

  // Informations taxe
  taxe_nom: string;
  taxe_code: string;
  taxe_periodicite: string;
  taxe_montant_base: number;

  // Type et service
  type_taxe_nom: string | null;
  service_nom: string | null;

  // Localisation
  quartier_nom: string | null;
  zone_nom: string | null;

  // Collecteur
  collecteur_nom: string | null;
  collecteur_prenom: string | null;

  // Montants (calculés automatiquement)
  montant_attendu: number;
  montant_paye: number;
  montant_restant: number;

  // Statut (calculé automatiquement)
  statut: StatutImpaye;

  // Dates
  date_debut: string;
  date_echeance: string | null;
  date_derniere_collecte: string | null;
  nombre_paiements: number;
  affectation_created_at: string;
  affectation_updated_at: string;
  affectation_active: boolean;
}

export interface ImpayeListeResponse {
  items: ImpayeVue[];
  total: number;
  skip: number;
  limit: number;
}

export interface ImpayeContribuableResponse {
  contribuable_id: number;
  contribuable_nom: string;
  contribuable_prenom: string;
  items: ImpayeVue[];
  totaux: {
    montant_total_attendu: number;
    montant_total_paye: number;
    montant_total_restant: number;
    nombre_taxes_total: number;
    nombre_taxes_payees: number;
    nombre_taxes_impayees: number;
    nombre_taxes_partielles: number;
  };
}

export interface StatistiquesImpayesGlobales {
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
  globales: StatistiquesImpayesGlobales;
  par_zone: StatistiquesZone[];
  par_collecteur: StatistiquesCollecteur[];
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
