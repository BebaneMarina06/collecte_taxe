import { Component, EventEmitter, Output, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ApiService } from '../../../../services/api.service';

interface ContribuableInfo {
  id: number;
  nom: string;
  prenom?: string;
  telephone: string;
  email?: string;
  adresse?: string;
  collecteur_id: number;
}

interface TaxeDisponible {
  affectation_id: number;
  taxe_id: number;
  taxe_nom: string;
  taxe_code: string;
  montant: number;
  montant_custom?: number;
  periodicite: string;
  description?: string;
  selected?: boolean;
}

interface FormData {
  contribuable_id: number;
  collecteur_id: number;
  type_paiement: string;
  billetage?: string;
  date_collecte?: string;
  items: Array<{ taxe_id: number; montant: number }>;
}

@Component({
  selector: 'app-create-collecte',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './create-collecte.component.html',
  styleUrl: './create-collecte.component.scss'
})
export class CreateCollecteComponent implements OnInit {
  @Output() collecteCreated = new EventEmitter<void>();
  
  private apiService = inject(ApiService);
  
  loading: boolean = false;
  error: string = '';
  
  // Listes pour les selects
  contribuables: any[] = [];
  collecteurs: any[] = [];
  
  loadingContribuables: boolean = false;
  loadingCollecteurs: boolean = false;
  loadingTaxes: boolean = false;
  
  // Infos du contribuable sélectionné
  selectedContribuable?: ContribuableInfo;
  taxesDisponibles: TaxeDisponible[] = [];
  montantTotal: number = 0;
  
  // Form data
  formData: FormData = {
    contribuable_id: 0,
    collecteur_id: 0,
    type_paiement: 'especes',
    billetage: undefined,
    date_collecte: undefined,
    items: []
  };

  ngOnInit(): void {
    // Définir la date du jour par défaut
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    this.formData.date_collecte = today.toISOString().split('T')[0];
    
    // Charger les listes
    this.loadContribuables();
    this.loadCollecteurs();
  }

  loadContribuables(): void {
    this.loadingContribuables = true;
    this.apiService.getContribuables({ actif: true, limit: 1000 }).subscribe({
      next: (data: any) => {
        this.contribuables = Array.isArray(data) ? data : (data.items || []);
        this.loadingContribuables = false;
      },
      error: (err) => {
        console.error('Erreur chargement contribuables:', err);
        this.loadingContribuables = false;
      }
    });
  }

  loadCollecteurs(): void {
    this.loadingCollecteurs = true;
    this.apiService.getCollecteurs({ actif: true, limit: 1000 }).subscribe({
      next: (data: any) => {
        this.collecteurs = Array.isArray(data) ? data : (data.items || []);
        this.loadingCollecteurs = false;
      },
      error: (err) => {
        console.error('Erreur chargement collecteurs:', err);
        this.loadingCollecteurs = false;
      }
    });
  }

  onContribuableChange(): void {
    if (!this.formData.contribuable_id) {
      this.selectedContribuable = undefined;
      this.taxesDisponibles = [];
      this.montantTotal = 0;
      return;
    }

    // Trouver les infos du contribuable
    const contribuable = this.contribuables.find(c => c.id === this.formData.contribuable_id);
    if (contribuable) {
      this.selectedContribuable = {
        id: contribuable.id,
        nom: contribuable.nom,
        prenom: contribuable.prenom,
        telephone: contribuable.telephone,
        email: contribuable.email,
        adresse: contribuable.adresse,
        collecteur_id: contribuable.collecteur_id
      };
      
      // Auto-remplir le collecteur
      this.formData.collecteur_id = contribuable.collecteur_id;
      
      // Charger les taxes actives du contribuable
      this.loadTaxesForContribuable(this.formData.contribuable_id);
    }
  }

  loadTaxesForContribuable(contribuableId: number): void {
    this.loadingTaxes = true;
    this.apiService.getContribuableTaxes(contribuableId).subscribe({
      next: (data: any) => {
        this.taxesDisponibles = data.taxes || [];
        this.loadingTaxes = false;
        this.calculateTotal();
      },
      error: (err) => {
        console.error('Erreur chargement taxes:', err);
        this.error = 'Erreur lors du chargement des taxes';
        this.loadingTaxes = false;
      }
    });
  }

  onTaxeSelectionChange(): void {
    // Mettre à jour les items avec les taxes sélectionnées
    this.formData.items = this.taxesDisponibles
      .filter(taxe => taxe.selected)
      .map(taxe => ({
        taxe_id: taxe.taxe_id,
        montant: taxe.montant_custom || taxe.montant
      }));
    
    this.calculateTotal();
  }

  calculateTotal(): void {
    this.montantTotal = this.formData.items.reduce((sum, item) => sum + item.montant, 0);
  }

  onSubmit(): void {
    this.error = '';
    
    // Validation
    if (!this.formData.contribuable_id || this.formData.contribuable_id === 0) {
      this.error = 'Le contribuable est obligatoire';
      return;
    }
    
    if (this.formData.items.length === 0) {
      this.error = 'Sélectionnez au moins une taxe';
      return;
    }
    
    if (!this.formData.collecteur_id || this.formData.collecteur_id === 0) {
      this.error = 'Le collecteur est obligatoire';
      return;
    }

    if (!this.formData.type_paiement) {
      this.error = 'Le type de paiement est obligatoire';
      return;
    }

    this.loading = true;
    
    // Préparer les données pour l'API
    const collecteData: any = {
      contribuable_id: Number(this.formData.contribuable_id),
      collecteur_id: Number(this.formData.collecteur_id),
      type_paiement: this.formData.type_paiement,
      billetage: this.formData.billetage || undefined,
      date_collecte: this.formData.date_collecte ? new Date(this.formData.date_collecte).toISOString() : undefined,
      items: this.formData.items
    };
    
    this.apiService.createCollecte(collecteData).subscribe({
      next: () => {
        this.loading = false;
        this.resetForm();
        this.collecteCreated.emit();
      },
      error: (err) => {
        this.loading = false;
        this.error = err.error?.detail || 'Erreur lors de la création de la collecte';
      }
    });
  }

  resetForm(): void {
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    
    this.formData = {
      contribuable_id: 0,
      collecteur_id: 0,
      type_paiement: 'especes',
      billetage: undefined,
      date_collecte: today.toISOString().split('T')[0],
      items: []
    };
    this.selectedContribuable = undefined;
    this.taxesDisponibles = [];
    this.montantTotal = 0;
    this.error = '';
  }
}

