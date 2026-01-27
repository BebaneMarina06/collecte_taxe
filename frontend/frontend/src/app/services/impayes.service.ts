import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment';
import {
  ImpayeListeResponse,
  ImpayeContribuableResponse,
  StatistiquesImpayesResponse,
  ImpayesFiltres,
  StatutImpaye
} from '../interfaces/impayes.interface';

@Injectable({
  providedIn: 'root'
})
export class ImpayesService {
  private apiUrl = environment.apiUrl || 'http://localhost:8000/api';

  constructor(private http: HttpClient) {
    console.log('[ImpayesService] Using API URL:', this.apiUrl);
  }

  /**
   * Récupère la liste des impayés depuis la vue avec filtres optionnels
   */
  getImpayesListe(filtres?: ImpayesFiltres): Observable<ImpayeListeResponse> {
    let params = new HttpParams();

    if (filtres) {
      if (filtres.skip !== undefined) {
        params = params.set('skip', filtres.skip.toString());
      }
      if (filtres.limit !== undefined) {
        params = params.set('limit', filtres.limit.toString());
      }
      if (filtres.statut) {
        params = params.set('statut', filtres.statut);
      }
      if (filtres.contribuable_id) {
        params = params.set('contribuable_id', filtres.contribuable_id.toString());
      }
      if (filtres.taxe_id) {
        params = params.set('taxe_id', filtres.taxe_id.toString());
      }
      if (filtres.collecteur_id) {
        params = params.set('collecteur_id', filtres.collecteur_id.toString());
      }
      if (filtres.zone_nom) {
        params = params.set('zone_nom', filtres.zone_nom);
      }
      if (filtres.quartier_nom) {
        params = params.set('quartier_nom', filtres.quartier_nom);
      }
    }

    return this.http.get<ImpayeListeResponse>(
      `${this.apiUrl}/impayes/vue/liste`,
      { params }
    );
  }

  /**
   * Récupère tous les impayés d'un contribuable spécifique
   */
  getImpayesContribuable(contribuableId: number): Observable<ImpayeContribuableResponse> {
    return this.http.get<ImpayeContribuableResponse>(
      `${this.apiUrl}/impayes/vue/contribuable/${contribuableId}`
    );
  }

  /**
   * Récupère les statistiques globales sur les impayés
   */
  getStatistiquesImpayes(): Observable<StatistiquesImpayesResponse> {
    return this.http.get<StatistiquesImpayesResponse>(
      `${this.apiUrl}/impayes/vue/statistiques`
    );
  }

  /**
   * Récupère les impayés en retard uniquement
   */
  getImpayesRetard(skip: number = 0, limit: number = 100): Observable<ImpayeListeResponse> {
    return this.getImpayesListe({ skip, limit, statut: 'RETARD' });
  }

  /**
   * Récupère les impayés non payés (IMPAYE + RETARD)
   */
  getImpayesNonPayes(skip: number = 0, limit: number = 100): Observable<ImpayeListeResponse> {
    // On fait deux appels et on combine, ou on modifie l'API pour accepter plusieurs statuts
    return this.getImpayesListe({ skip, limit });
  }

  /**
   * Récupère les impayés d'une zone spécifique
   */
  getImpayesParZone(zoneNom: string, skip: number = 0, limit: number = 100): Observable<ImpayeListeResponse> {
    return this.getImpayesListe({ skip, limit, zone_nom: zoneNom });
  }

  /**
   * Récupère les impayés d'un quartier spécifique
   */
  getImpayesParQuartier(quartierNom: string, skip: number = 0, limit: number = 100): Observable<ImpayeListeResponse> {
    return this.getImpayesListe({ skip, limit, quartier_nom: quartierNom });
  }
}
