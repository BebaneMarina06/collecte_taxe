import { Injectable, signal } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Router } from '@angular/router';
import { Observable, tap } from 'rxjs';
import { environment } from '../../environments/environment';

export interface Contribuable {
  id: number;
  nom: string;
  prenom: string;
  telephone: string;
  email?: string;
  adresse?: string;
  matricule?: string;
}

export interface LoginResponse {
  access_token: string;
  token_type: string;
  contribuable: Contribuable;
}

export interface OtpRequestPayload {
  email: string;
}

export interface OtpVerifyPayload {
  email: string;
  code: string;
}

@Injectable({
  providedIn: 'root'
})
export class AuthService {
  private readonly TOKEN_KEY = 'citoyen_token';
  private readonly CONTRIBUABLE_KEY = 'citoyen_contribuable';

  currentContribuable = signal<Contribuable | null>(null);

  constructor(
    private http: HttpClient,
    private router: Router
  ) {
    this.loadStoredAuth();
  }

  requestOtp(payload: OtpRequestPayload): Observable<void> {
    return this.http.post<void>(`${environment.apiUrl}/api/citoyen/otp/request`, payload);
  }

  verifyOtp(payload: OtpVerifyPayload): Observable<LoginResponse> {
    return this.http.post<LoginResponse>(`${environment.apiUrl}/api/citoyen/otp/verify`, payload).pipe(
      tap(response => {
        this.setAuth(response);
      })
    );
  }

  logout(): void {
    localStorage.removeItem(this.TOKEN_KEY);
    localStorage.removeItem(this.CONTRIBUABLE_KEY);
    this.currentContribuable.set(null);
    this.router.navigate(['/']);
  }

  isAuthenticated(): boolean {
    return !!this.getToken();
  }

  getToken(): string | null {
    return localStorage.getItem(this.TOKEN_KEY);
  }

  getContribuable(): Contribuable | null {
    return this.currentContribuable();
  }

  private setAuth(response: LoginResponse): void {
    localStorage.setItem(this.TOKEN_KEY, response.access_token);
    localStorage.setItem(this.CONTRIBUABLE_KEY, JSON.stringify(response.contribuable));
    this.currentContribuable.set(response.contribuable);
  }

  private loadStoredAuth(): void {
    const token = this.getToken();
    const contribuableStr = localStorage.getItem(this.CONTRIBUABLE_KEY);
    
    if (token && contribuableStr) {
      try {
        const contribuable = JSON.parse(contribuableStr);
        this.currentContribuable.set(contribuable);
      } catch (e) {
        console.error('Erreur lors du chargement de l\'authentification:', e);
        this.logout();
      }
    }
  }
}

