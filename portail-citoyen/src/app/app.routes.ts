import { Routes } from '@angular/router';
import { authGuard } from './guards/auth.guard';

export const routes: Routes = [
  {
    path: '',
    loadComponent: () => import('./pages/accueil/accueil.component').then(m => m.AccueilComponent),
    title: 'Accueil - Portail Citoyen'
  },
  {
    path: 'login',
    loadComponent: () => import('./pages/login/login.component').then(m => m.LoginComponent),
    title: 'Connexion'
  },
  {
    path: 'services',
    loadComponent: () => import('./pages/services/services.component').then(m => m.ServicesComponent),
    title: 'Services de la Mairie'
  },
  {
    path: 'dashboard',
    loadComponent: () => import('./pages/dashboard/dashboard.component').then(m => m.DashboardComponent),
    canActivate: [authGuard],
    title: 'Mon Espace'
  },
  {
    path: 'demandes',
    loadComponent: () => import('./pages/demandes/demandes.component').then(m => m.DemandesComponent),
    canActivate: [authGuard],
    title: 'Mes Demandes'
  },
  {
    path: 'demandes/nouvelle',
    loadComponent: () => import('./pages/nouvelle-demande/nouvelle-demande.component').then(m => m.NouvelleDemandeComponent),
    canActivate: [authGuard],
    title: 'Nouvelle Demande'
  },
  {
    path: 'taxes',
    loadComponent: () => import('./pages/taxes/taxes.component').then(m => m.TaxesComponent),
    canActivate: [authGuard],
    title: 'Mes Taxes'
  },
  {
    path: 'paiement/:taxeId',
    loadComponent: () => import('./pages/paiement/paiement.component').then(m => m.PaiementComponent),
    canActivate: [authGuard],
    title: 'Paiement en ligne'
  },
  {
    path: '**',
    redirectTo: ''
  }
];

