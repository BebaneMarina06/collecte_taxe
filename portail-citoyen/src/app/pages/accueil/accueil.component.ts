import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router, RouterLink } from '@angular/router';
import { ApiService, Service } from '../../services/api.service';
import { AuthService } from '../../services/auth.service';

@Component({
  selector: 'app-accueil',
  standalone: true,
  imports: [CommonModule, RouterLink],
  template: `
    <div class="min-h-screen bg-white flex flex-col">
      <!-- Header -->
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
              <div class="flex items-center space-x-2 text-gray-700 cursor-pointer hover:text-indigo-600 transition">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 5h12M9 3v2m1.048 9.5A18.022 18.022 0 016.412 9m6.088 9h7M11 21l5-10 5 10M12.751 5C11.783 10.77 8.07 15.61 3 18.129" />
                </svg>
                <span class="text-sm font-medium">FR ▾</span>
              </div>
              @if (!authService.isAuthenticated()) {
                <a [routerLink]="['/services']" class="px-4 py-2 text-sm font-medium text-gray-700 hover:text-indigo-600 transition">
                  Services
                </a>
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

      <!-- Bannière d'alerte -->
      <div class="bg-red-600 text-white py-3 px-4 relative z-40">
        <div class="max-w-7xl mx-auto flex items-start space-x-3">
          <svg class="w-6 h-6 flex-shrink-0 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
          </svg>
          <div class="flex-1">
            <p class="font-semibold mb-1">ATTENTION</p>
            <p class="text-sm">
              Pour toute opération sensible (paiement, demande de documents,...)
              Veuillez toujours vérifier que vous êtes bien sur le site officiel de la Mairie de Port-Gentil
            </p>
          </div>
        </div>
      </div>

      <!-- Hero Section avec image de fond -->
      <section class="relative flex-1 min-h-[600px]">
        <!-- Image de fond floutée -->
        <div class="absolute inset-0 overflow-hidden">
            <img 
            src="/assets/hotel-de-ville.jpeg" 
            alt="Hôtel de ville de Port-Gentil"
            class="w-full h-full object-cover filter blur-sm scale-110"
          >
          <div class="absolute inset-0 bg-gradient-to-r from-blue-900/80 via-blue-800/70 to-transparent"></div>
        </div>

        <div class="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 h-full py-12">
          <div class="grid md:grid-cols-2 gap-8 items-center h-full">
            <!-- Section gauche - Texte -->
            <div class="text-white space-y-6 z-10">
              <!-- URL Bar -->
              <div class="flex items-center space-x-2 bg-white/20 backdrop-blur-sm rounded-lg px-4 py-2 w-fit">
                <div class="w-3 h-3 rounded-full bg-green-500"></div>
                <div class="w-3 h-3 rounded-full bg-yellow-500"></div>
                <div class="w-3 h-3 rounded-full bg-red-500"></div>
                <span class="ml-3 text-sm font-mono">portail-citoyen.mairie-libreville.ga</span>
              </div>

              <!-- Titre principal -->
              <div class="space-y-4">
                <h2 class="text-4xl md:text-5xl lg:text-6xl font-bold leading-tight">
                  Le portail de téléservices de<br>
                  la Mairie de<br>
                  Port-Gentil
                </h2>
                <p class="text-xl md:text-2xl text-blue-100 max-w-xl">
                  Accédez facilement aux services municipaux, effectuez vos démarches et payez vos taxes en ligne
                </p>
              </div>

              <!-- Logo DGI style -->
              <div class="flex items-center space-x-3 pt-4">
                <div class="bg-white/20 backdrop-blur-sm rounded-lg p-3">
                  <img src="/assets/logo_app.png" alt="Logo" class="h-12 w-12">
                </div>
                <div class="text-white">
                  <p class="font-bold text-lg">MAIRIE DE LIBREVILLE</p>
                  <p class="text-sm text-blue-100">Direction Générale des Services</p>
                </div>
              </div>
            </div>

            <!-- Section droite - Panneau de connexion -->
            <div class="z-10">
              <div class="bg-white rounded-2xl shadow-2xl p-8 max-w-md mx-auto">
                <div class="text-center mb-6">
                  <h3 class="text-2xl font-bold text-gray-900 mb-2">
                    Connectez-vous à votre espace
                  </h3>
                  <p class="text-gray-600 text-sm">
                    Sélectionnez l'espace auquel vous souhaitez accéder
                  </p>
                </div>

                <div class="space-y-4">
                  <!-- Bouton Espace Professionnel -->
                  <a
                    [routerLink]="['/login']"
                    class="flex items-center space-x-4 w-full px-6 py-4 bg-indigo-700 text-white rounded-xl hover:bg-indigo-800 transition-all transform hover:scale-105 shadow-lg"
                  >
                    <div class="bg-white/20 rounded-lg p-3">
                      <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z" />
                      </svg>
                    </div>
                    <span class="font-semibold text-lg">Espace Professionnel</span>
                  </a>

                  <!-- Bouton Espace Particulier -->
                  <a
                    [routerLink]="['/login']"
                    class="flex items-center space-x-4 w-full px-6 py-4 bg-indigo-700 text-white rounded-xl hover:bg-indigo-800 transition-all transform hover:scale-105 shadow-lg"
                  >
                    <div class="bg-white/20 rounded-lg p-3">
                      <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                      </svg>
                    </div>
                    <span class="font-semibold text-lg">Espace Particulier</span>
                  </a>

                  <!-- Bouton Découvrir les services -->
                  <a
                    [routerLink]="['/services']"
                    class="flex items-center justify-center space-x-2 w-full px-6 py-3 border-2 border-indigo-700 text-indigo-700 rounded-xl hover:bg-indigo-50 transition-all font-medium"
                  >
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                    </svg>
                    <span>Découvrir les services</span>
                  </a>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- Section d'aide -->
      <section class="bg-gradient-to-b from-blue-50 to-white py-16 relative">
        <div class="absolute inset-0 overflow-hidden">
          <img 
            src="/assets/hotel-de-ville.jpeg" 
            alt=""
            class="w-full h-full object-cover opacity-10 blur-xl"
          >
        </div>
        
        <div class="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="text-center mb-12">
            <h3 class="text-3xl md:text-4xl font-bold text-gray-900 mb-4">
              Vous avez des difficultés ?
            </h3>
            <p class="text-xl text-gray-600 mb-8">
              Téléchargez et consultez nos guides pour en savoir plus
            </p>
          </div>

          <div class="flex flex-col md:flex-row justify-center gap-4 max-w-2xl mx-auto">
            <button class="flex items-center justify-center space-x-3 px-8 py-4 bg-indigo-700 text-white rounded-full hover:bg-indigo-800 transition-all transform hover:scale-105 shadow-lg">
              <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 10v6m0 0l-3-3m3 3l3-3m2 8H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
              </svg>
              <span class="font-semibold">Guide de l'espace déconnecté</span>
            </button>

            <button class="flex items-center justify-center space-x-3 px-8 py-4 bg-indigo-700 text-white rounded-full hover:bg-indigo-800 transition-all transform hover:scale-105 shadow-lg">
              <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8.228 9c.549-1.165 2.03-2 3.772-2 2.21 0 4 1.343 4 3 0 1.4-1.278 2.575-3.006 2.907-.542.104-.994.54-.994 1.093m0 3h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
              <span class="font-semibold">Réponses aux questions fréquentes</span>
            </button>
          </div>
        </div>
      </section>

      <!-- Footer -->
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
export class AccueilComponent implements OnInit {
  services: Service[] = [];

  constructor(
    public authService: AuthService,
    private apiService: ApiService,
    private router: Router
  ) {}

  ngOnInit() {
    // Optionnel : charger les services pour d'autres sections
  }
}
