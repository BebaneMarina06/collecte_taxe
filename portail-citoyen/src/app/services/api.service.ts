import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment';

export interface Service {
  id: number;
  nom: string;
  description: string;
  icone?: string;
}

export interface Demande {
  id: number;
  type_demande: string;
  sujet: string;
  description: string;
  statut: 'envoyee' | 'en_traitement' | 'complete' | 'rejetee';
  date_creation: string;
  date_traitement?: string;
  reponse?: string;
  pieces_jointes?: string[];
}

export interface DemandeCreate {
  type_demande: string;
  sujet: string;
  description: string;
  pieces_jointes?: string[];
}

export interface Taxe {
  id: number;
  nom: string;
  description: string;
  montant: number;
  periodicite: string;
  service?: string;
}

export interface AffectationTaxe {
  id: number;
  taxe: Taxe;
  date_debut: string;
  date_fin?: string;
  montant_custom?: number;
  montant_du: number;
  montant_paye: number;
  echeance?: string;
  statut: 'a_jour' | 'en_retard' | 'partiellement_paye';
}

@Injectable({
  providedIn: 'root'
})
export class ApiService {
  constructor(private http: HttpClient) {}

  // Services
  getServices(): Observable<Service[]> {
    return this.http.get<Service[]>(`${environment.apiUrl}/api/services`);
  }

  // Demandes
  getDemandes(contribuableId: number): Observable<Demande[]> {
    const params = new HttpParams().set('contribuable_id', contribuableId.toString());
    return this.http.get<Demande[]>(`${environment.apiUrl}/api/demandes-citoyens`, { params });
  }

  getDemande(id: number): Observable<Demande> {
    return this.http.get<Demande>(`${environment.apiUrl}/api/demandes-citoyens/${id}`);
  }

  createDemande(demande: DemandeCreate, contribuableId: number): Observable<Demande> {
    return this.http.post<Demande>(`${environment.apiUrl}/api/demandes-citoyens`, {
      ...demande,
      contribuable_id: contribuableId
    });
  }

  // Taxes
  getTaxesContribuable(contribuableId: number): Observable<AffectationTaxe[]> {
    return this.http.get<AffectationTaxe[]>(`${environment.apiUrl}/api/citoyen/taxes/${contribuableId}`);
  }

  getTaxesDisponibles(): Observable<Taxe[]> {
    return this.http.get<Taxe[]>(`${environment.apiUrl}/api/client/taxes`);
  }

  // Paiement
  initierPaiement(data: any): Observable<any> {
    return this.http.post<any>(`${environment.apiUrl}/api/client/paiement/initier`, data);
  }

  getStatutPaiement(billingId: string): Observable<any> {
    return this.http.get<any>(`${environment.apiUrl}/api/client/paiement/statut/${billingId}`);
  }
}

