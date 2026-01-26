export type StatutDemande = 'envoyee' | 'en_traitement' | 'complete' | 'rejetee';

export interface DemandeCitoyen {
  id: number;
  contribuable_id: number;
  type_demande: string;
  sujet: string;
  description: string;
  statut: StatutDemande;
  reponse?: string | null;
  traite_par_id?: number | null;
  date_traitement?: string | null; // ISO string
  pieces_jointes?: string[] | null;
  created_at: string; // ISO string
  updated_at: string; // ISO string

  // Champs dérivés renvoyés par l'API
  contribuable_nom?: string | null;
  contribuable_prenom?: string | null;
  traite_par_nom?: string | null;
}