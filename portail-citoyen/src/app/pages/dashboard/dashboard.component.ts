import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router, RouterLink } from '@angular/router';
import { AuthService, Contribuable } from '../../services/auth.service';
import { ApiService, Demande, AffectationTaxe } from '../../services/api.service';

@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [CommonModule, RouterLink],
  template: `
    <div class="min-h-screen bg-gray-50">
      <!-- Header -->
      <header class="bg-white shadow-sm">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
          <div class="flex justify-between items-center">
            <div>
              <h1 class="text-2xl font-bold text-gray-900">Mon Espace</h1>
              <p class="text-sm text-gray-600">
                Bienvenue, {{ contribuable?.prenom }} {{ contribuable?.nom }}
              </p>
            </div>
            <button
              (click)="logout()"
              class="px-4 py-2 text-gray-700 hover:bg-gray-100 rounded-lg transition"
            >
              Déconnexion
            </button>
          </div>
        </div>
      </header>

      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <!-- Stats Cards -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
          <div class="bg-white rounded-xl shadow p-6">
            <div class="flex items-center justify-between">
              <div>
                <p class="text-sm text-gray-600 mb-1">Mes Demandes</p>
                <p class="text-3xl font-bold text-gray-900">{{ demandes.length }}</p>
              </div>
              <div class="w-12 h-12 bg-blue-100 rounded-lg flex items-center justify-center">
                <svg class="w-6 h-6 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                </svg>
              </div>
            </div>
          </div>

          <div class="bg-white rounded-xl shadow p-6">
            <div class="flex items-center justify-between">
              <div>
                <p class="text-sm text-gray-600 mb-1">Taxes en attente</p>
                <p class="text-3xl font-bold text-gray-900">{{ taxesEnRetard.length }}</p>
              </div>
              <div class="w-12 h-12 bg-red-100 rounded-lg flex items-center justify-center">
                <svg class="w-6 h-6 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
              </div>
            </div>
          </div>

          <div class="bg-white rounded-xl shadow p-6">
            <div class="flex items-center justify-between">
              <div>
                <p class="text-sm text-gray-600 mb-1">Montant total dû</p>
                <p class="text-3xl font-bold text-gray-900">{{ montantTotalDu | number:'1.0-0' }} FCFA</p>
              </div>
              <div class="w-12 h-12 bg-green-100 rounded-lg flex items-center justify-center">
                <svg class="w-6 h-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
              </div>
            </div>
          </div>
        </div>

        <!-- Quick Actions -->
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
          <a [routerLink]="['/demandes/nouvelle']" class="bg-white rounded-xl shadow p-6 hover:shadow-lg transition block">
            <div class="flex items-center">
              <div class="w-12 h-12 bg-indigo-100 rounded-lg flex items-center justify-center mr-4">
                <svg class="w-6 h-6 text-indigo-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
                </svg>
              </div>
              <div>
                <h3 class="text-lg font-semibold text-gray-900">Nouvelle demande</h3>
                <p class="text-sm text-gray-600">Soumettre une nouvelle demande de service</p>
              </div>
            </div>
          </a>

          <a [routerLink]="['/taxes']" class="bg-white rounded-xl shadow p-6 hover:shadow-lg transition block">
            <div class="flex items-center">
              <div class="w-12 h-12 bg-green-100 rounded-lg flex items-center justify-center mr-4">
                <svg class="w-6 h-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 9V7a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2m2 4h10a2 2 0 002-2v-6a2 2 0 00-2-2H9a2 2 0 00-2 2v6a2 2 0 002 2zm7-5a2 2 0 11-4 0 2 2 0 014 0z" />
                </svg>
              </div>
              <div>
                <h3 class="text-lg font-semibold text-gray-900">Mes taxes</h3>
                <p class="text-sm text-gray-600">Consulter et payer vos taxes</p>
              </div>
            </div>
          </a>
        </div>

        <!-- Recent Demandes -->
        <div class="bg-white rounded-xl shadow mb-8">
          <div class="p-6 border-b border-gray-200">
            <div class="flex justify-between items-center">
              <h2 class="text-xl font-semibold text-gray-900">Mes demandes récentes</h2>
              <a [routerLink]="['/demandes']" class="text-indigo-600 hover:text-indigo-700 text-sm font-medium">
                Voir tout →
              </a>
            </div>
          </div>
          <div class="p-6">
            @if (loading) {
              <p class="text-center text-gray-500 py-8">Chargement...</p>
            } @else if (demandes.length === 0) {
              <p class="text-center text-gray-500 py-8">Aucune demande pour le moment</p>
            } @else {
              <div class="space-y-4">
                @for (demande of demandes.slice(0, 5); track demande.id) {
                  <div class="flex items-center justify-between p-4 bg-gray-50 rounded-lg">
                    <div class="flex-1">
                      <h3 class="font-semibold text-gray-900">{{ demande.sujet }}</h3>
                      <p class="text-sm text-gray-600 mt-1">{{ demande.type_demande }}</p>
                      <p class="text-xs text-gray-500 mt-1">
                        {{ demande.date_creation | date:'dd/MM/yyyy' }}
                      </p>
                    </div>
                    <span [class]="getStatutClass(demande.statut)" class="px-3 py-1 rounded-full text-xs font-semibold">
                      {{ getStatutLabel(demande.statut) }}
                    </span>
                  </div>
                }
              </div>
            }
          </div>
        </div>

        <!-- Taxes en retard -->
        @if (taxesEnRetard.length > 0) {
          <div class="bg-red-50 border border-red-200 rounded-xl p-6">
            <h2 class="text-lg font-semibold text-red-900 mb-4">Taxes en retard</h2>
            <div class="space-y-3">
              @for (taxe of taxesEnRetard.slice(0, 3); track taxe.id) {
                <div class="flex items-center justify-between bg-white p-4 rounded-lg">
                  <div>
                    <h3 class="font-semibold text-gray-900">{{ taxe.taxe.nom }}</h3>
                    <p class="text-sm text-gray-600">
                      Échéance: {{ taxe.echeance | date:'dd/MM/yyyy' }}
                    </p>
                  </div>
                  <div class="text-right">
                    <p class="font-semibold text-red-600">{{ taxe.montant_du | number:'1.0-0' }} FCFA</p>
                    <a [routerLink]="['/paiement', taxe.taxe.id]" class="text-sm text-indigo-600 hover:text-indigo-700">
                      Payer →
                    </a>
                  </div>
                </div>
              }
            </div>
          </div>
        }
      </div>
    </div>
  `,
  styles: []
})
export class DashboardComponent implements OnInit {
  contribuable: Contribuable | null = null;
  demandes: Demande[] = [];
  taxes: AffectationTaxe[] = [];
  loading = false;

  constructor(
    private authService: AuthService,
    private apiService: ApiService,
    private router: Router
  ) {}

  ngOnInit() {
    this.contribuable = this.authService.getContribuable();
    if (!this.contribuable) {
      this.router.navigate(['/login']);
      return;
    }

    this.loadData();
  }

  loadData() {
    this.loading = true;
    const contribuableId = this.contribuable!.id;

    // Charger les demandes
    this.apiService.getDemandes(contribuableId).subscribe({
      next: (demandes) => {
        this.demandes = demandes;
      },
      error: (err) => {
        console.error('Erreur lors du chargement des demandes:', err);
      }
    });

    // Charger les taxes
    this.apiService.getTaxesContribuable(contribuableId).subscribe({
      next: (taxes) => {
        this.taxes = taxes;
        this.loading = false;
      },
      error: (err) => {
        console.error('Erreur lors du chargement des taxes:', err);
        this.loading = false;
      }
    });
  }

  get taxesEnRetard() {
    return this.taxes.filter(t => t.statut === 'en_retard');
  }

  get montantTotalDu() {
    return this.taxes.reduce((sum, t) => sum + (t.montant_du - t.montant_paye), 0);
  }

  getStatutLabel(statut: string): string {
    const labels: { [key: string]: string } = {
      'envoyee': 'Envoyée',
      'en_traitement': 'En traitement',
      'complete': 'Complétée',
      'rejetee': 'Rejetée'
    };
    return labels[statut] || statut;
  }

  getStatutClass(statut: string): string {
    const classes: { [key: string]: string } = {
      'envoyee': 'bg-blue-100 text-blue-800',
      'en_traitement': 'bg-yellow-100 text-yellow-800',
      'complete': 'bg-green-100 text-green-800',
      'rejetee': 'bg-red-100 text-red-800'
    };
    return classes[statut] || 'bg-gray-100 text-gray-800';
  }

  logout() {
    this.authService.logout();
  }
}

