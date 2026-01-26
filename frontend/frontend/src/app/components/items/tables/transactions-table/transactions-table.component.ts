import {Component, model, ModelSignal, OnInit, OnDestroy, inject} from '@angular/core';
import {BadgeComponent} from '../../badge/badge.component';
import {PaginationComponent} from '../../pagination/pagination.component';
import {dateFormater, hiddenLetters, parseMount} from '../../../../utils/utils';
import {dates, paiementLogo, statusBilling} from '../../../../utils/seeder';
import {ApiService} from '../../../../services/api.service';
import {SyncService} from '../../../../services/sync.service';
import {CommonModule} from '@angular/common';
import {Collecte} from '../../../../interfaces/collecte.interface';
import {Subscription} from 'rxjs';
import {HttpErrorResponse} from '@angular/common/http';

@Component({
  selector: 'app-transactions-table',
  imports: [
    BadgeComponent,
    CommonModule,
    PaginationComponent
  ],
  standalone : true,
  templateUrl: './transactions-table.component.html',
  styleUrl: './transactions-table.component.scss'
})
export class TransactionsTableComponent implements OnInit, OnDestroy {
  activeModalItem : ModelSignal<boolean> = model<boolean>(false);
  private apiService = inject(ApiService);
  private syncService = inject(SyncService);
  private syncSubscription?: Subscription;
  
  collectes: Collecte[] = [];
  loading: boolean = true;
  selectedCollecte: Collecte | null = null;
  errorMessage: string = '';
  
  // Pagination
  currentPage: number = 1;
  pageSize: number = 20;
  totalItems: number = 0;
  totalPages: number = 1;

  // Filtres
  filters: any = {
    telephone: '',
    dateDebut: '',
    dateFin: '',
    statut: '',
    collecteur_id: undefined,
    contribuable_id: undefined,
    taxe_id: undefined
  };

  protected readonly hiddenLetters = hiddenLetters;
  protected readonly dateFormater = dateFormater;
  protected readonly dates = dates;
  protected readonly Math = Math;
  protected readonly parseMount = parseMount;
  protected readonly paiementLogo = paiementLogo;
  protected readonly statusBilling = statusBilling;

  ngOnInit(): void {
    this.loadCollectes();
    this.syncSubscription = this.syncService.sync$.subscribe(() => {
      this.loadCollectes();
    });
  }

  ngOnDestroy(): void {
    if (this.syncSubscription) {
      this.syncSubscription.unsubscribe();
    }
  }

  loadCollectes(): void {
    this.loading = true;
    const params: any = {
      skip: (this.currentPage - 1) * this.pageSize,
      limit: this.pageSize,
      order_by: '-date_collecte'
    };

    if (this.filters.statut) {
      params.statut = this.filters.statut;
    }
    if (this.filters.dateDebut) {
      params.date_debut = this.filters.dateDebut;
    }
    if (this.filters.dateFin) {
      params.date_fin = this.filters.dateFin;
    }
    if (this.filters.telephone) {
      params.telephone = this.filters.telephone;
    }
    if (this.filters.collecteur_id) {
      params.collecteur_id = this.filters.collecteur_id;
    }
    if (this.filters.contribuable_id) {
      params.contribuable_id = this.filters.contribuable_id;
    }
    if (this.filters.taxe_id) {
      params.taxe_id = this.filters.taxe_id;
    }

    this.apiService.getCollectes(params).subscribe({
      next: (data: Collecte[]) => {
        this.collectes = data;
        this.totalItems = data.length === this.pageSize ? (this.currentPage * this.pageSize) + 1 : (this.currentPage - 1) * this.pageSize + data.length;
        this.totalPages = Math.ceil(this.totalItems / this.pageSize);
        this.loading = false;
      },
      error: (err: HttpErrorResponse) => {
        console.error('Erreur lors du chargement des collectes:', err);

        if (err.error?.message === 'CORS_REDIRECT_ERROR') {
          console.warn('Collectes non disponibles à cause des redirections CORS Render');
          this.collectes = [];
          this.errorMessage = 'Les données de collectes ne peuvent pas être chargées actuellement en raison de restrictions techniques.';
        }

        this.loading = false;
      }
    });
  }

  // Obtenir le badge CSS du statut
  getStatutBadgeClass(statut: string): string {
    const classes = {
      'pending': 'bg-yellow-100 text-yellow-800',
      'completed': 'bg-green-100 text-green-800',
      'failed': 'bg-red-100 text-red-800',
      'cancelled': 'bg-gray-100 text-gray-800'
    };
    return classes[statut as keyof typeof classes] || 'bg-gray-100 text-gray-800';
  }

  // Obtenir le texte français du statut
  getStatutText(statut: string): string {
    const texts = {
      'pending': 'En cours',
      'completed': 'Validée',
      'failed': 'Échouée',
      'cancelled': 'Annulée'
    };
    return texts[statut as keyof typeof texts] || statut;
  }

  // Obtenir l'icône du statut
  getStatutIcon(statut: string): string {
    const icons = {
      'pending': '⏳',
      'completed': '✓',
      'failed': '✗',
      'cancelled': '🚫'
    };
    return icons[statut as keyof typeof icons] || '•';
  }

  // Valider une collecte
  validerCollecte(collecte: any): void {
    if (!confirm(`Valider la collecte ${collecte.reference} ?`)) {
      return;
    }

    this.apiService.validerCollecte(collecte.id).subscribe({
      next: () => {
        console.log('✅ Collecte validée');
        this.loadCollectes();
      },
      error: (err: HttpErrorResponse) => {
        console.error('❌ Erreur validation:', err);
        alert('Erreur lors de la validation');
      }
    });
  }

  // Annuler une collecte
  annulerCollecte(collecte: any): void {
    const raison = prompt('Raison de l\'annulation :');
    
    if (!raison || raison.trim().length < 3) {
      alert('La raison d\'annulation doit contenir au moins 3 caractères');
      return;
    }

    this.apiService.annulerCollecte(collecte.id, raison).subscribe({
      next: () => {
        console.log('✅ Collecte annulée');
        this.loadCollectes();
      },
      error: (err: HttpErrorResponse) => {
        console.error('❌ Erreur annulation:', err);
        alert('Erreur lors de l\'annulation');
      }
    });
  }

  // Formater le montant avec gestion des undefined
  formatMontant(montant: any, commission?: any): string {
    const m = Number(montant) || 0;
    const c = Number(commission) || 0;
    
    if (c > 0) {
      return `${m.toLocaleString('fr-FR')} XAF (Commission: ${c.toLocaleString('fr-FR')} XAF)`;
    }
    
    return `${m.toLocaleString('fr-FR')} XAF`;
  }

  applyFilters(filters: any): void {
    this.filters = { ...filters };
    this.currentPage = 1;
    this.loadCollectes();
  }

  onPageChange(page: number): void {
    this.currentPage = page;
    this.loadCollectes();
  }

  onPageSizeChange(size: number): void {
    this.pageSize = size;
    this.currentPage = 1;
    this.loadCollectes();
  }

  onActiveModalItem(active : boolean, collecte?: Collecte) {
    if (collecte) {
      this.selectedCollecte = collecte;
    }
    this.activeModalItem.set(active);
  }
  
  getSelectedCollecte(): Collecte | null {
    return this.selectedCollecte;
  }

  getStatusBadgeClass(statut: string): string {
    switch(statut) {
      case 'completed':
      case 'validee':
        return 'bg-green-100 text-green-800';
      case 'pending':
        return 'bg-yellow-100 text-yellow-800';
      case 'cancelled':
        return 'bg-red-100 text-red-800';
      case 'failed':
        return 'bg-red-100 text-red-800';
      default:
        return 'bg-gray-100 text-gray-800';
    }
  }

  getTimeFromDate(dateStr: string): string {
    if (!dateStr) return '';
    const date = new Date(dateStr);
    return date.toLocaleTimeString('fr-FR', {hour: '2-digit', minute: '2-digit'});
  }

  getCollecteLocation(collecte: Collecte): {
    latitude: number;
    longitude: number;
    accuracy?: number;
    source: 'collecte' | 'contribuable';
  } | null {
    const collecteLocation = collecte.location;
    if (
      collecteLocation &&
      this.isValidCoordinate(collecteLocation.latitude) &&
      this.isValidCoordinate(collecteLocation.longitude)
    ) {
      return {
        latitude: collecteLocation.latitude,
        longitude: collecteLocation.longitude,
        accuracy: collecteLocation.accuracy,
        source: 'collecte'
      };
    }

    const contribLat = collecte.contribuable?.latitude;
    const contribLng = collecte.contribuable?.longitude;
    if (this.isValidCoordinate(contribLat) && this.isValidCoordinate(contribLng)) {
      return {
        latitude: contribLat!,
        longitude: contribLng!,
        source: 'contribuable'
      };
    }

    return null;
  }

  private isValidCoordinate(value?: number): boolean {
    return value !== null && value !== undefined && !Number.isNaN(value);
  }
}