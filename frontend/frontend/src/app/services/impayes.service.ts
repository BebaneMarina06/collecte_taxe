import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable, map, catchError, of } from 'rxjs';
import { environment } from '../../environments/environment';

// Interface pour l'ancienne API (dossier_impaye)
export interface DossierImpayeOld {
  id: number;
  contribuable_id: number;
  affectation_taxe_id: number;
  montant_initial: number;
  montant_paye: number;
  montant_restant: number;
  penalites: number;
  date_echeance: string;
  jours_retard: number;
  priorite: string;
  statut: string;
  contribuable?: any;
  affectation_taxe?: any;
  collecteur?: any;
}

// Interface pour la nouvelle API (vue impayes_view)
export interface ImpayeVue {
  affectation_id: number;
  contribuable_id: number;
  contribuable_nom: string;
  contribuable_prenom: string;
  contribuable_telephone: string;
  zone_nom: string;
  quartier_nom: string;
  taxe_id: number;
  taxe_nom: string;
  taxe_code: string;
  montant_attendu: number;
  montant_paye: number;
  montant_restant: number;
  pourcentage_paye: number;
  statut: 'PAYE' | 'PARTIEL' | 'IMPAYE' | 'RETARD';
  date_echeance: string;
  jours_retard: number;
  collecteur_nom: string;
  collecteur_prenom: string;
}

// Interface unifiée pour l'affichage
export interface ImpayeUnifie {
  id: number;
  contribuable_id: number;
  contribuable_nom: string;
  contribuable_prenom: string;
  contribuable_telephone: string;
  zone_nom: string;
  quartier_nom: string;
  taxe_nom: string;
  taxe_code: string;
  montant_attendu: number;
  montant_paye: number;
  montant_restant: number;
  pourcentage_paye: number;
  statut: string;
  date_echeance: string;
  jours_retard: number;
  collecteur_nom: string;
  collecteur_prenom: string;
}

export interface ListeResponse {
  items: ImpayeUnifie[];
  total: number;
  skip: number;
  limit: number;
}

@Injectable({
  providedIn: 'root'
})
export class ImpayesAdaptiveService {
  private apiUrl = environment.apiUrl || 'http://localhost:8000/api';
  private useNewApi = true; // Essayer d'abord la nouvelle API

  constructor(private http: HttpClient) {
    console.log('[ImpayesAdaptiveService] Using API URL:', this.apiUrl);
  }

  /**
   * Récupère les impayés avec détection automatique de l'API à utiliser
   */
  getImpayes(filters?: any): Observable<ListeResponse> {
    console.log('[ImpayesAdaptiveService] Récupération des impayés...');
    
    // Essayer d'abord la nouvelle API
    if (this.useNewApi) {
      return this.getFromNewApi(filters).pipe(
        catchError(error => {
          console.warn('[ImpayesAdaptiveService] Nouvelle API échouée, tentative ancienne API...', error);
          this.useNewApi = false;
          return this.getFromOldApi(filters);
        })
      );
    } else {
      return this.getFromOldApi(filters);
    }
  }

  /**
   * Récupère depuis la nouvelle API (vue impayes_view)
   */
  private getFromNewApi(filters?: any): Observable<ListeResponse> {
    let params = new HttpParams();
    
    if (filters) {
      Object.keys(filters).forEach(key => {
        if (filters[key] !== undefined && filters[key] !== null && filters[key] !== '') {
          params = params.set(key, filters[key].toString());
        }
      });
    }

    const url = `${this.apiUrl}/impayes/vue/liste`;
    console.log('[ImpayesAdaptiveService] Nouvelle API:', url, params.toString());

    return this.http.get<any>(url, { params }).pipe(
      map(response => {
        console.log('[ImpayesAdaptiveService] Réponse nouvelle API:', response);
        return {
          items: response.items.map((item: ImpayeVue) => this.convertNewToUnified(item)),
          total: response.total,
          skip: response.skip,
          limit: response.limit
        };
      })
    );
  }

  /**
   * Récupère depuis l'ancienne API (table dossier_impaye)
   */
  private getFromOldApi(filters?: any): Observable<ListeResponse> {
    let params = new HttpParams();
    
    if (filters) {
      if (filters.skip !== undefined) params = params.set('skip', filters.skip);
      if (filters.limit !== undefined) params = params.set('limit', filters.limit);
      if (filters.contribuable_id) params = params.set('contribuable_id', filters.contribuable_id);
      if (filters.statut) params = params.set('statut', filters.statut);
    }

    const url = `${this.apiUrl}/impayes`;
    console.log('[ImpayesAdaptiveService] Ancienne API:', url, params.toString());

    return this.http.get<any>(url, { params }).pipe(
      map(response => {
        console.log('[ImpayesAdaptiveService] Réponse ancienne API:', response);
        
        // L'ancienne API peut retourner soit { items, total } soit directement le tableau
        const items = response.items || response;
        const total = response.total || items.length;

        return {
          items: items.map((item: DossierImpayeOld) => this.convertOldToUnified(item)),
          total,
          skip: filters?.skip || 0,
          limit: filters?.limit || 100
        };
      })
    );
  }

  /**
   * Convertit les données de la nouvelle API vers le format unifié
   */
  private convertNewToUnified(item: ImpayeVue): ImpayeUnifie {
    return {
      id: item.affectation_id,
      contribuable_id: item.contribuable_id,
      contribuable_nom: item.contribuable_nom,
      contribuable_prenom: item.contribuable_prenom,
      contribuable_telephone: item.contribuable_telephone,
      zone_nom: item.zone_nom,
      quartier_nom: item.quartier_nom,
      taxe_nom: item.taxe_nom,
      taxe_code: item.taxe_code,
      montant_attendu: item.montant_attendu,
      montant_paye: item.montant_paye,
      montant_restant: item.montant_restant,
      pourcentage_paye: item.pourcentage_paye,
      statut: item.statut,
      date_echeance: item.date_echeance,
      jours_retard: item.jours_retard,
      collecteur_nom: item.collecteur_nom,
      collecteur_prenom: item.collecteur_prenom
    };
  }

  /**
   * Convertit les données de l'ancienne API vers le format unifié
   */
  private convertOldToUnified(item: DossierImpayeOld): ImpayeUnifie {
    const contribuable = item.contribuable || {};
    const affectation = item.affectation_taxe || {};
    const taxe = affectation.taxe || {};
    const collecteur = item.collecteur || {};

    return {
      id: item.id,
      contribuable_id: item.contribuable_id,
      contribuable_nom: contribuable.nom || '',
      contribuable_prenom: contribuable.prenom || '',
      contribuable_telephone: contribuable.telephone || '',
      zone_nom: contribuable.zone?.nom || '',
      quartier_nom: contribuable.quartier?.nom || '',
      taxe_nom: taxe.nom || '',
      taxe_code: taxe.code || '',
      montant_attendu: item.montant_initial || 0,
      montant_paye: item.montant_paye || 0,
      montant_restant: item.montant_restant || 0,
      pourcentage_paye: item.montant_initial > 0 
        ? (item.montant_paye / item.montant_initial) * 100 
        : 0,
      statut: this.mapOldStatut(item.statut),
      date_echeance: item.date_echeance,
      jours_retard: item.jours_retard || 0,
      collecteur_nom: collecteur.nom || '',
      collecteur_prenom: collecteur.prenom || ''
    };
  }

  /**
   * Mappe les anciens statuts vers les nouveaux
   */
  private mapOldStatut(statut: string): string {
    const mapping: { [key: string]: string } = {
      'paye': 'PAYE',
      'partiellement_paye': 'PARTIEL',
      'en_cours': 'IMPAYE',
      'archive': 'RETARD'
    };
    return mapping[statut] || statut.toUpperCase();
  }

  /**
   * Force l'utilisation d'une API spécifique
   */
  forceApiType(useNew: boolean): void {
    this.useNewApi = useNew;
    console.log(`[ImpayesAdaptiveService] Force ${useNew ? 'nouvelle' : 'ancienne'} API`);
  }
}