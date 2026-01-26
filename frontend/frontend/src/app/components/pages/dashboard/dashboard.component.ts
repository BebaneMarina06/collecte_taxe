import {Component, inject, model, ModelSignal, OnInit, OnDestroy} from '@angular/core';
import {ChartComponent} from '../../items/chart/chart.component';
import {TransactionsTableComponent} from '../../items/tables/transactions-table/transactions-table.component';
import {ModalComponent} from '../../items/modal/modal.component';
import {CreatePaiementLinkComponent} from '../../items/modals/create-paiement-link/create-paiement-link.component';
import {TransactionDetailsComponent} from '../../items/modals/transaction-details/transaction-details.component';
import {ApiService} from '../../../services/api.service';
import {SyncService} from '../../../services/sync.service';
import {CommonModule} from '@angular/common';
import {RouterLink} from '@angular/router';
import {Subscription} from 'rxjs';

@Component({
  selector: 'app-dashboard',
  imports: [
    ChartComponent,
    TransactionsTableComponent,
    ModalComponent,
    CreatePaiementLinkComponent,
    TransactionDetailsComponent,
    CommonModule,
    RouterLink
  ],
  standalone: true,
  templateUrl: './dashboard.component.html',
  styleUrl: './dashboard.component.scss'
})
export class DashboardComponent implements OnInit, OnDestroy {
  active: ModelSignal<boolean> = model<boolean>(false);
  activeModalDetail: ModelSignal<boolean> = model<boolean>(false);
  
  private apiService = inject(ApiService);
  private syncService = inject(SyncService);
  private syncSubscription?: Subscription;
  
  // Statistiques
  totalCollecte: number = 0;
  totalCollecte_effectif: number = 0; // Total réellement collecté
  totalDu: number = 0; // Total restant à payer
  nombreCollecteurs: number = 0;
  transactionsValidees: number = 0;
  totalClients: number = 0;
  loading: boolean = true;
  
  // Données pour les graphiques
  chartData: any = {
    labels: [],
    datasets: []
  };

  ngOnInit(): void {
    this.loadStatistics();
    // S'abonner à la synchronisation automatique
    this.syncSubscription = this.syncService.sync$.subscribe(() => {
      this.loadStatistics();
    });
  }

  ngOnDestroy(): void {
    if (this.syncSubscription) {
      this.syncSubscription.unsubscribe();
    }
  }

  loadStatistics(): void {
    this.loading = true;

    // Utiliser l'endpoint dédié pour les statistiques de paiements
    this.apiService.getTaxesPaiementsStatistiques().subscribe({
      next: (stats: any) => {
        console.log('Statistiques de paiements reçues:', stats);

        // Utiliser les données calculées par le backend
        const global = stats.global;
        this.totalCollecte = parseFloat(global.montant_espere || 0);
        this.totalCollecte_effectif = parseFloat(global.montant_collecte || 0);
        this.totalDu = parseFloat(global.montant_restant_du || 0);

        console.log('Total espéré (backend):', this.totalCollecte);
        console.log('Total collecté (backend):', this.totalCollecte_effectif);
        console.log('Total dû (backend):', this.totalDu);

        // Charger les statistiques générales pour le reste des données
        this.loadAdditionalStats();
      },
      error: (err) => {
        console.error('Erreur lors du chargement des statistiques de paiements:', err);
        this.loading = false;
      }
    });
  }

  loadAdditionalStats(): void {
    // Charger les statistiques générales (collecteurs, transactions, etc.)
    this.apiService.getStatistiquesGenerales().subscribe({
      next: (stats: any) => {
        console.log('Statistiques générales reçues:', stats);

        this.nombreCollecteurs = stats.nombre_collecteurs_actifs || 0;
        this.transactionsValidees = stats.nombre_transactions || 0;

        console.log('Collecteurs actifs:', this.nombreCollecteurs);
        console.log('Transactions validées:', this.transactionsValidees);
      },
      error: (err) => {
        console.error('Erreur lors du chargement des statistiques générales:', err);
      }
    });

    // Charger le nombre de contribuables
    this.apiService.getContribuables({ actif: true, limit: 1 }).subscribe({
      next: (result: any) => {
        // Si l'API retourne un tableau, compter la longueur
        // Sinon, chercher une propriété "total" ou similaire
        if (Array.isArray(result)) {
          // Recharger avec une limite plus grande pour avoir le vrai total
          this.apiService.getContribuables({ actif: true, limit: 10000 }).subscribe({
            next: (contribuables: any[]) => {
              this.totalClients = contribuables.length;
              console.log('Contribuables actifs:', this.totalClients);
            }
          });
        } else if (result.total !== undefined) {
          this.totalClients = result.total;
        }
      },
      error: (err) => {
        console.error('Erreur lors du chargement des contribuables:', err);
      }
    });

    // Charger les collectes pour le graphique
    this.apiService.getCollectes({ limit: 10000 }).subscribe({
      next: (collectes: any[]) => {
        const collectesValidees = collectes.filter(c =>
          (c.statut === 'completed' || c.statut === 'validee') && !c.annule
        );
        this.prepareChartData(collectesValidees);
        this.loading = false;
      },
      error: (err) => {
        console.error('Erreur lors du chargement des collectes pour le graphique:', err);
        this.loading = false;
      }
    });
  }

  prepareChartData(collectes: any[]): void {
    // Grouper par mois
    const monthlyData: { [key: string]: number } = {};
    const months = ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Jun', 'Jul', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc'];
    
    // Filtrer les collectes validées
    const collectesValidees = collectes.filter(c => 
      (c.statut === 'completed' || c.statut === 'validee') && !c.annule
    );
    
    collectesValidees.forEach(collecte => {
      if (collecte.date_collecte) {
        const date = new Date(collecte.date_collecte);
        if (!isNaN(date.getTime())) {
          const monthKey = `${date.getFullYear()}-${date.getMonth()}`;
          if (!monthlyData[monthKey]) {
            monthlyData[monthKey] = 0;
          }
          monthlyData[monthKey] += parseFloat(collecte.montant || 0);
        }
      }
    });
    
    // Préparer les données pour le graphique (12 derniers mois)
    const labels = months;
    const data = months.map((_, index) => {
      const date = new Date();
      date.setMonth(date.getMonth() - (11 - index));
      const key = `${date.getFullYear()}-${date.getMonth()}`;
      return monthlyData[key] || 0;
    });
    
    this.chartData = {
      labels,
      datasets: [{
        label: 'Collecte mensuelle (FCFA)',
        data,
        fill: true,
        backgroundColor: 'rgba(16, 185, 129, 0.1)', // Vert dégradé
        borderColor: 'rgb(16, 185, 129)', // Vert moderne
        borderWidth: 3,
        tension: 0.4,
        pointRadius: 5,
        pointBackgroundColor: 'rgb(16, 185, 129)',
        pointBorderColor: '#fff',
        pointBorderWidth: 2,
        pointHoverRadius: 7,
        pointHoverBackgroundColor: 'rgb(5, 150, 105)',
        pointHoverBorderColor: '#fff',
        pointHoverBorderWidth: 3,
      }]
    };
  }

  formatNumber(value: number): string {
    if (isNaN(value) || value === null || value === undefined) {
      return '0';
    }
    // Formater avec des espaces comme séparateurs de milliers
    return new Intl.NumberFormat('fr-FR', {
      minimumFractionDigits: 0,
      maximumFractionDigits: 0
    }).format(value);
  }

  onActiveModal(value: boolean): void {
    this.active.set(value);
  }
  
  onActiveModalDetail(value: boolean): void {
    this.activeModalDetail.set(value);
  }
}