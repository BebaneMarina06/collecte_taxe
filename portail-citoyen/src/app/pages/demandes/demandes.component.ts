import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router, RouterLink } from '@angular/router';
import { AuthService, Contribuable } from '../../services/auth.service';
import { ApiService, Demande } from '../../services/api.service';

@Component({
  selector: 'app-demandes',
  standalone: true,
  imports: [CommonModule, RouterLink],
  template: `
    <div class="min-h-screen bg-gray-50">
      <!-- Header -->
      <header class="bg-white shadow-sm">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
          <div class="flex justify-between items-center">
            <div>
              <h1 class="text-2xl font-bold text-gray-900">Mes Demandes</h1>
              <p class="text-sm text-gray-600">Suivez l'état de vos demandes de services</p>
            </div>
            <div class="flex gap-3">
              <a [routerLink]="['/dashboard']" class="px-4 py-2 text-gray-700 hover:bg-gray-100 rounded-lg transition">
                Retour
              </a>
              <a [routerLink]="['/demandes/nouvelle']" class="px-4 py-2 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 transition">
                Nouvelle demande
              </a>
            </div>
          </div>
        </div>
      </header>

      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <!-- Filtres -->
        <div class="bg-white rounded-xl shadow p-6 mb-6">
          <div class="flex gap-4">
            <button
              (click)="filterStatut = ''"
              [class]="filterStatut === '' ? 'bg-indigo-600 text-white' : 'bg-gray-100 text-gray-700'"
              class="px-4 py-2 rounded-lg transition"
            >
              Toutes
            </button>
            <button
              (click)="filterStatut = 'envoyee'"
              [class]="filterStatut === 'envoyee' ? 'bg-indigo-600 text-white' : 'bg-gray-100 text-gray-700'"
              class="px-4 py-2 rounded-lg transition"
            >
              Envoyées
            </button>
            <button
              (click)="filterStatut = 'en_traitement'"
              [class]="filterStatut === 'en_traitement' ? 'bg-indigo-600 text-white' : 'bg-gray-100 text-gray-700'"
              class="px-4 py-2 rounded-lg transition"
            >
              En traitement
            </button>
            <button
              (click)="filterStatut = 'complete'"
              [class]="filterStatut === 'complete' ? 'bg-indigo-600 text-white' : 'bg-gray-100 text-gray-700'"
              class="px-4 py-2 rounded-lg transition"
            >
              Complétées
            </button>
            <button
              (click)="filterStatut = 'rejetee'"
              [class]="filterStatut === 'rejetee' ? 'bg-indigo-600 text-white' : 'bg-gray-100 text-gray-700'"
              class="px-4 py-2 rounded-lg transition"
            >
              Rejetées
            </button>
          </div>
        </div>

        <!-- Liste des demandes -->
        @if (loading) {
          <div class="text-center py-12">
            <p class="text-gray-500">Chargement...</p>
          </div>
        } @else if (filteredDemandes.length === 0) {
          <div class="bg-white rounded-xl shadow p-12 text-center">
            <svg class="w-16 h-16 text-gray-400 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
            </svg>
            <h3 class="text-lg font-semibold text-gray-900 mb-2">Aucune demande</h3>
            <p class="text-gray-600 mb-6">Vous n'avez pas encore de demandes</p>
            <a [routerLink]="['/demandes/nouvelle']" class="inline-block px-6 py-3 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 transition">
              Créer une demande
            </a>
          </div>
        } @else {
          <div class="space-y-4">
            @for (demande of filteredDemandes; track demande.id) {
              <div class="bg-white rounded-xl shadow p-6 hover:shadow-lg transition">
                <div class="flex items-start justify-between">
                  <div class="flex-1">
                    <div class="flex items-center gap-3 mb-2">
                      <h3 class="text-lg font-semibold text-gray-900">{{ demande.sujet }}</h3>
                      <span [class]="getStatutClass(demande.statut)" class="px-3 py-1 rounded-full text-xs font-semibold">
                        {{ getStatutLabel(demande.statut) }}
                      </span>
                    </div>
                    <p class="text-sm text-gray-600 mb-2">
                      <span class="font-medium">Type:</span> {{ demande.type_demande }}
                    </p>
                    <p class="text-sm text-gray-600 mb-4">{{ demande.description }}</p>
                    <div class="flex items-center gap-4 text-xs text-gray-500">
                      <span>
                        <span class="font-medium">Créée le:</span>
                        {{ demande.date_creation | date:'dd/MM/yyyy à HH:mm' }}
                      </span>
                      @if (demande.date_traitement) {
                        <span>
                          <span class="font-medium">Traitée le:</span>
                          {{ demande.date_traitement | date:'dd/MM/yyyy à HH:mm' }}
                        </span>
                      }
                    </div>
                    @if (demande.reponse) {
                      <div class="mt-4 p-4 bg-gray-50 rounded-lg">
                        <p class="text-sm font-medium text-gray-900 mb-1">Réponse:</p>
                        <p class="text-sm text-gray-700">{{ demande.reponse }}</p>
                      </div>
                    }
                  </div>
                </div>
              </div>
            }
          </div>
        }
      </div>
    </div>
  `,
  styles: []
})
export class DemandesComponent implements OnInit {
  contribuable: Contribuable | null = null;
  demandes: Demande[] = [];
  loading = false;
  filterStatut = '';

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

    this.loadDemandes();
  }

  loadDemandes() {
    this.loading = true;
    const contribuableId = this.contribuable!.id;

    this.apiService.getDemandes(contribuableId).subscribe({
      next: (demandes) => {
        this.demandes = demandes;
        this.loading = false;
      },
      error: (err) => {
        console.error('Erreur lors du chargement des demandes:', err);
        this.loading = false;
      }
    });
  }

  get filteredDemandes() {
    if (!this.filterStatut) {
      return this.demandes;
    }
    return this.demandes.filter(d => d.statut === this.filterStatut);
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
}

