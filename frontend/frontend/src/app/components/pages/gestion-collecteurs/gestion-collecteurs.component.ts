import { Component, OnInit, OnDestroy, inject, model } from '@angular/core';
import { ApiService } from '../../../services/api.service';
import { SyncService } from '../../../services/sync.service';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ContenerComponent } from '../../items/contener/contener.component';
import { PaginationComponent } from '../../items/pagination/pagination.component';
import { ModalComponent } from '../../items/modal/modal.component';
import { CreateCollecteurComponent } from '../../items/modals/create-collecteur/create-collecteur.component';
import { BulkHeureClotureComponent } from '../../items/modals/bulk-heure-cloture/bulk-heure-cloture.component';
import { Collecteur } from '../../../interfaces/collecteur.interface';
import { ActiviteCollecteur } from '../../../interfaces/activite-collecteur.interface';
import { AppareilCollecteur } from '../../../interfaces/appareil-collecteur.interface';
import { Subscription } from 'rxjs';

@Component({
  selector: 'app-gestion-collecteurs',
  imports: [CommonModule, FormsModule, ContenerComponent, PaginationComponent, ModalComponent, CreateCollecteurComponent, BulkHeureClotureComponent],
  standalone: true,
  templateUrl: './gestion-collecteurs.component.html',
  styleUrl: './gestion-collecteurs.component.scss'
})
export class GestionCollecteursComponent implements OnInit, OnDestroy {
  private apiService = inject(ApiService);
  private syncService = inject(SyncService);
  private syncSubscription?: Subscription;
  
  collecteurs: Collecteur[] = [];
  loading: boolean = true;
  searchTerm: string = '';
  activeModal = model<boolean>(false);
  activeModalEdit = model<boolean>(false);
  activeModalActivites = model<boolean>(false);
  activeModalBulkHeureCloture = model<boolean>(false);
  activeModalDevices = model<boolean>(false);
  selectedCollecteur: Collecteur | null = null;
  activites: ActiviteCollecteur | null = null;
  loadingActivites: boolean = false;
  dateDebut: string = '';
  dateFin: string = '';
  appareils: AppareilCollecteur[] = [];
  loadingAppareils: boolean = false;
  
  // Pagination
  currentPage: number = 1;
  pageSize: number = 20;
  totalItems: number = 0;
  totalPages: number = 1;

  ngOnInit(): void {
    this.loadCollecteurs();
    // S'abonner à la synchronisation automatique
    this.syncSubscription = this.syncService.sync$.subscribe(() => {
      // Ne rafraîchir que si on n'est pas en train de chercher
      if (!this.searchTerm) {
        this.loadCollecteurs();
      }
    });
  }

  ngOnDestroy(): void {
    if (this.syncSubscription) {
      this.syncSubscription.unsubscribe();
    }
  }

  loadCollecteurs(): void {
    this.loading = true;
    const params: any = { 
      skip: (this.currentPage - 1) * this.pageSize,
      limit: this.pageSize,
      order_by: '-created_at' // Du plus récent au plus ancien
    };
    if (this.searchTerm) {
      params.search = this.searchTerm;
    }
    
    this.apiService.getCollecteurs(params).subscribe({
      next: (data: Collecteur[]) => {
        this.collecteurs = data;
        this.totalItems = data.length === this.pageSize ? (this.currentPage * this.pageSize) + 1 : (this.currentPage - 1) * this.pageSize + data.length;
        this.totalPages = Math.ceil(this.totalItems / this.pageSize);
        this.loading = false;
      },
      error: (err) => {
        console.error('Erreur lors du chargement des collecteurs:', err);
        this.loading = false;
      }
    });
  }

  onSearch(): void {
    this.currentPage = 1;
    this.loadCollecteurs();
  }

  onPageChange(page: number): void {
    this.currentPage = page;
    this.loadCollecteurs();
  }

  onPageSizeChange(size: number): void {
    this.pageSize = size;
    this.currentPage = 1;
    this.loadCollecteurs();
  }

  toggleStatut(collecteur: Collecteur): void {
    const newStatut = collecteur.statut === 'active' ? 'desactive' : 'active';
    this.apiService.updateCollecteur(collecteur.id, { statut: newStatut }).subscribe({
      next: () => {
        this.loadCollecteurs();
      },
      error: (err) => {
        console.error('Erreur lors de la mise à jour:', err);
      }
    });
  }

  toggleConnexion(collecteur: Collecteur): void {
    if (collecteur.etat === 'connecte') {
      this.apiService.deconnexionCollecteur(collecteur.id).subscribe({
        next: () => {
          this.loadCollecteurs();
        },
        error: (err) => {
          console.error('Erreur lors de la déconnexion:', err);
        }
      });
    } else {
      this.apiService.connexionCollecteur(collecteur.id).subscribe({
        next: () => {
          this.loadCollecteurs();
        },
        error: (err) => {
          console.error('Erreur lors de la connexion:', err);
        }
      });
    }
  }

  getStatutBadgeClass(statut: string): string {
    return statut === 'active' ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800';
  }

  getEtatBadgeClass(etat: string): string {
    return etat === 'connecte' ? 'bg-blue-100 text-blue-800' : 'bg-gray-100 text-gray-800';
  }

  onActiveModal(active: boolean): void {
    this.activeModal.set(active);
  }

  onActiveModalEdit(active: boolean): void {
    this.activeModalEdit.set(active);
  }

  openCreateModal(): void {
    this.selectedCollecteur = null;
    this.activeModal.set(true);
  }

  editCollecteur(collecteur: Collecteur): void {
    this.selectedCollecteur = collecteur;
    this.activeModalEdit.set(true);
  }

  onCollecteurCreated(): void {
    this.loadCollecteurs();
    this.activeModal.set(false);
    this.activeModalEdit.set(false);
    this.selectedCollecteur = null;
  }

  openBulkHeureClotureModal(): void {
    this.activeModalBulkHeureCloture.set(true);
  }

  onBulkHeureClotureUpdated(): void {
    this.activeModalBulkHeureCloture.set(false);
    this.loadCollecteurs();
  }

  viewActivites(collecteur: Collecteur): void {
    this.selectedCollecteur = collecteur;
    // Définir les dates par défaut (30 derniers jours)
    const today = new Date();
    const thirtyDaysAgo = new Date();
    thirtyDaysAgo.setDate(today.getDate() - 30);
    
    this.dateFin = today.toISOString().split('T')[0];
    this.dateDebut = thirtyDaysAgo.toISOString().split('T')[0];
    
    this.loadActivites();
    this.activeModalActivites.set(true);
  }

  loadActivites(): void {
    if (!this.selectedCollecteur) return;
    
    this.loadingActivites = true;
    this.apiService.getActivitesCollecteur(
      this.selectedCollecteur.id,
      this.dateDebut || undefined,
      this.dateFin || undefined
    ).subscribe({
      next: (data: ActiviteCollecteur) => {
        this.activites = data;
        this.loadingActivites = false;
      },
      error: (err) => {
        console.error('Erreur lors du chargement des activités:', err);
        this.loadingActivites = false;
      }
    });
  }

  formatDate(dateStr: string): string {
    const date = new Date(dateStr);
    return date.toLocaleDateString('fr-FR', { day: '2-digit', month: '2-digit', year: 'numeric' });
  }

  formatTime(dateStr: string): string {
    const date = new Date(dateStr);
    return date.toLocaleTimeString('fr-FR', { hour: '2-digit', minute: '2-digit' });
  }

  formatDuree(minutes: number | undefined): string {
    if (!minutes) return '-';
    const heures = Math.floor(minutes / 60);
    const mins = minutes % 60;
    if (heures > 0) {
      return `${heures}h${mins > 0 ? mins + 'min' : ''}`;
    }
    return `${mins}min`;
  }

  onDateChange(): void {
    if (this.dateDebut && this.dateFin) {
      this.loadActivites();
    }
  }

  viewDevices(collecteur: Collecteur): void {
    this.selectedCollecteur = collecteur;
    this.loadAppareils();
    this.activeModalDevices.set(true);
  }

  loadAppareils(): void {
    if (!this.selectedCollecteur) return;
    
    this.loadingAppareils = true;
    this.apiService.getCollecteurDevices(this.selectedCollecteur.id).subscribe({
      next: (data: AppareilCollecteur[]) => {
        this.appareils = data;
        this.loadingAppareils = false;
      },
      error: (err) => {
        console.error('Erreur lors du chargement des appareils:', err);
        this.loadingAppareils = false;
      }
    });
  }

  toggleDeviceAuthorization(appareil: AppareilCollecteur): void {
    if (!this.selectedCollecteur) return;
    
    const newStatus = !appareil.authorized;
    this.apiService.authorizeDevice(this.selectedCollecteur.id, appareil.device_id, newStatus).subscribe({
      next: () => {
        appareil.authorized = newStatus;
        this.loadAppareils();
      },
      error: (err) => {
        console.error('Erreur lors de la modification de l\'autorisation:', err);
        alert('Erreur lors de la modification de l\'autorisation');
      }
    });
  }

  getDeviceInfo(appareil: AppareilCollecteur): string {
    if (!appareil.device_info) return 'N/A';
    try {
      const info = typeof appareil.device_info === 'string' ? JSON.parse(appareil.device_info) : appareil.device_info;
      const parts: string[] = [];
      if (info.brand) parts.push(info.brand);
      if (info.model) parts.push(info.model);
      if (info.os_version) parts.push(`OS ${info.os_version}`);
      return parts.length > 0 ? parts.join(' - ') : 'N/A';
    } catch {
      return 'N/A';
    }
  }
}
