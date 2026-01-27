import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router, RouterLink } from '@angular/router';
import { ApiService, Service } from '../../services/api.service';
import { AuthService } from '../../services/auth.service';

@Component({
  selector: 'app-services',
  standalone: true,
  imports: [CommonModule, RouterLink],
  template: `
    <div class="min-h-screen bg-gradient-to-br from-blue-50 via-indigo-50 to-white flex flex-col">
      <!-- Header - Identique à la page d'accueil -->
      <header class="bg-white shadow-md z-50 relative">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="flex justify-between items-center py-4">
            <!-- Logo et nom -->
            <div class="flex items-center space-x-4">
              <img src="/assets/logo_app.png" alt="Mairie de Port-Gentil" class="h-14 w-auto">
              <div>
                <h1 class="text-2xl font-bold text-gray-900">Portail Citoyen</h1>
                <p class="text-sm text-gray-600">Mairie de Port-Gentil</p>
              </div>
            </div>
            
            <!-- Navigation -->
            <nav class="hidden md:flex items-center space-x-6">
                <a [routerLink]="['/']" class="px-4 py-2 text-sm font-medium text-gray-700 hover:text-indigo-600 transition">
                  Accueil
                </a>
                <div class="flex items-center space-x-2 text-gray-700 cursor-pointer hover:text-indigo-600 transition">
                  <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 5h12M9 3v2m1.048 9.5A18.022 18.022 0 016.412 9m6.088 9h7M11 21l5-10 5 10M12.751 5C11.783 10.77 8.07 15.61 3 18.129" />
                  </svg>
                  <span class="text-sm font-medium">FR ▾</span>
                </div>
                @if (!authService.isAuthenticated()) {
                  <a [routerLink]="['/login']" class="px-6 py-2 bg-indigo-700 text-white rounded-lg hover:bg-indigo-800 transition font-medium">
                    Se connecter
                  </a>
                } @else {
                  <a [routerLink]="['/dashboard']" class="px-6 py-2 bg-indigo-700 text-white rounded-lg hover:bg-indigo-800 transition font-medium">
                    Mon Espace
                  </a>
                }
            </nav>
          </div>
        </div>
      </header>

      <!-- Hero Section -->
      <section class="relative bg-gradient-to-r from-indigo-700 via-blue-800 to-indigo-700 py-16">
        <div class="absolute inset-0 overflow-hidden">
          <div class="absolute inset-0 bg-[url('/assets/hotel-de-ville.jpeg')] bg-cover bg-center opacity-20 blur-xl"></div>
        </div>
        <div class="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <h2 class="text-4xl md:text-5xl font-bold text-white mb-4">
            Services de la Mairie
          </h2>
          <p class="text-xl text-indigo-100 max-w-3xl mx-auto">
            Découvrez tous les services municipaux disponibles et effectuez vos démarches en ligne
          </p>
        </div>
      </section>

      <!-- Services Grid -->
      <section class="flex-1 py-16">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          @if (loading) {
            <div class="text-center py-20">
              <div class="inline-block animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-indigo-700"></div>
              <p class="mt-4 text-gray-600">Chargement des services...</p>
            </div>
          } @else if (services.length === 0) {
            <div class="text-center py-20">
              <svg class="mx-auto h-16 w-16 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4" />
              </svg>
              <h3 class="mt-4 text-xl font-semibold text-gray-900">Aucun service disponible</h3>
              <p class="mt-2 text-gray-600">Les services seront bientôt disponibles.</p>
            </div>
          } @else {
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
              @for (service of services; track service.id) {
                <div class="group relative bg-white rounded-2xl shadow-lg overflow-hidden hover:shadow-2xl transition-all duration-300 transform hover:-translate-y-2">
                  <!-- Gradient top bar -->
                  <div class="h-2 bg-gradient-to-r from-indigo-700 via-blue-700 to-indigo-800"></div>
                  
                  <div class="p-6">
                    <!-- Icon -->
                    <div class="flex items-center mb-4">
                      <div class="w-16 h-16 bg-gradient-to-br from-indigo-100 to-blue-100 rounded-xl flex items-center justify-center mr-4 group-hover:scale-110 transition-transform duration-300">
                        @if (service.icone) {
                          <span class="text-3xl">{{ service.icone }}</span>
                        } @else {
                          <svg class="w-8 h-8 text-indigo-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4" />
                          </svg>
                        }
                      </div>
                      <div class="flex-1">
                        <h3 class="text-xl font-bold text-gray-900 group-hover:text-indigo-700 transition-colors">
                          {{ service.nom }}
                        </h3>
                      </div>
                    </div>

                    <!-- Description -->
                    <p class="text-gray-600 text-sm mb-6 line-clamp-3">
                      {{ service.description || 'Service municipal disponible via le portail citoyen.' }}
                    </p>

                    <!-- Action button -->
                    <div class="pt-4 border-t border-gray-100">
                      @if (authService.isAuthenticated()) {
                        <a
                          [routerLink]="['/demandes/nouvelle']"
                          [queryParams]="{ service: service.nom }"
                          class="inline-flex items-center justify-center w-full px-4 py-3 bg-indigo-700 text-white rounded-lg hover:bg-indigo-800 transition-all duration-300 transform hover:scale-105 font-semibold shadow-lg"
                        >
                          <span>Faire une demande</span>
                          <svg class="ml-2 w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7l5 5m0 0l-5 5m5-5H6" />
                          </svg>
                        </a>
                      } @else {
                        <a
                          [routerLink]="['/login']"
                          class="inline-flex items-center justify-center w-full px-4 py-3 bg-indigo-700 text-white rounded-lg hover:bg-indigo-800 transition-all duration-300 transform hover:scale-105 font-semibold shadow-lg"
                        >
                          <span>Se connecter pour accéder</span>
                          <svg class="ml-2 w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7l5 5m0 0l-5 5m5-5H6" />
                          </svg>
                        </a>
                      }
                    </div>
                  </div>

                  <!-- Hover effect overlay -->
                  <div class="absolute inset-0 bg-gradient-to-br from-indigo-500/0 to-blue-500/0 group-hover:from-indigo-500/5 group-hover:to-blue-500/5 transition-all duration-300 pointer-events-none"></div>
                </div>
              }
            </div>
          }
        </div>
      </section>

      <!-- Call to Action Section -->
      <section class="bg-gradient-to-r from-indigo-700 via-blue-800 to-indigo-700 py-16">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <h3 class="text-3xl font-bold text-white mb-4">
            Besoin d'aide pour utiliser nos services ?
          </h3>
          <p class="text-xl text-blue-100 mb-8 max-w-2xl mx-auto">
            Notre équipe est à votre disposition pour vous accompagner dans vos démarches en ligne
          </p>
          <div class="flex flex-col sm:flex-row gap-4 justify-center">
            <a
              href="tel:+2410176123456"
              class="inline-flex items-center justify-center px-8 py-4 bg-white text-indigo-700 rounded-lg hover:bg-indigo-50 transition-all duration-300 transform hover:scale-105 font-semibold shadow-lg"
            >
              <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z" />
              </svg>
              <span>Nous appeler</span>
            </a>
            <a
              [routerLink]="['/']"
              class="inline-flex items-center justify-center px-8 py-4 bg-indigo-900 text-white rounded-lg hover:bg-indigo-800 transition-all duration-300 transform hover:scale-105 font-semibold shadow-lg border-2 border-white/20"
            >
              <span>Retour à l'accueil</span>
            </a>
          </div>
        </div>
      </section>

      <!-- Footer - Identique à la page d'accueil -->
      <footer class="bg-indigo-900 text-white py-12">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
            <!-- Colonne gauche - Logo et contact -->
            <div class="space-y-4">
              <div class="flex items-center space-x-3">
                <img src="/assets/logo_app.png" alt="Logo" class="h-12 w-12">
                <div>
                  <h4 class="text-xl font-bold">Portail Citoyen</h4>
                  <p class="text-sm text-indigo-200">Mairie de Port-Gentil</p>
                </div>
              </div>
              <div class="pt-4">
                <p class="text-sm font-semibold mb-2">Pour toute assistance :</p>
                <p class="text-sm text-indigo-200">
                  01 76 12 34 56 | 01 76 12 34 57 | 01 76 12 34 58
                </p>
              </div>
            </div>

            <!-- Colonne centrale - Liens -->
            <div class="space-y-4">
              <h4 class="font-semibold mb-4">Ressources</h4>
              <ul class="space-y-2 text-sm text-indigo-200">
                <li><a href="#" class="hover:text-white transition">Guide de l'espace déconnecté</a></li>
                <li><a href="#" class="hover:text-white transition">Réponses aux questions fréquentes</a></li>
                <li><a [routerLink]="['/services']" class="hover:text-white transition">Services disponibles</a></li>
              </ul>
            </div>

            <!-- Colonne droite - Logo DGI style -->
            <div class="space-y-4">
              <div class="bg-white rounded-lg p-4 w-fit">
                <div class="flex items-center space-x-2">
                  <img src="/assets/logo_app.png" alt="Logo" class="h-8 w-8">
                  <span class="text-indigo-900 font-bold text-lg">MAIRIE</span>
                </div>
                <p class="text-xs text-gray-600 mt-1">DIRECTION GÉNÉRALE<br>DES SERVICES</p>
              </div>
              <ul class="space-y-2 text-sm text-indigo-200">
                <li><a [routerLink]="['/login']" class="hover:text-white transition">Se connecter</a></li>
                <li><a [routerLink]="['/services']" class="hover:text-white transition">Inscrivez-vous au portail</a></li>
              </ul>
              <p class="text-xs text-indigo-300 mt-4">
                Mairie de Port-Gentil - Gabon
              </p>
            </div>
          </div>

          <div class="border-t border-indigo-800 mt-8 pt-8 text-center text-sm text-indigo-300">
            <p>&copy; 2024 Mairie de Port-Gentil. Tous droits réservés.</p>
          </div>
        </div>
      </footer>
    </div>
  `,
  styles: []
})
export class ServicesComponent implements OnInit {
  services: Service[] = [];
  loading = false;

  constructor(
    private apiService: ApiService,
    public authService: AuthService,
    private router: Router
  ) {}

  ngOnInit() {
    this.loadServices();
  }

  loadServices() {
    this.loading = true;
    this.apiService.getServices().subscribe({
      next: (services) => {
        this.services = services;
        this.loading = false;
      },
      error: (err) => {
        console.error('Erreur lors du chargement des services:', err);
        this.loading = false;
      }
    });
  }
}
