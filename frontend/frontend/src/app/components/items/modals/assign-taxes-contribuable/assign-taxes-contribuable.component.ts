import { Component, model, ModelSignal, Input, inject, Output, EventEmitter } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Contribuable } from '../../../../interfaces/contribuable.interface';
import { Taxe } from '../../../../interfaces/taxe.interface';
import { ApiService } from '../../../../services/api.service';

@Component({
  selector: 'app-assign-taxes-contribuable',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './assign-taxes-contribuable.component.html',
  styleUrl: './assign-taxes-contribuable.component.scss'
})
export class AssignTaxesContribuableComponent {
  @Input() contribuable!: Contribuable | null;
  @Output() taxesAssigned = new EventEmitter<void>();
  @Output() closeModal = new EventEmitter<void>();

  private apiService = inject(ApiService);

  taxes: Taxe[] = [];
  selectedTaxes: number[] = [];
  loading: boolean = false;
  assigning: boolean = false;
  error: string | null = null;

  ngOnInit(): void {
    this.loadTaxes();
  }

  loadTaxes(): void {
    this.loading = true;
    this.error = null;

    this.apiService.getTaxes().subscribe({
      next: (response: any) => {
        this.taxes = Array.isArray(response) ? response : (response.taxes || []);
        this.loading = false;
      },
      error: (err) => {
        console.error('Erreur lors du chargement des taxes:', err);
        this.error = 'Erreur lors du chargement des taxes';
        this.loading = false;
      }
    });
  }

  isTaxSelected(taxeId: number): boolean {
    return this.selectedTaxes.includes(taxeId);
  }

  toggleTaxSelection(taxeId: number): void {
    const index = this.selectedTaxes.indexOf(taxeId);
    if (index > -1) {
      this.selectedTaxes.splice(index, 1);
    } else {
      this.selectedTaxes.push(taxeId);
    }
  }

  assignTaxes(): void {
    if (!this.contribuable) {
      this.error = 'Erreur: Aucun contribuable sélectionné';
      return;
    }

    if (this.selectedTaxes.length === 0) {
      this.error = 'Veuillez sélectionner au moins une taxe';
      return;
    }

    this.assigning = true;
    this.error = null;

    this.apiService.assignTaxesToContribuable(this.contribuable.id, this.selectedTaxes).subscribe({
      next: (response: any) => {
        console.log('Taxes attribuées avec succès:', response);
        console.log('Émission de l\'événement taxesAssigned');
        this.assigning = false;
        this.taxesAssigned.emit();
        this.closeModal.emit();
      },
      error: (err) => {
        console.error('Erreur lors de l\'attribution des taxes:', err);
        this.error = err.error?.detail || 'Erreur lors de l\'attribution des taxes';
        this.assigning = false;
      }
    });
  }

  cancel(): void {
    this.closeModal.emit();
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