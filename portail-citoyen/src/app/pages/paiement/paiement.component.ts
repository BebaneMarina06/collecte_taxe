import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ActivatedRoute, Router, RouterLink } from '@angular/router';
import { AuthService, Contribuable } from '../../services/auth.service';
import { ApiService, AffectationTaxe, Taxe } from '../../services/api.service';

@Component({
  selector: 'app-paiement',
  standalone: true,
  imports: [CommonModule, RouterLink, FormsModule],
  template: `
    <div class="min-h-screen bg-gray-50">
      <!-- Header -->
      <header class="bg-white shadow-sm">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
          <div class="flex justify-between items-center">
            <h1 class="text-2xl font-bold text-gray-900">Paiement en ligne</h1>
            <a [routerLink]="['/taxes']" class="px-4 py-2 text-gray-700 hover:bg-gray-100 rounded-lg transition">
              Retour
            </a>
          </div>
        </div>
      </header>

      <div class="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        @if (loading) {
          <div class="text-center py-12">
            <p class="text-gray-500">Chargement...</p>
          </div>
        } @else if (errorMessage) {
          <div class="bg-red-50 border border-red-200 rounded-xl p-6 mb-6">
            <p class="text-red-700">{{ errorMessage }}</p>
          </div>
        } @else if (taxe && contribuable) {
          <div class="bg-white rounded-xl shadow p-8">
            <h2 class="text-2xl font-bold text-gray-900 mb-6">{{ taxe.nom }}</h2>
            
            <div class="mb-6 p-4 bg-gray-50 rounded-lg">
              <div class="flex justify-between items-center mb-2">
                <span class="text-gray-600">Montant à payer</span>
                <span class="text-2xl font-bold text-gray-900">{{ montantAPayer | number:'1.0-0' }} FCFA</span>
              </div>
              @if (montantRestant > 0) {
                <p class="text-sm text-gray-600">
                  Montant total: {{ montantTotal | number:'1.0-0' }} FCFA
                  (Déjà payé: {{ montantPaye | number:'1.0-0' }} FCFA)
                </p>
              }
            </div>

            <div class="mb-6">
              <label class="block text-sm font-medium text-gray-700 mb-2">
                Méthode de paiement
              </label>
              <select
                [(ngModel)]="paymentMethod"
                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500"
              >
                <option value="mobile_instant">Mobile Money (Paiement instantané)</option>
                <option value="web">Paiement web (Redirection)</option>
              </select>
            </div>

            @if (paymentMethod === 'mobile_instant') {
              <div class="mb-6">
                <label class="block text-sm font-medium text-gray-700 mb-2">
                  Opérateur
                </label>
                <select
                  [(ngModel)]="operateur"
                  class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500"
                >
                  <option value="AIRTEL">AIRTEL</option>
                  <option value="MOOV">MOOV</option>
                </select>
              </div>
            }

            <div class="mb-6">
              <label class="block text-sm font-medium text-gray-700 mb-2">
                Numéro de téléphone
              </label>
              <input
                type="tel"
                [(ngModel)]="phone"
                [value]="contribuable.telephone"
                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500"
                placeholder="+241 01 23 45 67"
              />
            </div>

            <button
              (click)="initierPaiement()"
              [disabled]="processing || !phone"
              class="w-full py-3 bg-indigo-600 text-white rounded-lg font-semibold hover:bg-indigo-700 transition disabled:opacity-50 disabled:cursor-not-allowed"
            >
              @if (processing) {
                <span class="flex items-center justify-center">
                  <svg class="animate-spin -ml-1 mr-3 h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                    <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                    <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                  </svg>
                  Traitement en cours...
                </span>
              } @else {
                Payer {{ montantAPayer | number:'1.0-0' }} FCFA
              }
            </button>

            @if (transactionResponse) {
              <div class="mt-6 p-4 bg-blue-50 border border-blue-200 rounded-lg">
                <p class="text-blue-700 text-sm mb-2">{{ transactionResponse.message }}</p>
                @if (transactionResponse.redirect_url) {
                  <a
                    [href]="transactionResponse.redirect_url"
                    target="_blank"
                    class="inline-block mt-2 px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition"
                  >
                    Continuer vers BambooPay →
                  </a>
                }
                @if (transactionResponse.reference_bp) {
                  <p class="text-xs text-blue-600 mt-2">
                    Référence: {{ transactionResponse.reference_bp }}
                  </p>
                }
              </div>
            }
          </div>
        }
      </div>
    </div>
  `,
  styles: []
})
export class PaiementComponent implements OnInit {
  contribuable: Contribuable | null = null;
  taxeId: number | null = null;
  taxe: Taxe | null = null;
  affectationTaxe: AffectationTaxe | null = null;
  paymentMethod = 'mobile_instant';
  operateur = 'AIRTEL';
  phone = '';
  loading = false;
  processing = false;
  errorMessage = '';
  transactionResponse: any = null;

  constructor(
    private authService: AuthService,
    private apiService: ApiService,
    private route: ActivatedRoute,
    private router: Router
  ) {}

  ngOnInit() {
    this.contribuable = this.authService.getContribuable();
    if (!this.contribuable) {
      this.router.navigate(['/login']);
      return;
    }

    this.phone = this.contribuable.telephone || '';

    this.route.params.subscribe(params => {
      this.taxeId = +params['taxeId'];
      this.loadTaxeData();
    });
  }

  loadTaxeData() {
    if (!this.taxeId || !this.contribuable) return;

    this.loading = true;

    // Charger les taxes du contribuable pour trouver l'affectation
    this.apiService.getTaxesContribuable(this.contribuable.id).subscribe({
      next: (taxes) => {
        this.affectationTaxe = taxes.find(t => t.taxe.id === this.taxeId!) || null;
        if (this.affectationTaxe) {
          this.taxe = this.affectationTaxe.taxe;
        } else {
          // Si pas d'affectation, charger la taxe directement
          this.apiService.getTaxesDisponibles().subscribe({
            next: (taxes) => {
              this.taxe = taxes.find(t => t.id === this.taxeId!) || null;
              if (!this.taxe) {
                this.errorMessage = 'Taxe non trouvée';
              }
              this.loading = false;
            },
            error: () => {
              this.errorMessage = 'Erreur lors du chargement de la taxe';
              this.loading = false;
            }
          });
          return;
        }
        this.loading = false;
      },
      error: () => {
        this.errorMessage = 'Erreur lors du chargement des données';
        this.loading = false;
      }
    });
  }

  get montantTotal() {
    return this.affectationTaxe?.montant_du || this.taxe?.montant || 0;
  }

  get montantPaye() {
    return this.affectationTaxe?.montant_paye || 0;
  }

  get montantRestant() {
    return this.montantTotal - this.montantPaye;
  }

  get montantAPayer() {
    return this.montantRestant > 0 ? this.montantRestant : this.montantTotal;
  }

  initierPaiement() {
    if (!this.taxe || !this.contribuable || !this.phone) return;

    this.processing = true;
    this.errorMessage = '';
    this.transactionResponse = null;

    const data = {
      contribuable_id: this.contribuable.id,
      taxe_id: this.taxe.id,
      affectation_taxe_id: this.affectationTaxe?.id,
      payer_name: `${this.contribuable.prenom} ${this.contribuable.nom}`,
      phone: this.phone,
      matricule: this.contribuable.matricule || '',
      raison_sociale: '',
      payment_method: this.paymentMethod,
      operateur: this.paymentMethod === 'mobile_instant' ? this.operateur : undefined
    };

    this.apiService.initierPaiement(data).subscribe({
      next: (response) => {
        this.transactionResponse = response;
        this.processing = false;

        if (response.redirect_url) {
          // Rediriger vers BambooPay
          window.location.href = response.redirect_url;
        } else if (response.reference_bp) {
          // Paiement instantané - vérifier le statut périodiquement
          this.verifierStatutPaiement(response.billing_id);
        }
      },
      error: (err) => {
        this.processing = false;
        this.errorMessage = err.error?.detail || 'Erreur lors de l\'initiation du paiement';
      }
    });
  }

  verifierStatutPaiement(billingId: string) {
    // Vérifier le statut toutes les 3 secondes pendant 30 secondes
    let attempts = 0;
    const maxAttempts = 10;

    const interval = setInterval(() => {
      attempts++;
      this.apiService.getStatutPaiement(billingId).subscribe({
        next: (status) => {
          if (status.statut === 'success' || status.statut === 'completed') {
            clearInterval(interval);
            this.router.navigate(['/taxes'], { queryParams: { payment: 'success' } });
          } else if (status.statut === 'failed') {
            clearInterval(interval);
            this.errorMessage = 'Le paiement a échoué';
          }
        },
        error: () => {
          // Ignorer les erreurs de vérification
        }
      });

      if (attempts >= maxAttempts) {
        clearInterval(interval);
      }
    }, 3000);
  }
}

