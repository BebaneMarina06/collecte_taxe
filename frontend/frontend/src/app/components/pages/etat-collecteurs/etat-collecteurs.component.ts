import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ApiService } from '../../../services/api.service';
import { ContenerComponent } from '../../items/contener/contener.component';

@Component({
  selector: 'app-etat-collecteurs',
  standalone: true,
  imports: [CommonModule, FormsModule, ContenerComponent],
  templateUrl: './etat-collecteurs.component.html',
  styleUrls: ['./etat-collecteurs.component.scss']
})
export class EtatCollecteursComponent implements OnInit {
  etats: any[] = [];
  filteredEtats: any[] = [];
  loading = false;
  error: string | null = null;

  // Filtres
  modeFiltre: 'jour' | 'plage' = 'jour';
  dateDebut: string = '';
  dateFin: string = '';
  dateSpecifique: string = this.getTodayDate();

  // Pagination
  itemsPerPage = 10;
  currentPage = 1;
  totalPages = 1;

  // Données agrégées
  totalGeneral = {
    montant_cash: 0,
    montant_numerique: 0,
    montant_total: 0,
    nombre_collectes: 0
  };

  constructor(private apiService: ApiService) {}

  ngOnInit(): void {
    this.chargerEtats();
  }

  getTodayDate(): string {
    const today = new Date();
    return today.toISOString().split('T')[0];
  }

  changerModeFiltre(): void {
    if (this.modeFiltre === 'jour') {
      this.dateDebut = '';
      this.dateFin = '';
      this.dateSpecifique = this.getTodayDate();
    } else {
      this.dateSpecifique = '';
      // Définir les dates par défaut pour la plage (derniers 7 jours)
      const today = new Date();
      const lastWeek = new Date(today);
      lastWeek.setDate(today.getDate() - 7);
      this.dateFin = today.toISOString().split('T')[0];
      this.dateDebut = lastWeek.toISOString().split('T')[0];
    }
  }

  chargerEtats(): void {
    this.loading = true;
    this.error = null;

    const params: any = {};

    // Mode jour spécifique
    if (this.modeFiltre === 'jour' && this.dateSpecifique) {
      params.date_specifique = this.dateSpecifique;
    }
    // Mode plage de dates
    else if (this.modeFiltre === 'plage') {
      if (this.dateDebut) params.date_debut = this.dateDebut;
      if (this.dateFin) params.date_fin = this.dateFin;
    }

    // Charger les états de TOUS les collecteurs
    this.apiService.getEtatCollecteurs(params).subscribe({
      next: (data) => {
        this.etats = data;
        this.appliquerFiltres();
        this.calculerTotaux();
        this.loading = false;
      },
      error: (err) => {
        console.error('Erreur lors du chargement des états:', err);
        this.error = 'Erreur lors du chargement des données. Veuillez réessayer.';
        this.loading = false;
      }
    });
  }

  appliquerFiltres(): void {
    this.filteredEtats = [...this.etats];
    this.totalPages = Math.ceil(this.filteredEtats.length / this.itemsPerPage);
    this.currentPage = 1;
  }

  calculerTotaux(): void {
    this.totalGeneral = {
      montant_cash: 0,
      montant_numerique: 0,
      montant_total: 0,
      nombre_collectes: 0
    };

    this.filteredEtats.forEach((etat) => {
      this.totalGeneral.montant_cash += parseFloat(etat.montant_cash);
      this.totalGeneral.montant_numerique += parseFloat(etat.montant_numerique);
      this.totalGeneral.montant_total += parseFloat(etat.montant_total);
      this.totalGeneral.nombre_collectes += etat.nombre_contribuables;
    });
  }

  afficherContribuables(etat: any): void {
    if (etat.showDetails) {
      etat.showDetails = false;
    } else {
      etat.showDetails = true;
    }
  }

  reinitialiserFiltres(): void {
    this.modeFiltre = 'jour';
    this.dateSpecifique = this.getTodayDate();
    this.dateDebut = '';
    this.dateFin = '';
    this.chargerEtats();
  }

  paginerDonnees(): any[] {
    const start = (this.currentPage - 1) * this.itemsPerPage;
    const end = start + this.itemsPerPage;
    return this.filteredEtats.slice(start, end);
  }

  allerPage(page: number): void {
    if (page >= 1 && page <= this.totalPages) {
      this.currentPage = page;
    }
  }

  exporterCSV(): void {
    if (this.filteredEtats.length === 0) {
      alert('Aucune donnée à exporter');
      return;
    }

    const headers = [
      'Nom du Collecteur',
      'Date',
      'Montant Cash',
      'Montant Numérique',
      'Montant Total',
      'Nombre de Contribuables',
      'Contribuables'
    ];

    const rows: any[] = [];

    this.filteredEtats.forEach((etat) => {
      const contribuablesStr = etat.contribuables
        .map((c: any) => `${c.nom} ${c.prenom} (${c.montant.toFixed(2)} F CFA)`)
        .join('; ');

      rows.push([
        etat.nom_collecteur,
        this.formatDate(etat.date),
        etat.montant_cash.toFixed(2),
        etat.montant_numerique.toFixed(2),
        etat.montant_total.toFixed(2),
        etat.nombre_contribuables,
        contribuablesStr
      ]);
    });

    // Ajouter la ligne de totaux
    rows.push([
      'TOTAL',
      '',
      this.totalGeneral.montant_cash.toFixed(2),
      this.totalGeneral.montant_numerique.toFixed(2),
      this.totalGeneral.montant_total.toFixed(2),
      this.totalGeneral.nombre_collectes,
      ''
    ]);

    // Créer le contenu CSV
    let csvContent = 'data:text/csv;charset=utf-8,';
    csvContent += headers.join(',') + '\n';
    rows.forEach((row) => {
      csvContent += row.map((cell: any) => this.escapeCsv(cell)).join(',') + '\n';
    });

    // Télécharger le fichier
    const encodedUri = encodeURI(csvContent);
    const link = document.createElement('a');
    link.setAttribute('href', encodedUri);
    link.setAttribute('download', `etat_collecteurs_${new Date().toISOString().split('T')[0]}.csv`);
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  }

  escapeCsv(value: any): string {
    if (value === null || value === undefined) {
      return '';
    }
    const stringValue = String(value);
    if (stringValue.includes(',') || stringValue.includes('"') || stringValue.includes('\n')) {
      return `"${stringValue.replace(/"/g, '""')}"`;
    }
    return stringValue;
  }

  formatDate(dateStr: string): string {
    if (!dateStr) return '';
    const date = new Date(dateStr);
    return date.toLocaleDateString('fr-FR');
  }

  formatMontant(montant: any): string {
    return parseFloat(montant).toLocaleString('fr-FR', {
      minimumFractionDigits: 2,
      maximumFractionDigits: 2
    });
  }

  trackByIndex(index: number, item: any) {
    return index;
  }
}
