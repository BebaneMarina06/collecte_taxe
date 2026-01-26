import { Component, model, ModelSignal, Input, inject, OnInit, OnChanges, SimpleChanges } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ContenerGrayComponent } from "../../contener-gray/contener-gray.component";
import { ModalComponent } from "../../modal/modal.component";
import { ModificationTaxesComponent } from "../modification-taxes/modification-taxes.component";
import { AssignTaxesContribuableComponent } from "../assign-taxes-contribuable/assign-taxes-contribuable.component";
import { Taxe } from '../../../../interfaces/taxe.interface';
import { Contribuable } from '../../../../interfaces/contribuable.interface';
import { Taxation } from '../../../../interfaces/taxation.interface';
import { ApiService } from '../../../../services/api.service';

@Component({
  selector: 'app-details-taxes',
  imports: [CommonModule, ContenerGrayComponent, ModalComponent, ModificationTaxesComponent, AssignTaxesContribuableComponent],
  templateUrl: './details-taxes.component.html',
  styleUrl: './details-taxes.component.scss'
})
export class DetailsTaxesComponent implements OnInit, OnChanges {
  @Input() contribuable: Contribuable | null = null;
  @Input() taxe: Taxe | null = null;

  activeModalModifTaxe: ModelSignal<boolean> = model<boolean>(false);
  activeModalAssignTaxe: ModelSignal<boolean> = model<boolean>(false);

  taxations: Taxation[] = [];
  loading: boolean = false;
  error: string | null = null;

  private apiService = inject(ApiService);

  ngOnInit(): void {
    // Le composant peut afficher soit les détails d'une taxe soit les taxations d'un contribuable
    // Pas besoin de charger quoi que ce soit ici, c'est géré dans ngOnChanges
  }

  ngOnChanges(changes: SimpleChanges): void {
    if (changes['contribuable'] && changes['contribuable'].currentValue) {
      this.loadTaxations();
    }
    // Pour une taxe individuelle, pas besoin de charger, les données sont passées directement
  }

  loadTaxations(): void {
    if (!this.contribuable) return;

    console.log('Chargement des taxations pour contribuable:', this.contribuable.id);
    this.loading = true;
    this.error = null;

    this.apiService.getTaxationsContribuable(this.contribuable.id).subscribe({
      next: (response: any) => {
        console.log('Réponse API taxations:', response);
        // L'API retourne directement un array, pas un objet avec propriété taxations
        this.taxations = Array.isArray(response) ? response : [];
        console.log('Taxations chargées:', this.taxations.length, 'éléments');
        this.loading = false;
      },
      error: (err) => {
        console.error('Erreur lors du chargement des taxations:', err);
        this.error = 'Erreur lors du chargement des taxations';
        this.loading = false;
      }
    });
  }

  // appel modal modification taxe de la taxe
  onactiveModalModifTaxe(value: boolean): void {
    this.activeModalModifTaxe.set(value);
  }

  // appel modal attribution de taxe
  onactiveModalAssignTaxe(value: boolean): void {
    this.activeModalAssignTaxe.set(value);
  }

  // callback après attribution de taxes
  onTaxesAssigned(): void {
    console.log('Événement taxesAssigned reçu dans DetailsTaxesComponent');
    console.log('Fermeture de la modal d\'attribution');
    this.activeModalAssignTaxe.set(false);

    // Petit délai pour s'assurer que la modal se ferme avant de recharger
    setTimeout(() => {
      console.log('Rechargement des taxations après attribution');
      this.loadTaxations();
    }, 500);
  }

  formatDate(dateString: string): string {
    if (!dateString) return 'N/A';
    const date = new Date(dateString);
    return date.toLocaleDateString('fr-FR', {
      day: '2-digit',
      month: '2-digit',
      year: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    });
  }

  formatNumber(value: number): string {
    if (isNaN(value) || value === null || value === undefined) {
      return '0';
    }
    return new Intl.NumberFormat('fr-FR', {
      minimumFractionDigits: 0,
      maximumFractionDigits: 0
    }).format(value);
  }

  getPeriodiciteLabel(periodicite: string): string {
    const labels: { [key: string]: string } = {
      'journaliere': 'Journalière',
      'hebdomadaire': 'Hebdomadaire',
      'mensuelle': 'Mensuelle',
      'trimestrielle': 'Trimestrielle'
    };
    return labels[periodicite] || periodicite;
  }
}
