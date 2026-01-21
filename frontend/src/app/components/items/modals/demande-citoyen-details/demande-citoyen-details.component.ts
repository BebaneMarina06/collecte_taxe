import { Component, Input, Output, EventEmitter, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ApiService } from '../../../../services/api.service';
import { DemandeCitoyen, StatutDemande } from '../../../../interfaces/demande-citoyen.interface';

@Component({
  selector: 'app-demande-citoyen-details',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './demande-citoyen-details.component.html',
  styleUrl: './demande-citoyen-details.component.scss'
})
export class DemandeCitoyenDetailsComponent implements OnInit {
  private apiService = inject(ApiService);

  @Input() demande!: DemandeCitoyen;
  @Output() demandeUpdated = new EventEmitter<void>();

  loading = false;
  error = '';
  success = '';

  // Formulaire de mise à jour
  updateForm = {
    statut: '' as StatutDemande | '',
    reponse: ''
  };

  ngOnInit(): void {
    this.updateForm.statut = this.demande.statut;
    this.updateForm.reponse = this.demande.reponse || '';
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

  updateDemande(): void {
    if (!this.updateForm.statut) {
      this.error = 'Veuillez sélectionner un statut';
      return;
    }

    this.loading = true;
    this.error = '';
    this.success = '';

    const payload: any = {
      statut: this.updateForm.statut
    };

    if (this.updateForm.reponse) {
      payload.reponse = this.updateForm.reponse;
    }

    this.apiService.updateDemandeCitoyen(this.demande.id, payload).subscribe({
      next: () => {
        this.success = 'Demande mise à jour avec succès';
        this.loading = false;
        setTimeout(() => {
          this.demandeUpdated.emit();
        }, 1500);
      },
      error: (err) => {
        this.error = err.error?.detail || 'Erreur lors de la mise à jour';
        this.loading = false;
      }
    });
  }

  scrollToTop(): void {
    const modalContent = document.querySelector('.modal-scrollable-content');
    if (modalContent) {
      modalContent.scrollTo({ top: 0, behavior: 'smooth' });
    }
  }
}

