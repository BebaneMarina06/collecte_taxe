import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ApiService } from '../../../services/api.service';
import { ContenerComponent } from '../../items/contener/contener.component';

@Component({
  selector: 'app-taxations',
  standalone: true,
  imports: [CommonModule, FormsModule, ContenerComponent],
  templateUrl: './taxations.component.html',
  styleUrls: ['./taxations.component.scss']
})
export class TaxationsComponent implements OnInit {
  taxations: any[] = [];
  contribuables: any[] = [];
  taxes: any[] = [];
  loading = false;
  error: string | null = null;
  searchTerm: string = '';

  // Filtres
  filters = {
    contribuable_id: null as number | null,
    taxe_id: null as number | null,
    statut: '',
    annee: new Date().getFullYear(),
    mois: null as number | null,
    en_retard: false,
    skip: 0,
    limit: 50
  };

  // Statistiques
  stats = {
    total_taxations: 0,
    taxations_payees: 0,
    taxations_impayees: 0,
    taxations_en_retard: 0,
    montant_total_attendu: 0,
    montant_total_paye: 0,
    montant_total_restant: 0,
    taux_recouvrement: 0
  };

  // Pagination
  currentPage = 1;
  itemsPerPage = 50;
  totalPages = 1;

  // Modal création
  showCreateModal = false;
  showViewModal = false;
  showCollectModal = false;
  selectedTaxation: any = null;
  createModalStep = 1; // Étape du formulaire (1, 2, 3)
  createForm = {
    contribuable_id: null as number | null,
    taxe_id: null as number | null,
    date_debut: '',
    date_fin: '',
    annee: new Date().getFullYear(),
    mois: null as number | null,
    montant_custom: null as number | null,
    date_echeance: ''
  };

  constructor(private apiService: ApiService) {}

  ngOnInit(): void {
    this.loadContribuables();
    this.loadTaxes();
    this.loadTaxations();
    this.loadStats();
  }

  loadContribuables(): void {
    this.apiService.getContribuables({ actif: true }).subscribe({
      next: (data) => {
        this.contribuables = data;
      },
      error: (err) => {
        console.error('Erreur chargement contribuables:', err);
      }
    });
  }

  loadTaxes(): void {
    this.apiService.getTaxes({ actif: true }).subscribe({
      next: (data) => {
        this.taxes = data;
      },
      error: (err) => {
        console.error('Erreur chargement taxes:', err);
      }
    });
  }

  loadTaxations(): void {
    this.loading = true;
    this.error = null;

    // Construire les filtres
    const filterParams: any = {
      skip: this.filters.skip,
      limit: this.filters.limit,
      include_relations: true  // Ajouter ce paramètre pour charger les relations
    };

    if (this.filters.contribuable_id) filterParams.contribuable_id = this.filters.contribuable_id;
    if (this.filters.taxe_id) filterParams.taxe_id = this.filters.taxe_id;
    if (this.filters.statut) filterParams.statut = this.filters.statut;
    if (this.filters.annee) filterParams.annee = this.filters.annee;
    if (this.filters.mois) filterParams.mois = this.filters.mois;
    if (this.filters.en_retard) filterParams.en_retard = true;

    this.apiService.getTaxations(filterParams).subscribe({
      next: (data) => {
        console.log('Données reçues:', data);
        console.log('Première taxation:', data[0]);
        this.taxations = data;
        this.totalPages = Math.ceil(this.taxations.length / this.itemsPerPage);
        this.loading = false;
      },
      error: (err) => {
        console.error('Erreur chargement taxations:', err);
        this.error = 'Erreur lors du chargement des taxations';
        this.loading = false;
      }
    });
  }

  loadStats(): void {
    this.apiService.getTaxationStats().subscribe({
      next: (data) => {
        this.stats = data;
      },
      error: (err) => {
        console.error('Erreur chargement stats:', err);
      }
    });
  }

  applyFilters(): void {
    this.filters.skip = 0;
    this.currentPage = 1;
    this.loadTaxations();
    this.loadStats();
  }

  resetFilters(): void {
    this.filters = {
      contribuable_id: null,
      taxe_id: null,
      statut: '',
      annee: new Date().getFullYear(),
      mois: null,
      en_retard: false,
      skip: 0,
      limit: 50
    };
    this.applyFilters();
  }

  onSearch(): void {
    this.loadTaxations();
  }

  previousPage(): void {
    if (this.currentPage > 1) {
      this.currentPage--;
      this.filters.skip = (this.currentPage - 1) * this.itemsPerPage;
      this.loadTaxations();
    }
  }

  nextPage(): void {
    if (this.currentPage < this.totalPages) {
      this.currentPage++;
      this.filters.skip = (this.currentPage - 1) * this.itemsPerPage;
      this.loadTaxations();
    }
  }

  getStatusClass(statut: string): string {
    const s = statut?.toLowerCase();
    switch (s) {
      case 'paye':
      case 'payee':
        return 'bg-green-100 text-green-800';
      case 'impaye':
      case 'impayee':
        return 'bg-red-100 text-red-800';
      case 'partiel':
      case 'partiellement_payee':
        return 'bg-yellow-100 text-yellow-800';
      case 'en_retard':
        return 'bg-orange-100 text-orange-800';
      default:
        return 'bg-gray-100 text-gray-800';
    }
  }

  getStatusLabel(statut: string): string {
    const s = statut?.toLowerCase();
    switch (s) {
      case 'paye':
      case 'payee':
        return 'Payé';
      case 'impaye':
      case 'impayee':
        return 'Impayé';
      case 'partiel':
      case 'partiellement_payee':
        return 'Partiel';
      case 'en_retard':
        return 'En retard';
      default:
        return statut || 'Inconnu';
    }
  }

  formatPeriode(taxation: any): string {
    if (taxation.mois) {
      const mois = taxation.mois.toString().padStart(2, '0');
      return `${mois}/${taxation.annee}`;
    }
    return taxation.annee.toString();
  }

  formatMontant(montant: number): string {
    return new Intl.NumberFormat('fr-FR').format(montant);
  }

  openCreateModal(): void {
    this.showCreateModal = true;
    this.createModalStep = 1;
    this.resetCreateForm();
  }

  closeCreateModal(): void {
    this.showCreateModal = false;
    this.createModalStep = 1;
    this.resetCreateForm();
  }

  nextStep(): void {
    if (this.createModalStep < 3) {
      this.createModalStep++;
    }
  }

  previousStep(): void {
    if (this.createModalStep > 1) {
      this.createModalStep--;
    }
  }

  resetCreateForm(): void {
    this.createForm = {
      contribuable_id: null,
      taxe_id: null,
      date_debut: '',
      date_fin: '',
      annee: new Date().getFullYear(),
      mois: null,
      montant_custom: null,
      date_echeance: ''
    };
  }

  createTaxation(): void {
    if (!this.createForm.contribuable_id || !this.createForm.taxe_id || 
        !this.createForm.date_debut || !this.createForm.date_fin || 
        !this.createForm.annee) {
      alert('Veuillez remplir tous les champs obligatoires');
      return;
    }

    const payload: any = {
      contribuable_id: this.createForm.contribuable_id,
      taxe_id: this.createForm.taxe_id,
      periode: {
        debut: this.createForm.date_debut,
        fin: this.createForm.date_fin
      },
      annee: this.createForm.annee
    };

    if (this.createForm.mois) payload.mois = this.createForm.mois;
    if (this.createForm.montant_custom) payload.montant_custom = this.createForm.montant_custom;
    if (this.createForm.date_echeance) payload.date_echeance = this.createForm.date_echeance;

    this.loading = true;

    this.apiService.createTaxation(payload).subscribe({
      next: () => {
        alert('Taxation créée avec succès');
        this.closeCreateModal();
        this.loadTaxations();
        this.loadStats();
        this.loading = false;
      },
      error: (err) => {
        console.error('Erreur création taxation:', err);
        alert('Erreur lors de la création: ' + (err.error?.detail || 'Erreur inconnue'));
        this.loading = false;
      }
    });
  }

  deleteTaxation(id: number): void {
    if (!confirm('Êtes-vous sûr de vouloir supprimer cette taxation ?')) {
      return;
    }

    this.apiService.deleteTaxation(id).subscribe({
      next: () => {
        alert('Taxation supprimée avec succès');
        this.loadTaxations();
        this.loadStats();
      },
      error: (err) => {
        console.error('Erreur suppression taxation:', err);
        alert('Erreur lors de la suppression');
      }
    });
  }

  navigateToCollecte(taxation: any): void {
    // TODO: Implémenter la navigation vers la création de collecte
    console.log('Créer collecte pour taxation:', taxation);
  }

  viewTaxation(taxation: any): void {
    this.selectedTaxation = taxation;
    this.showViewModal = true;
  }

  collectTaxation(taxation: any): void {
    this.selectedTaxation = taxation;
    this.showCollectModal = true;
  }

  closeViewModal(): void {
    this.showViewModal = false;
    this.selectedTaxation = null;
  }

  closeCollectModal(): void {
    this.showCollectModal = false;
    this.selectedTaxation = null;
  }

  getMoisOptions(): { value: number; label: string }[] {
    return [
      { value: 1, label: 'Janvier' },
      { value: 2, label: 'Février' },
      { value: 3, label: 'Mars' },
      { value: 4, label: 'Avril' },
      { value: 5, label: 'Mai' },
      { value: 6, label: 'Juin' },
      { value: 7, label: 'Juillet' },
      { value: 8, label: 'Août' },
      { value: 9, label: 'Septembre' },
      { value: 10, label: 'Octobre' },
      { value: 11, label: 'Novembre' },
      { value: 12, label: 'Décembre' }
    ];
  }

  // Méthodes helper pour le template
  getContribuableById(id: number | null): any {
    if (!id) return null;
    return this.contribuables.find(c => c.id === id);
  }

  getTaxeById(id: number | null): any {
    if (!id) return null;
    return this.taxes.find(t => t.id === id);
  }
}
