import { Component, OnInit, inject, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ContenerComponent } from '../../items/contener/contener.component';
import { PaginationComponent } from '../../items/pagination/pagination.component';
import { BadgeComponent } from '../../items/badge/badge.component';
import { ApiService } from '../../../services/api.service';

interface TransactionBambooPay {
  id: number;
  billing_id: string;
  payer_name: string;
  phone: string;
  matricule?: string;
  raison_sociale?: string;
  transaction_amount: number;
  statut: string;
  statut_message?: string;
  reference_bp?: string;
  transaction_id?: string;
  operateur?: string;
  payment_method?: string;
  date_initiation: string;
  date_paiement?: string;
  date_callback?: string;
  contribuable_id?: number;
  contribuable_nom?: string;
  taxe_id?: number;
  taxe_nom?: string;
}

interface TransactionStats {
  total_transactions: number;
  total_success: number;
  total_pending: number;
  total_failed: number;
  total_cancelled: number;
  montant_total_success: number;
  montant_total_pending: number;
}

@Component({
  selector: 'app-transactions-bamboopay',
  standalone: true,
  imports: [CommonModule, FormsModule, ContenerComponent, PaginationComponent, BadgeComponent],
  templateUrl: './transactions-bamboopay.component.html',
  styleUrl: './transactions-bamboopay.component.scss'
})
export class TransactionsBambooPayComponent implements OnInit {
  private apiService = inject(ApiService);

  transactions: TransactionBambooPay[] = [];
  stats: TransactionStats | null = null;
  loading = signal(true);
  refreshingId: number | null = null;

  // Pagination
  currentPage = 1;
  pageSize = 20;
  totalItems = 0;
  totalPages = 1;

  // Filtres
  filters = {
    search: '',
    statut: '',
    dateDebut: '',
    dateFin: '',
    paymentMethod: ''
  };

  ngOnInit(): void {
    this.loadTransactions();
    this.loadStats();
  }

  loadTransactions(): void {
    this.loading.set(true);
    const params: any = {
      skip: (this.currentPage - 1) * this.pageSize,
      limit: this.pageSize,
      order_by: '-date_initiation'
    };

    if (this.filters.search) params.search = this.filters.search;
    if (this.filters.statut) params.statut = this.filters.statut;
    if (this.filters.dateDebut) params.date_debut = this.filters.dateDebut;
    if (this.filters.dateFin) params.date_fin = this.filters.dateFin;
    if (this.filters.paymentMethod) params.payment_method = this.filters.paymentMethod;

    this.apiService.getTransactionsBambooPay(params).subscribe({
      next: (data: TransactionBambooPay[]) => {
        this.transactions = data;
        this.totalItems = data.length === this.pageSize
          ? (this.currentPage * this.pageSize) + 1
          : (this.currentPage - 1) * this.pageSize + data.length;
        this.totalPages = Math.ceil(this.totalItems / this.pageSize);
        this.loading.set(false);
      },
      error: (err) => {
        console.error('Erreur chargement transactions:', err);
        this.loading.set(false);
      }
    });
  }

  loadStats(): void {
    const params: any = {};
    if (this.filters.dateDebut) params.date_debut = this.filters.dateDebut;
    if (this.filters.dateFin) params.date_fin = this.filters.dateFin;

    this.apiService.getTransactionsBambooPayStats(params).subscribe({
      next: (data: TransactionStats) => {
        this.stats = data;
      },
      error: (err) => {
        console.error('Erreur chargement stats:', err);
      }
    });
  }

  applyFilters(): void {
    this.currentPage = 1;
    this.loadTransactions();
    this.loadStats();
  }

  resetFilters(): void {
    this.filters = {
      search: '',
      statut: '',
      dateDebut: '',
      dateFin: '',
      paymentMethod: ''
    };
    this.currentPage = 1;
    this.loadTransactions();
    this.loadStats();
  }

  onPageChange(page: number): void {
    this.currentPage = page;
    this.loadTransactions();
  }

  onPageSizeChange(size: number): void {
    this.pageSize = size;
    this.currentPage = 1;
    this.loadTransactions();
  }

  refreshTransaction(id: number): void {
    this.refreshingId = id;
    this.apiService.refreshTransactionBambooPay(id).subscribe({
      next: (result) => {
        console.log('Transaction rafraîchie:', result);
        this.loadTransactions();
        this.loadStats();
        this.refreshingId = null;
      },
      error: (err) => {
        console.error('Erreur refresh transaction:', err);
        this.refreshingId = null;
        alert(err.error?.detail || 'Erreur lors du rafraîchissement');
      }
    });
  }

  getStatutBadgeClass(statut: string): string {
    switch (statut) {
      case 'success':
        return 'bg-green-100 text-green-800';
      case 'pending':
        return 'bg-yellow-100 text-yellow-800';
      case 'failed':
        return 'bg-red-100 text-red-800';
      case 'cancelled':
        return 'bg-gray-100 text-gray-800';
      case 'refunded':
        return 'bg-purple-100 text-purple-800';
      default:
        return 'bg-gray-100 text-gray-600';
    }
  }

  getStatutLabel(statut: string): string {
    switch (statut) {
      case 'success':
        return 'Succès';
      case 'pending':
        return 'En attente';
      case 'failed':
        return 'Échoué';
      case 'cancelled':
        return 'Annulé';
      case 'refunded':
        return 'Remboursé';
      default:
        return statut;
    }
  }

  getPaymentMethodLabel(method: string | undefined): string {
    if (!method) return '-';
    switch (method) {
      case 'web':
        return 'Paiement Web';
      case 'mobile_instant':
        return 'Mobile Money';
      default:
        return method;
    }
  }

  getOperateurLabel(operateur: string | undefined): string {
    if (!operateur) return '-';
    switch (operateur) {
      case 'moov_money':
        return 'Moov Money';
      case 'airtel_money':
        return 'Airtel Money';
      default:
        return operateur;
    }
  }

  formatDate(dateStr: string | undefined): string {
    if (!dateStr) return '-';
    const date = new Date(dateStr);
    return date.toLocaleDateString('fr-FR', {
      day: '2-digit',
      month: '2-digit',
      year: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    });
  }

  formatMontant(montant: number): string {
    return new Intl.NumberFormat('fr-FR').format(montant) + ' FCFA';
  }
}
