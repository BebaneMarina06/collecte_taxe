import { Component, Input, Output, EventEmitter, inject, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ApiService } from '../../../../services/api.service';
import { Taxation } from '../../../../interfaces/taxation.interface';
import { Contribuable } from '../../../../interfaces/contribuable.interface';

@Component({
  selector: 'app-taxations-contribuable',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './taxations-contribuable.component.html',
  styleUrl: './taxations-contribuable.component.scss'
})
export class TaxationsContribuableComponent implements OnInit {
  @Input() contribuable!: Contribuable;
  @Output() closeModal = new EventEmitter<void>();

  private apiService = inject(ApiService);

  taxations: Taxation[] = [];
  loading: boolean = true;
  error: string | null = null;

  // Propriétés calculées pour les statistiques
  get payeesCount(): number {
    return this.taxations.filter(t => t.statut === 'paye').length;
  }

  get restantesCount(): number {
    return this.taxations.filter(t => t.montant_restant > 0).length;
  }

  ngOnInit(): void {
    if (this.contribuable) {
      this.loadTaxations();
    }
  }

  loadTaxations(): void {
    this.loading = true;
    this.error = null;

    this.apiService.getTaxationsContribuable(this.contribuable.id).subscribe({
      next: (response: any) => {
        this.taxations = response.taxations || [];
        this.loading = false;
      },
      error: (err) => {
        console.error('Erreur lors du chargement des taxations:', err);
        this.error = 'Impossible de charger les taxations';
        this.loading = false;
      }
    });
  }

  getStatutBadgeClass(statut: string): string {
    switch (statut) {
      case 'paye':
        return 'bg-green-100 text-green-800';
      case 'partiel':
        return 'bg-yellow-100 text-yellow-800';
      case 'impaye':
        return 'bg-red-100 text-red-800';
      case 'en_attente':
        return 'bg-blue-100 text-blue-800';
      case 'echeance':
        return 'bg-orange-100 text-orange-800';
      default:
        return 'bg-gray-100 text-gray-800';
    }
  }

  getStatutLabel(statut: string): string {
    switch (statut) {
      case 'paye':
        return 'Payé';
      case 'partiel':
        return 'Partiellement payé';
      case 'impaye':
        return 'Impayé';
      case 'en_attente':
        return 'En attente';
      case 'echeance':
        return 'Échéance proche';
      default:
        return statut;
    }
  }

  formatCurrency(amount: number): string {
    return new Intl.NumberFormat('fr-FR', {
      style: 'currency',
      currency: 'XAF',
      minimumFractionDigits: 0,
      maximumFractionDigits: 0
    }).format(amount);
  }

  formatDate(dateString: string | null): string {
    if (!dateString) return '-';
    try {
      return new Date(dateString).toLocaleDateString('fr-FR');
    } catch {
      return dateString;
    }
  }

  formatPeriode(taxation: Taxation): string {
    if (taxation.annee && taxation.mois !== null) {
      // Période mensuelle
      const mois = new Date(2000, taxation.mois - 1, 1).toLocaleDateString('fr-FR', { month: 'long' });
      return `${mois} ${taxation.annee}`;
    } else if (taxation.annee) {
      // Période annuelle
      return `Année ${taxation.annee}`;
    } else {
      // Période personnalisée
      const debut = this.formatDate(taxation.periode_debut);
      const fin = this.formatDate(taxation.periode_fin);
      return fin ? `${debut} - ${fin}` : `À partir du ${debut}`;
    }
  }

  refresh(): void {
    this.loadTaxations();
  }
}