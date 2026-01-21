import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router, RouterLink } from '@angular/router';
import { AuthService, Contribuable } from '../../services/auth.service';
import { ApiService, AffectationTaxe } from '../../services/api.service';

@Component({
  selector: 'app-taxes',
  standalone: true,
  imports: [CommonModule, RouterLink],
  template: `
    <div class="min-h-screen bg-gray-50">
      <!-- Header -->
      <header class="bg-white shadow-sm">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
          <div class="flex justify-between items-center">
            <div>
              <h1 class="text-2xl font-bold text-gray-900">Mes Taxes</h1>
              <p class="text-sm text-gray-600">Consultez vos taxes et échéances</p>
            </div>
            <a [routerLink]="['/dashboard']" class="px-4 py-2 text-gray-700 hover:bg-gray-100 rounded-lg transition">
              Retour
            </a>
          </div>
        </div>
      </header>

      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <!-- Résumé -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
          <div class="bg-white rounded-xl shadow p-6">
            <p class="text-sm text-gray-600 mb-1">Total dû</p>
            <p class="text-3xl font-bold text-gray-900">{{ montantTotalDu | number:'1.0-0' }} FCFA</p>
          </div>
          <div class="bg-white rounded-xl shadow p-6">
            <p class="text-sm text-gray-600 mb-1">Total payé</p>
            <p class="text-3xl font-bold text-green-600">{{ montantTotalPaye | number:'1.0-0' }} FCFA</p>
          </div>
          <div class="bg-white rounded-xl shadow p-6">
            <p class="text-sm text-gray-600 mb-1">En retard</p>
            <p class="text-3xl font-bold text-red-600">{{ taxesEnRetard.length }}</p>
          </div>
        </div>

        <!-- Liste des taxes -->
        @if (loading) {
          <div class="text-center py-12">
            <p class="text-gray-500">Chargement...</p>
          </div>
        } @else if (taxes.length === 0) {
          <div class="bg-white rounded-xl shadow p-12 text-center">
            <svg class="w-16 h-16 text-gray-400 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
            </svg>
            <h3 class="text-lg font-semibold text-gray-900 mb-2">Aucune taxe</h3>
            <p class="text-gray-600">Vous n'avez pas de taxes pour le moment</p>
          </div>
        } @else {
          <div class="space-y-4">
            @for (taxe of taxes; track taxe.id) {
              <div class="bg-white rounded-xl shadow p-6 hover:shadow-lg transition">
                <div class="flex items-start justify-between mb-4">
                  <div class="flex-1">
                    <div class="flex items-center gap-3 mb-2">
                      <h3 class="text-lg font-semibold text-gray-900">{{ taxe.taxe.nom }}</h3>
                      <span [class]="getStatutClass(taxe.statut)" class="px-3 py-1 rounded-full text-xs font-semibold">
                        {{ getStatutLabel(taxe.statut) }}
                      </span>
                    </div>
                    <p class="text-sm text-gray-600 mb-4">{{ taxe.taxe.description }}</p>
                    <div class="grid grid-cols-2 md:grid-cols-4 gap-4 text-sm">
                      <div>
                        <p class="text-gray-600">Montant dû</p>
                        <p class="font-semibold text-gray-900">{{ taxe.montant_du | number:'1.0-0' }} FCFA</p>
                      </div>
                      <div>
                        <p class="text-gray-600">Montant payé</p>
                        <p class="font-semibold text-green-600">{{ taxe.montant_paye | number:'1.0-0' }} FCFA</p>
                      </div>
                      <div>
                        <p class="text-gray-600">Reste à payer</p>
                        <p class="font-semibold text-red-600">{{ (taxe.montant_du - taxe.montant_paye) | number:'1.0-0' }} FCFA</p>
                      </div>
                      @if (taxe.echeance) {
                        <div>
                          <p class="text-gray-600">Échéance</p>
                          <p class="font-semibold" [class]="isEcheanceDepassee(taxe.echeance) ? 'text-red-600' : 'text-gray-900'">
                            {{ taxe.echeance | date:'dd/MM/yyyy' }}
                          </p>
                        </div>
                      }
                    </div>
                  </div>
                </div>
                @if (taxe.montant_du > taxe.montant_paye) {
                  <div class="mt-4 pt-4 border-t border-gray-200">
                    <a
                      [routerLink]="['/paiement', taxe.taxe.id]"
                      class="inline-block px-6 py-2 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 transition"
                    >
                      Payer maintenant
                    </a>
                  </div>
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
export class TaxesComponent implements OnInit {
  contribuable: Contribuable | null = null;
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

    this.loadTaxes();
  }

  loadTaxes() {
    this.loading = true;
    const contribuableId = this.contribuable!.id;

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

  get montantTotalDu() {
    return this.taxes.reduce((sum, t) => sum + t.montant_du, 0);
  }

  get montantTotalPaye() {
    return this.taxes.reduce((sum, t) => sum + t.montant_paye, 0);
  }

  get taxesEnRetard() {
    return this.taxes.filter(t => t.statut === 'en_retard');
  }

  getStatutLabel(statut: string): string {
    const labels: { [key: string]: string } = {
      'a_jour': 'À jour',
      'en_retard': 'En retard',
      'partiellement_paye': 'Partiellement payé'
    };
    return labels[statut] || statut;
  }

  getStatutClass(statut: string): string {
    const classes: { [key: string]: string } = {
      'a_jour': 'bg-green-100 text-green-800',
      'en_retard': 'bg-red-100 text-red-800',
      'partiellement_paye': 'bg-yellow-100 text-yellow-800'
    };
    return classes[statut] || 'bg-gray-100 text-gray-800';
  }

  isEcheanceDepassee(echeance: string): boolean {
    return new Date(echeance) < new Date();
  }
}

