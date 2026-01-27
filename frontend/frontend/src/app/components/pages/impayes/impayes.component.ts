import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ImpayesAdaptiveService, ImpayeUnifie, ListeResponse } from '../../../services/impayes.service';

@Component({
  selector: 'app-impayes',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './impayes.component.html',
  styleUrl: './impayes.component.scss'
})
export class ImpayesComponent implements OnInit {
  private impayesService = inject(ImpayesAdaptiveService);

  Math = Math;
  
  impayes: ImpayeUnifie[] = [];
  loading = false;
  error = '';
  
  filters = {
    contribuable_id: null as number | null,
    taxe_id: null as number | null,
    statut: null as string | null,
    zone_nom: null as string | null,
    quartier_nom: null as string | null
  };

  currentPage = 0;
  pageSize = 20;
  total = 0;

  stats: any = null;
  zones: string[] = [];
  quartiers: string[] = [];
  
  statutOptions = ['PAYE', 'PARTIEL', 'IMPAYE', 'RETARD'];

  ngOnInit(): void {
    console.log('[ImpayesComponent] Initialisation');
    this.loadImpayes();
  }

  loadImpayes(): void {
    this.loading = true;
    this.error = '';

    const filtres = {
      skip: this.currentPage * this.pageSize,
      limit: this.pageSize,
      ...this.filters
    };

    console.log('[ImpayesComponent] Chargement avec filtres:', filtres);

    this.impayesService.getImpayes(filtres).subscribe({
      next: (response: ListeResponse) => {
        console.log('[ImpayesComponent] Données reçues:', response);
        console.log('[ImpayesComponent] Nombre d\'items:', response.items?.length);
        
        this.impayes = response.items || [];
        this.total = response.total || 0;
        this.loading = false;
        
        this.extractZonesAndQuartiers();
        
        console.log('[ImpayesComponent] État final:', {
          total: this.total,
          itemsCount: this.impayes.length,
          premiersItems: this.impayes.slice(0, 3)
        });
      },
      error: (err: any) => {
        console.error('[ImpayesComponent] Erreur:', err);
        this.error = err.error?.detail || err.message || 'Erreur lors du chargement des impayés';
        this.loading = false;
      }
    });
  }

  extractZonesAndQuartiers(): void {
    const zonesSet = new Set(this.impayes.map(i => i.zone_nom).filter(Boolean));
    this.zones = Array.from(zonesSet).sort();

    const quartiersSet = new Set(this.impayes.map(i => i.quartier_nom).filter(Boolean));
    this.quartiers = Array.from(quartiersSet).sort();
  }

  applyFilters(): void {
    this.currentPage = 0;
    this.loadImpayes();
  }

  resetFilters(): void {
    this.filters = {
      contribuable_id: null,
      taxe_id: null,
      statut: null,
      zone_nom: null,
      quartier_nom: null
    };
    this.applyFilters();
  }

  onPageChange(page: number): void {
    this.currentPage = page;
    this.loadImpayes();
  }

  getTotalPages(): number {
    return Math.ceil(this.total / this.pageSize);
  }

  getStatutClass(statut: string): string {
    const classes: { [key: string]: string } = {
      'PAYE': 'bg-white text-green-700 border-green-400',
      'PARTIEL': 'bg-white text-blue-700 border-blue-400',
      'IMPAYE': 'bg-white text-gray-700 border-gray-400',
      'RETARD': 'bg-white text-red-700 border-red-400'
    };
    return classes[statut] || 'bg-white text-gray-700 border-gray-300';
  }

  getStatutLabel(statut: string): string {
    const labels: { [key: string]: string } = {
      'PAYE': 'Payé',
      'PARTIEL': 'Partiel',
      'IMPAYE': 'Impayé',
      'RETARD': 'En retard'
    };
    return labels[statut] || statut;
  }

  getRetardClass(joursRetard: number): string {
    if (joursRetard === 0) return '';
    if (joursRetard > 90) return 'text-red-700 font-bold';
    if (joursRetard > 60) return 'text-red-600 font-semibold';
    if (joursRetard > 30) return 'text-orange-600';
    return 'text-yellow-600';
  }

  exportToCSV(): void {
    if (this.impayes.length === 0) {
      alert('Aucune donnée à exporter');
      return;
    }

    const headers = [
      'Contribuable',
      'Téléphone',
      'Zone',
      'Quartier',
      'Taxe',
      'Code Taxe',
      'Montant Attendu',
      'Montant Payé',
      'Montant Restant',
      '% Payé',
      'Statut',
      'Date Échéance',
      'Jours Retard',
      'Collecteur'
    ];

    const rows = this.impayes.map(impaye => [
      `${impaye.contribuable_nom} ${impaye.contribuable_prenom}`,
      impaye.contribuable_telephone || '',
      impaye.zone_nom || '',
      impaye.quartier_nom || '',
      impaye.taxe_nom,
      impaye.taxe_code || '',
      impaye.montant_attendu,
      impaye.montant_paye,
      impaye.montant_restant,
      impaye.pourcentage_paye.toFixed(1),
      impaye.statut,
      impaye.date_echeance,
      impaye.jours_retard,
      impaye.collecteur_nom && impaye.collecteur_prenom 
        ? `${impaye.collecteur_nom} ${impaye.collecteur_prenom}` 
        : 'Non assigné'
    ]);

    const csvContent = [
      headers.join(','),
      ...rows.map(row => row.map(cell => `"${cell}"`).join(','))
    ].join('\n');

    const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
    const link = document.createElement('a');
    const url = URL.createObjectURL(blob);
    
    link.setAttribute('href', url);
    link.setAttribute('download', `impayes_${new Date().toISOString().split('T')[0]}.csv`);
    link.style.visibility = 'hidden';
    
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  }

  voirDetailsContribuable(contribuableId: number): void {
    console.log('Voir détails du contribuable:', contribuableId);
    // TODO: Implémenter
  }

  formatMontant(montant: number): string {
    if (montant === null || montant === undefined) {
      return '0';
    }
    return new Intl.NumberFormat('fr-FR', {
      minimumFractionDigits: 0,
      maximumFractionDigits: 0
    }).format(montant);
  }

  formatDate(dateStr: string): string {
    if (!dateStr) return 'N/A';
    const date = new Date(dateStr);
    return new Intl.DateTimeFormat('fr-FR').format(date);
  }

  formatPourcentage(valeur: number): string {
    if (valeur === null || valeur === undefined) {
      return '0%';
    }
    return `${valeur.toFixed(1)}%`;
  }
}