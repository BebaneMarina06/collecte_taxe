import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ApiService } from '../../../services/api.service';
import { DemandeCitoyen, StatutDemande } from '../../../interfaces/demande-citoyen.interface';
import { ContenerComponent } from '../../items/contener/contener.component';
import { ModalComponent } from '../../items/modal/modal.component';
import { PaginationComponent } from '../../items/pagination/pagination.component';
import { DemandeCitoyenDetailsComponent } from '../../items/modals/demande-citoyen-details/demande-citoyen-details.component';

@Component({
  selector: 'app-demandes-citoyens',
  standalone: true,
  imports: [
    CommonModule,
    FormsModule,
    ContenerComponent,
    ModalComponent,
    PaginationComponent,
    DemandeCitoyenDetailsComponent
  ],
  templateUrl: './demandes-citoyens.component.html',
  styleUrl: './demandes-citoyens.component.scss'
})
export class DemandesCitoyensComponent implements OnInit {
  private apiService = inject(ApiService);

  demandes: DemandeCitoyen[] = [];
  loading = false;
  error = '';

  // Filtres
  filters = {
    statut: '' as StatutDemande | '',
    contribuable_id: null as number | null,
    type_demande: '',
    searchTerm: ''
  };

  // Pagination
  currentPage = 1;
  pageSize = 20;
  totalItems = 0;
  totalPages = 1;

  // Modal
  activeModalDetails = false;
  selectedDemande: DemandeCitoyen | null = null;

  ngOnInit(): void {
    this.loadDemandes();
  }

  loadDemandes(): void {
    this.loading = true;
    this.error = '';

    const params: any = {
      skip: (this.currentPage - 1) * this.pageSize,
      limit: this.pageSize
    };

    if (this.filters.statut) {
      params.statut = this.filters.statut;
    }
    if (this.filters.contribuable_id) {
      params.contribuable_id = this.filters.contribuable_id;
    }

    this.apiService.getDemandesCitoyens(params).subscribe({
      next: (data: DemandeCitoyen[]) => {
        // Filtrer par type_demande et searchTerm côté client si nécessaire
        let filtered = data;
        
        if (this.filters.type_demande) {
          filtered = filtered.filter(d => 
            d.type_demande.toLowerCase().includes(this.filters.type_demande.toLowerCase())
          );
        }
        
        if (this.filters.searchTerm) {
          const term = this.filters.searchTerm.toLowerCase();
          filtered = filtered.filter(d =>
            d.sujet.toLowerCase().includes(term) ||
            d.description.toLowerCase().includes(term) ||
            (d.contribuable_nom && d.contribuable_nom.toLowerCase().includes(term)) ||
            (d.contribuable_prenom && d.contribuable_prenom.toLowerCase().includes(term))
          );
        }

        this.demandes = filtered;
        // Note: L'API devrait retourner le total, mais pour l'instant on utilise la longueur
        this.totalItems = filtered.length;
        this.totalPages = Math.ceil(this.totalItems / this.pageSize);
        this.loading = false;
      },
      error: (err) => {
        this.error = err.error?.detail || 'Erreur lors du chargement des demandes';
        this.loading = false;
      }
    });
  }

  applyFilters(): void {
    this.currentPage = 1;
    this.loadDemandes();
  }

  resetFilters(): void {
    this.filters = {
      statut: '',
      contribuable_id: null,
      type_demande: '',
      searchTerm: ''
    };
    this.currentPage = 1;
    this.loadDemandes();
  }

  onPageChange(page: number): void {
    this.currentPage = page;
    this.loadDemandes();
  }

  onPageSizeChange(size: number): void {
    this.pageSize = size;
    this.currentPage = 1;
    this.loadDemandes();
  }

  viewDetails(demande: DemandeCitoyen): void {
    this.selectedDemande = demande;
    this.activeModalDetails = true;
  }

  onActiveModalDetails(value: boolean): void {
    this.activeModalDetails = value;
    if (!value) {
      this.selectedDemande = null;
      this.loadDemandes(); // Recharger après modification
    }
  }

  getStatutLabel(statut: StatutDemande): string {
    const labels: { [key in StatutDemande]: string } = {
      'envoyee': 'Envoyée',
      'en_traitement': 'En traitement',
      'complete': 'Complète',
      'rejetee': 'Rejetée'
    };
    return labels[statut] || statut;
  }

  getStatutClass(statut: StatutDemande): string {
    const classes: { [key in StatutDemande]: string } = {
      'envoyee': 'statut-envoyee',
      'en_traitement': 'statut-en-traitement',
      'complete': 'statut-complete',
      'rejetee': 'statut-rejetee'
    };
    return classes[statut] || '';
  }

  getTypeDemandeLabel(type: string): string {
    const labels: { [key: string]: string } = {
      'changement_adresse': 'Changement d\'adresse',
      'modification_taxe': 'Modification de taxe',
      'reclamation': 'Réclamation',
      'question': 'Question',
      'autre': 'Autre'
    };
    return labels[type] || type;
  }

  formatDate(dateString: string | null | undefined): string {
    if (!dateString) return 'N/A';
    const date = new Date(dateString);
    return new Intl.DateTimeFormat('fr-FR', {
      day: '2-digit',
      month: '2-digit',
      year: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    }).format(date);
  }

  deleteDemande(demande: DemandeCitoyen): void {
    if (confirm(`Êtes-vous sûr de vouloir supprimer la demande "${demande.sujet}" ?`)) {
      this.apiService.deleteDemandeCitoyen(demande.id).subscribe({
        next: () => {
          this.loadDemandes();
        },
        error: (err) => {
          this.error = err.error?.detail || 'Erreur lors de la suppression';
          console.error('Erreur lors de la suppression:', err);
        }
      });
    }
  }
}

