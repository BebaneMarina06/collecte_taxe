import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { Router, RouterLink } from '@angular/router';
import { AuthService, Contribuable } from '../../services/auth.service';
import { ApiService, Service } from '../../services/api.service';

@Component({
  selector: 'app-nouvelle-demande',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, RouterLink],
  template: `
    <div class="min-h-screen bg-gray-50">
      <!-- Header -->
      <header class="bg-white shadow-sm">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
          <div class="flex justify-between items-center">
            <h1 class="text-2xl font-bold text-gray-900">Nouvelle demande</h1>
            <a [routerLink]="['/demandes']" class="px-4 py-2 text-gray-700 hover:bg-gray-100 rounded-lg transition">
              Retour
            </a>
          </div>
        </div>
      </header>

      <div class="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div class="bg-white rounded-xl shadow p-8">
          <form [formGroup]="demandeForm" (ngSubmit)="onSubmit()">
            @if (errorMessage) {
              <div class="mb-6 p-4 bg-red-50 border border-red-200 rounded-lg text-red-700 text-sm">
                {{ errorMessage }}
              </div>
            }

            <div class="mb-6">
              <label for="type_demande" class="block text-sm font-medium text-gray-700 mb-2">
                Type de demande *
              </label>
              <select
                id="type_demande"
                formControlName="type_demande"
                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500"
              >
                <option value="">Sélectionnez un type</option>
                @for (service of services; track service.id) {
                  <option [value]="service.nom">{{ service.nom }}</option>
                }
              </select>
              @if (demandeForm.get('type_demande')?.invalid && demandeForm.get('type_demande')?.touched) {
                <p class="mt-1 text-sm text-red-600">Le type de demande est requis</p>
              }
            </div>

            <div class="mb-6">
              <label for="sujet" class="block text-sm font-medium text-gray-700 mb-2">
                Sujet *
              </label>
              <input
                id="sujet"
                type="text"
                formControlName="sujet"
                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500"
                placeholder="Ex: Demande de certificat de résidence"
              />
              @if (demandeForm.get('sujet')?.invalid && demandeForm.get('sujet')?.touched) {
                <p class="mt-1 text-sm text-red-600">Le sujet est requis</p>
              }
            </div>

            <div class="mb-6">
              <label for="description" class="block text-sm font-medium text-gray-700 mb-2">
                Description *
              </label>
              <textarea
                id="description"
                formControlName="description"
                rows="6"
                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500"
                placeholder="Décrivez votre demande en détail..."
              ></textarea>
              @if (demandeForm.get('description')?.invalid && demandeForm.get('description')?.touched) {
                <p class="mt-1 text-sm text-red-600">La description est requise</p>
              }
            </div>

            <div class="flex gap-4">
              <button
                type="button"
                (click)="router.navigate(['/demandes'])"
                class="flex-1 px-6 py-3 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition"
              >
                Annuler
              </button>
              <button
                type="submit"
                [disabled]="loading || demandeForm.invalid"
                class="flex-1 px-6 py-3 bg-indigo-600 text-white rounded-lg font-semibold hover:bg-indigo-700 transition disabled:opacity-50 disabled:cursor-not-allowed"
              >
                @if (loading) {
                  <span class="flex items-center justify-center">
                    <svg class="animate-spin -ml-1 mr-3 h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                      <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                      <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                    </svg>
                    Envoi en cours...
                  </span>
                } @else {
                  Envoyer la demande
                }
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  `,
  styles: []
})
export class NouvelleDemandeComponent implements OnInit {
  contribuable: Contribuable | null = null;
  services: Service[] = [];
  demandeForm: FormGroup;
  loading = false;
  errorMessage = '';

  constructor(
    private fb: FormBuilder,
    private authService: AuthService,
    private apiService: ApiService,
    public router: Router
  ) {
    this.demandeForm = this.fb.group({
      type_demande: ['', [Validators.required]],
      sujet: ['', [Validators.required]],
      description: ['', [Validators.required]]
    });
  }

  ngOnInit() {
    this.contribuable = this.authService.getContribuable();
    if (!this.contribuable) {
      this.router.navigate(['/login']);
      return;
    }

    this.loadServices();
  }

  loadServices() {
    this.apiService.getServices().subscribe({
      next: (services) => {
        this.services = services;
      },
      error: (err) => {
        console.error('Erreur lors du chargement des services:', err);
      }
    });
  }

  onSubmit() {
    if (this.demandeForm.valid && this.contribuable) {
      this.loading = true;
      this.errorMessage = '';

      this.apiService.createDemande(this.demandeForm.value, this.contribuable.id).subscribe({
        next: () => {
          this.router.navigate(['/demandes']);
        },
        error: (err) => {
          this.loading = false;
          this.errorMessage = err.error?.detail || 'Erreur lors de la création de la demande.';
        }
      });
    }
  }
}

