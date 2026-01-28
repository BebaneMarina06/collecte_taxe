/**
 * EXEMPLE D'INTÉGRATION - Responsive et Zoom
 * Ce fichier montre comment utiliser le service ResponsiveService
 * dans vos composants Angular
 */

// ==================== EXEMPLE 1: Layout Principal ====================

import { Component, OnInit } from '@angular/core';
import { ResponsiveService } from '../services/responsive.service';
import { CommonModule } from '@angular/common';
import { ResponsiveDebuggerComponent } from '../components/responsive-debugger/responsive-debugger.component';

@Component({
  selector: 'app-main-layout',
  standalone: true,
  imports: [CommonModule, ResponsiveDebuggerComponent],
  template: `
    <div class="layout-container">
      <!-- Header -->
      <header class="app-header" [class.header-mobile]="responsiveService.isMobile()">
        <div class="header-content">
          <h1>Collecte Taxe</h1>
          <nav class="main-nav" [class.hide-mobile]="responsiveService.isMobile()">
            <!-- Navigation desktop -->
          </nav>
        </div>
      </header>

      <!-- Main Content -->
      <main class="main-content">
        <div class="content-wrapper responsive-container">
          <!-- Votre contenu ici -->
        </div>
      </main>

      <!-- Debugger en développement -->
      <app-responsive-debugger></app-responsive-debugger>
    </div>
  `,
  styles: [`
    .layout-container {
      display: flex;
      flex-direction: column;
      height: 100vh;
      width: 100%;
    }

    .app-header {
      padding: 1rem;
      background: white;
      border-bottom: 1px solid #e2e8f0;
      
      @media (max-width: 768px) {
        padding: 0.75rem;
      }
    }

    .header-mobile {
      padding: 0.5rem;
    }

    .main-content {
      flex: 1;
      overflow-y: auto;
      padding: 1.5rem;
      
      @media (max-width: 768px) {
        padding: 1rem;
      }
      
      @media (max-width: 480px) {
        padding: 0.75rem;
      }
    }
  `]
})
export class MainLayoutComponent {
  constructor(public responsiveService: ResponsiveService) {}
}


// ==================== EXEMPLE 2: Tableau Responsive ====================

@Component({
  selector: 'app-data-table',
  standalone: true,
  imports: [CommonModule],
  template: `
    <div class="table-wrapper">
      <!-- Vue desktop avec tableau complet -->
      <table *ngIf="!responsiveService.isMobile()" class="data-table">
        <thead>
          <tr>
            <th>ID</th>
            <th>Nom</th>
            <th>Email</th>
            <th>Montant</th>
            <th>Statut</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr *ngFor="let item of items">
            <td>{{ item.id }}</td>
            <td>{{ item.name }}</td>
            <td>{{ item.email }}</td>
            <td>{{ item.amount | currency }}</td>
            <td>
              <span [class.status-badge]="true" 
                    [class.active]="item.status === 'active'">
                {{ item.status }}
              </span>
            </td>
            <td>
              <button class="btn-small">Détails</button>
            </td>
          </tr>
        </tbody>
      </table>

      <!-- Vue mobile avec cartes -->
      <div *ngIf="responsiveService.isMobile()" class="card-list">
        <div *ngFor="let item of items" class="item-card">
          <div class="card-header">
            <h3>{{ item.name }}</h3>
            <span [class.status-badge]="true" 
                  [class.active]="item.status === 'active'">
              {{ item.status }}
            </span>
          </div>
          <div class="card-body">
            <div class="card-row">
              <label>ID:</label>
              <span>{{ item.id }}</span>
            </div>
            <div class="card-row">
              <label>Email:</label>
              <span>{{ item.email }}</span>
            </div>
            <div class="card-row">
              <label>Montant:</label>
              <span>{{ item.amount | currency }}</span>
            </div>
          </div>
          <div class="card-footer">
            <button class="btn-primary">Détails</button>
          </div>
        </div>
      </div>
    </div>
  `,
  styles: [`
    .data-table {
      width: 100%;
      font-size: 0.875rem;
    }

    .table-wrapper {
      overflow-x: auto;
    }

    /* Vue mobile */
    .card-list {
      display: grid;
      gap: 1rem;
      
      @media (max-width: 480px) {
        gap: 0.75rem;
      }
    }

    .item-card {
      border: 1px solid #e2e8f0;
      border-radius: 8px;
      background: white;
      overflow: hidden;
    }

    .card-header {
      padding: 1rem;
      border-bottom: 1px solid #f1f5f9;
      display: flex;
      justify-content: space-between;
      align-items: center;
      
      h3 {
        margin: 0;
        font-size: 1rem;
      }
    }

    .card-body {
      padding: 1rem;
    }

    .card-row {
      display: flex;
      justify-content: space-between;
      padding: 0.5rem 0;
      font-size: 0.875rem;
      
      label {
        font-weight: 600;
        color: #64748b;
      }
    }

    .card-footer {
      padding: 1rem;
      border-top: 1px solid #f1f5f9;
      display: flex;
      gap: 0.5rem;
    }
  `]
})
export class DataTableComponent {
  items = [
    { id: 1, name: 'John Doe', email: 'john@example.com', amount: 1500, status: 'active' },
    { id: 2, name: 'Jane Smith', email: 'jane@example.com', amount: 2000, status: 'pending' }
  ];

  constructor(public responsiveService: ResponsiveService) {}
}


// ==================== EXEMPLE 3: Grille Responsive ====================

@Component({
  selector: 'app-responsive-grid',
  standalone: true,
  template: `
    <div class="grid-container" [class.grid-1col]="responsiveService.isMobile()"
                                 [class.grid-2col]="responsiveService.isTablet()"
                                 [class.grid-3col]="responsiveService.isDesktop()">
      <div *ngFor="let item of items" class="grid-item">
        {{ item }}
      </div>
    </div>
  `,
  styles: [`
    .grid-container {
      display: grid;
      gap: 1.5rem;
      padding: 1.5rem;
    }

    .grid-1col {
      grid-template-columns: 1fr;
    }

    .grid-2col {
      grid-template-columns: repeat(2, 1fr);
    }

    .grid-3col {
      grid-template-columns: repeat(3, 1fr);
    }

    .grid-item {
      padding: 1.5rem;
      background: white;
      border: 1px solid #e2e8f0;
      border-radius: 8px;
    }
  `]
})
export class ResponsiveGridComponent {
  items = Array.from({ length: 12 }, (_, i) => `Item ${i + 1}`);

  constructor(public responsiveService: ResponsiveService) {}
}


// ==================== EXEMPLE 4: Sidebars Adaptables ====================

@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [CommonModule],
  template: `
    <div class="dashboard-wrapper">
      <!-- Sidebar desktop uniquement -->
      <aside class="sidebar" *ngIf="!responsiveService.isMobile()">
        <nav class="sidebar-nav">
          <a href="#" class="nav-item active">Dashboard</a>
          <a href="#" class="nav-item">Utilisateurs</a>
          <a href="#" class="nav-item">Rapports</a>
          <a href="#" class="nav-item">Paramètres</a>
        </nav>
      </aside>

      <!-- Contenu principal -->
      <main class="main-content">
        <div class="content-inner">
          <!-- Votre contenu principal -->
        </div>
      </main>
    </div>
  `,
  styles: [`
    .dashboard-wrapper {
      display: flex;
      gap: 0;
      height: 100%;
    }

    .sidebar {
      width: 250px;
      background: #f8fafc;
      border-right: 1px solid #e2e8f0;
      padding: 1.5rem 1rem;
      overflow-y: auto;
      
      @media (max-width: 1024px) {
        width: 200px;
      }
    }

    .main-content {
      flex: 1;
      overflow-y: auto;
      padding: 1.5rem;
    }

    .nav-item {
      display: block;
      padding: 0.75rem 1rem;
      color: #64748b;
      text-decoration: none;
      border-radius: 6px;
      margin-bottom: 0.5rem;
      transition: all 0.2s ease;

      &:hover {
        background: white;
        color: #1e293b;
      }

      &.active {
        background: white;
        color: #0084ff;
        font-weight: 600;
      }
    }
  `]
})
export class DashboardComponent {
  constructor(public responsiveService: ResponsiveService) {}
}


// ==================== EXEMPLE 5: Composant Réactif Avancé ====================

@Component({
  selector: 'app-advanced-responsive',
  standalone: true,
  imports: [CommonModule],
  template: `
    <div class="container">
      <div class="info-box">
        <h2>État Actuel</h2>
        <p>Device: <strong>{{ responsiveService.deviceType() }}</strong></p>
        <p>Zoom: <strong>{{ (responsiveService.currentZoom() * 100) | number: '1.0-0' }}%</strong></p>
        <p>Largeur: <strong>{{ responsiveService.windowWidth() }}px</strong></p>
        <p>Est Mobile: <strong>{{ responsiveService.isMobile() ? 'Oui' : 'Non' }}</strong></p>
      </div>

      <!-- Contenu adapté au device -->
      <div *ngIf="responsiveService.isDesktop()" class="desktop-view">
        <h3>Vue Desktop - Affichage complet</h3>
        <p>Sur desktop, on peut afficher plus d'informations et utiliser plus d'espace.</p>
      </div>

      <div *ngIf="responsiveService.isMobile()" class="mobile-view">
        <h3>Vue Mobile - Affichage simplifié</h3>
        <p>Sur mobile, on affiche l'essentiel pour optimiser l'expérience.</p>
      </div>

      <div *ngIf="responsiveService.isTablet()" class="tablet-view">
        <h3>Vue Tablette - Affichage intermédiaire</h3>
        <p>Sur tablette, c'est entre mobile et desktop.</p>
      </div>
    </div>
  `
})
export class AdvancedResponsiveComponent {
  constructor(public responsiveService: ResponsiveService) {}
}

/**
 * RÉSUMÉ RAPIDE:
 * 
 * 1. Importer ResponsiveService
 * 2. L'injecter dans le constructeur
 * 3. Utiliser les signaux réactifs:
 *    - responsiveService.deviceType()
 *    - responsiveService.isMobile()
 *    - responsiveService.isTablet()
 *    - responsiveService.isDesktop()
 *    - responsiveService.currentZoom()
 *    - responsiveService.windowWidth()
 *    - responsiveService.windowHeight()
 * 4. Le zoom s'applique automatiquement sans action
 * 5. Utiliser [ngIf] pour afficher du contenu différent par device
 */
