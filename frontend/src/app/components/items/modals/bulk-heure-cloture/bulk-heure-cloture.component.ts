import { Component, EventEmitter, Output, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ApiService } from '../../../../services/api.service';

@Component({
  selector: 'app-bulk-heure-cloture',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './bulk-heure-cloture.component.html',
  styles: [`
    .modal-content-wrapper {
      padding: 1rem;
    }
  `]
})
export class BulkHeureClotureComponent {
  @Output() heureClotureUpdated = new EventEmitter<void>();
  
  private apiService = inject(ApiService);
  
  loading: boolean = false;
  error: string = '';
  success: string = '';
  heureCloture: string = '18:00';
  actifOnly: boolean = true;

  onSubmit(): void {
    this.error = '';
    this.success = '';
    
    // Validation du format HH:MM
    const timePattern = /^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$/;
    if (!timePattern.test(this.heureCloture)) {
      this.error = 'Format d\'heure invalide. Utilisez le format HH:MM (ex: 18:00)';
      return;
    }

    this.loading = true;
    
    this.apiService.bulkUpdateHeureCloture(this.heureCloture, this.actifOnly).subscribe({
      next: (response: any) => {
        this.loading = false;
        this.success = response.message || `Heure de fermeture mise à jour pour ${response.collecteurs_updated || 0} collecteur(s)`;
        setTimeout(() => {
          this.heureClotureUpdated.emit();
        }, 1500);
      },
      error: (err) => {
        this.loading = false;

        // Gérer les erreurs 400/422 renvoyées par FastAPI (souvent sous forme de tableau de détails)
        const detail = err?.error?.detail ?? err?.error ?? err?.message;
        if (Array.isArray(detail)) {
          this.error = detail.map((d: any) => d.msg || JSON.stringify(d)).join(' | ');
        } else if (typeof detail === 'object') {
          this.error = detail.msg || detail.error || JSON.stringify(detail);
        } else if (typeof detail === 'string') {
          this.error = detail;
        } else {
          this.error = 'Erreur lors de la mise à jour de l\'heure de fermeture';
        }
        console.error('Erreur bulkUpdateHeureCloture:', err);
      }
    });
  }
}

