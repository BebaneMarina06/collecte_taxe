import { Component, OnInit, inject } from '@angular/core';
import { ApiService } from '../../../services/api.service';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { PaginationComponent } from '../../items/pagination/pagination.component';
import { Taxe } from '../../../interfaces/taxe.interface';
import { TaxePaiementStatistiquesResponse } from '../../../interfaces/taxe-paiement-statistiques.interface';
import { ModalComponent } from '../../items/modal/modal.component';
import { CreateTaxeComponent } from '../../items/modals/create-taxe/create-taxe.component';
import { DetailsTaxesComponent } from '../../items/modals/details-taxes/details-taxes.component';
import { DecimalPipe } from '@angular/common';

@Component({
  selector: 'app-taxes',
  imports: [
    CommonModule, 
    FormsModule, 
    PaginationComponent, 
    ModalComponent, 
    CreateTaxeComponent, 
    DetailsTaxesComponent, 
    DecimalPipe
  ],
  standalone: true,
  templateUrl: './taxes.component.html',
  styleUrl: './taxes.component.scss'
})
export class TaxesComponent implements OnInit {
  private apiService = inject(ApiService);
  
  // Gestion des onglets
  activeTab: 'liste' | 'stats' = 'liste';
  
  // Données des taxes
  taxes: Taxe[] = [];
  allTaxes: Taxe[] = []; // Pour le filtrage côté client
  
  // États de chargement
  loading: boolean = true;
  loadingStats: boolean = false;
  
  // Recherche et filtres
  searchTerm: string = '';
  
  // Modales
  activeModal: boolean = false;
  activeModalEdit: boolean = false;
  activeModalDetails: boolean = false;
  selectedTaxe: Taxe | null = null;
  
  // Pagination
  currentPage: number = 1;
  pageSize: number = 20;
  totalItems: number = 0;
  totalPages: number = 1;

  // Statistiques de paiements
  paiementStats: TaxePaiementStatistiquesResponse | null = null;

  ngOnInit(): void {
    this.loadTaxes();
    this.loadPaiementStats();
  }

  /**
   * Charge toutes les taxes depuis l'API
   */
  loadTaxes(): void {
    this.loading = true;
    const params: any = { 
      limit: 1000  // Charger toutes les taxes pour le filtrage côté client
    };
    
    this.apiService.getTaxes(params).subscribe({
      next: (data: Taxe[]) => {
        this.allTaxes = data;
        this.totalItems = data.length;
        this.applyFilters();
        this.loading = false;
      },
      error: (err) => {
        console.error('Erreur lors du chargement des taxes:', err);
        this.loading = false;
      }
    });
  }

  /**
   * Applique les filtres de recherche et la pagination
   */
  applyFilters(): void {
    let filtered = this.allTaxes;
    
    // Filtrage par terme de recherche
    if (this.searchTerm) {
      const term = this.searchTerm.toLowerCase();
      filtered = filtered.filter(t => 
        t.nom.toLowerCase().includes(term) ||
        t.code.toLowerCase().includes(term) ||
        (t.description && t.description.toLowerCase().includes(term))
      );
    }
    
    // Tri par date de création (plus récent d'abord)
    filtered = filtered.sort((a, b) => {
      const dateA = a.created_at ? new Date(a.created_at).getTime() : (a.id || 0);
      const dateB = b.created_at ? new Date(b.created_at).getTime() : (b.id || 0);
      return dateB - dateA;
    });
    
    // Calcul de la pagination
    this.totalItems = filtered.length;
    this.totalPages = Math.ceil(this.totalItems / this.pageSize);
    
    // Application de la pagination
    const startIndex = (this.currentPage - 1) * this.pageSize;
    const endIndex = startIndex + this.pageSize;
    this.taxes = filtered.slice(startIndex, endIndex);
  }

  /**
   * Déclenche une recherche
   */
  onSearch(): void {
    this.currentPage = 1;
    this.applyFilters();
  }

  /**
   * Change de page
   */
  onPageChange(page: number): void {
    this.currentPage = page;
    this.applyFilters();
  }

  /**
   * Change la taille de page
   */
  onPageSizeChange(size: number): void {
    this.pageSize = size;
    this.currentPage = 1;
    this.applyFilters();
  }

  /**
   * Charge les statistiques de paiement
   */
  loadPaiementStats(): void {
    this.loadingStats = true;
    this.apiService.getTaxesPaiementsStatistiques().subscribe({
      next: (data) => {
        this.paiementStats = data;
        this.loadingStats = false;
      },
      error: (err) => {
        console.error('Erreur lors du chargement des statistiques de paiements:', err);
        this.loadingStats = false;
      }
    });
  }

  /**
   * Gère l'ouverture/fermeture de la modale de création
   */
  onActiveModal(value: boolean): void {
    this.activeModal = value;
    if (!value) {
      this.loadTaxes();
      this.loadPaiementStats(); // Recharger les stats après modification
    }
  }

  /**
   * Gère l'ouverture/fermeture de la modale de détails
   */
  onActiveModalDetails(value: boolean, taxe?: Taxe): void {
    this.selectedTaxe = taxe || null;
    this.activeModalDetails = value;
  }

  /**
   * Affiche les détails d'une taxe
   */
  viewDetails(taxe: Taxe): void {
    this.selectedTaxe = taxe;
    this.activeModalDetails = true;
  }

  /**
   * Gère l'ouverture/fermeture de la modale d'édition
   */
  onActiveModalEdit(value: boolean): void {
    this.activeModalEdit = value;
    if (!value) {
      this.selectedTaxe = null;
      this.loadTaxes();
      this.loadPaiementStats(); // Recharger les stats après modification
    }
  }

  /**
   * Ouvre la modale d'édition pour une taxe
   */
  editTaxe(taxe: Taxe): void {
    this.selectedTaxe = taxe;
    this.activeModalEdit = true;
  }

  /**
   * Active/désactive une taxe
   */
  toggleActif(taxe: Taxe): void {
    this.apiService.updateTaxe(taxe.id, { actif: !taxe.actif }).subscribe({
      next: () => {
        this.loadTaxes();
        this.loadPaiementStats();
      },
      error: (err) => {
        console.error('Erreur lors de la mise à jour:', err);
        alert('Erreur lors de la mise à jour de la taxe');
      }
    });
  }

  /**
   * Supprime une taxe
   */
  deleteTaxe(taxe: Taxe): void {
    if (confirm(`Êtes-vous sûr de vouloir supprimer la taxe "${taxe.nom}" ?\n\nCette action est irréversible.`)) {
      this.apiService.deleteTaxe(taxe.id).subscribe({
        next: () => {
          this.loadTaxes();
          this.loadPaiementStats();
          alert('Taxe supprimée avec succès');
        },
        error: (err) => {
          console.error('Erreur lors de la suppression:', err);
          alert('Erreur lors de la suppression de la taxe');
        }
      });
    }
  }

  /**
   * Retourne le libellé de la périodicité
   */
  getPeriodiciteLabel(periodicite: string): string {
    const labels: { [key: string]: string } = {
      'journaliere': 'Journalière',
      'hebdomadaire': 'Hebdomadaire',
      'mensuelle': 'Mensuelle',
      'trimestrielle': 'Trimestrielle',
      'semestrielle': 'Semestrielle',
      'annuelle': 'Annuelle',
      'ponctuelle': 'Ponctuelle'
    };
    return labels[periodicite] || periodicite;
  }

  /**
   * Formate un nombre
   */
  formatNumber(value: number): string {
    if (isNaN(value) || value === null || value === undefined) {
      return '0';
    }
    return new Intl.NumberFormat('fr-FR', {
      minimumFractionDigits: 0,
      maximumFractionDigits: 0
    }).format(value);
  }

  /**
   * Formate un montant en devise FCFA
   */
  formatCurrency(amount: number): string {
    if (amount === null || amount === undefined || isNaN(amount)) {
      return '0 FCFA';
    }
    return new Intl.NumberFormat('fr-FR', {
      style: 'currency',
      currency: 'XAF',
      minimumFractionDigits: 0
    }).format(amount);
  }

  /**
   * Change l'onglet actif
   */
  switchTab(tab: 'liste' | 'stats'): void {
    this.activeTab = tab;
  }
}