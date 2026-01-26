import { Component, EventEmitter, Output, OnInit, inject, ViewChild, ElementRef, AfterViewInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ApiService } from '../../../../services/api.service';
import { ContribuableCreate } from '../../../../interfaces/contribuable.interface';
import { Zone } from '../../../../interfaces/zone.interface';
import { Quartier } from '../../../../interfaces/quartier.interface';
import { TypeContribuable } from '../../../../interfaces/type-contribuable.interface';
import { Collecteur } from '../../../../interfaces/collecteur.interface';

@Component({
  selector: 'app-create-client',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './create-client.component.html',
  styleUrl: './create-client.component.scss'
})
export class CreateClientComponent implements OnInit, AfterViewInit {
  @Output() clientCreated = new EventEmitter<void>();
  @ViewChild('modalContent', { static: false }) modalContentRef!: ElementRef<HTMLElement>;
  
  private apiService = inject(ApiService);
  
  activeEmail: boolean = false;
  loading: boolean = false;
  error: string = '';
  
  // Form data
  formData: ContribuableCreate = {
    nom: '',
    prenom: '',
    email: '',
    telephone: '',
    type_contribuable_id: 0,
    quartier_id: 0,
    collecteur_id: 0,
    adresse: '',
    nom_activite: '',
    photo_url: '',
    numero_identification: '',
    latitude: undefined,
    longitude: undefined,
    actif: true
  };

  // Photo upload
  selectedPhoto: File | null = null;
  photoPreview: string | null = null;

  // Géolocalisation
  geolocationStatus: 'idle' | 'loading' | 'success' | 'error' = 'idle';
  geolocationError: string = '';
  canGetLocation: boolean = false;
  
  // Options
  zones: Zone[] = [];
  quartiers: Quartier[] = [];
  loadingZones: boolean = false;
  loadingQuartiers: boolean = false;
  typesContribuables: TypeContribuable[] = [];
  collecteurs: Collecteur[] = [];
  taxes: any[] = [];
  selectedZoneId: number | null = null;
  selectedTaxes: number[] = [];

  ngOnInit(): void {
    this.loadOptions();
    this.checkGeolocationSupport();
  }

  ngAfterViewInit(): void {
    // S'assurer que la référence est disponible
  }

  scrollToTop(): void {
    // Trouver l'élément scrollable du modal (modal-scrollable-content)
    const modalScrollable = document.querySelector('.modal-scrollable-content');
    if (modalScrollable) {
      modalScrollable.scrollTo({
        top: 0,
        behavior: 'smooth'
      });
    }
  }

  checkGeolocationSupport(): void {
    this.canGetLocation = 'geolocation' in navigator;
  }

  getCurrentLocation(): void {
    if (!this.canGetLocation) {
      this.geolocationError = 'La géolocalisation n\'est pas supportée par votre navigateur';
      return;
    }

    this.geolocationStatus = 'loading';
    this.geolocationError = '';

    navigator.geolocation.getCurrentPosition(
      (position) => {
        this.formData.latitude = position.coords.latitude;
        this.formData.longitude = position.coords.longitude;
        this.geolocationStatus = 'success';
        this.geolocationError = '';
        
        // Réinitialiser le statut après 3 secondes
        setTimeout(() => {
          if (this.geolocationStatus === 'success') {
            this.geolocationStatus = 'idle';
          }
        }, 3000);
      },
      (error) => {
        this.geolocationStatus = 'error';
        switch(error.code) {
          case error.PERMISSION_DENIED:
            this.geolocationError = 'Permission de géolocalisation refusée';
            break;
          case error.POSITION_UNAVAILABLE:
            this.geolocationError = 'Position indisponible';
            break;
          case error.TIMEOUT:
            this.geolocationError = 'Délai d\'attente dépassé';
            break;
          default:
            this.geolocationError = 'Erreur de géolocalisation';
            break;
        }
      },
      {
        enableHighAccuracy: true,
        timeout: 10000,
        maximumAge: 0
      }
    );
  }

  clearLocation(): void {
    this.formData.latitude = undefined;
    this.formData.longitude = undefined;
    this.geolocationStatus = 'idle';
    this.geolocationError = '';
  }

  onPhotoSelected(event: Event): void {
    const input = event.target as HTMLInputElement;
    if (input.files && input.files[0]) {
      this.selectedPhoto = input.files[0];
      const reader = new FileReader();
      reader.onload = (e: any) => {
        this.photoPreview = e.target.result;
      };
      reader.readAsDataURL(this.selectedPhoto);
    }
  }

  removePhoto(): void {
    this.selectedPhoto = null;
    this.photoPreview = null;
    this.formData.photo_url = '';
    const input = document.getElementById('photo') as HTMLInputElement;
    if (input) {
      input.value = '';
    }
  }

  loadOptions(): void {
    // Charger les zones
    this.loadingZones = true;
    this.apiService.getZonesReferences(true).subscribe({
      next: (data) => {
        this.zones = Array.isArray(data) ? data : [];
        this.loadingZones = false;
        console.log('Zones chargées:', this.zones.length, 'zones');
      },
      error: (err) => {
        console.error('Erreur chargement zones:', err);
        this.loadingZones = false;
        this.zones = [];
        this.error = 'Erreur lors du chargement des zones. Veuillez réessayer.';
      }
    });

    // Charger les types de contribuables
    this.apiService.getTypesContribuables(true).subscribe({
      next: (data) => this.typesContribuables = data,
      error: (err) => console.error('Erreur chargement types:', err)
    });

    // Charger les collecteurs actifs
    this.apiService.getCollecteurs({ actif: true, limit: 1000 }).subscribe({
      next: (data) => this.collecteurs = data,
      error: (err) => console.error('Erreur chargement collecteurs:', err)
    });

    // Charger les taxes actives
    this.apiService.getTaxes({ actif: true, limit: 1000 }).subscribe({
      next: (data) => {
        this.taxes = Array.isArray(data) ? data : [];
      },
      error: (err) => console.error('Erreur chargement taxes:', err)
    });
  }

  onZoneChange(zoneId: number | string): void {
    // Convertir en nombre si c'est une string
    const zoneIdNum = typeof zoneId === 'string' ? parseInt(zoneId, 10) : zoneId;
    
    if (!zoneIdNum || isNaN(zoneIdNum)) {
      this.selectedZoneId = null;
      this.quartiers = [];
      this.formData.quartier_id = 0;
      return;
    }
    
    this.selectedZoneId = zoneIdNum;
    this.formData.quartier_id = 0;
    this.loadingQuartiers = true;
    this.quartiers = [];
    this.apiService.getQuartiers(zoneIdNum, true).subscribe({
      next: (data) => {
        this.quartiers = Array.isArray(data) ? data : [];
        this.loadingQuartiers = false;
        console.log('Quartiers chargés pour zone', zoneIdNum, ':', this.quartiers.length, 'quartiers');
      },
      error: (err) => {
        console.error('Erreur chargement quartiers:', err);
        this.loadingQuartiers = false;
        this.quartiers = [];
        this.error = 'Erreur lors du chargement des quartiers. Veuillez réessayer.';
      }
    });
  }

  onToggleActiveEmail(active: boolean): void {
    this.activeEmail = active;
    if (!active) {
      this.formData.email = '';
    }
  }

  onSubmit(): void {
    // Faire défiler vers le haut pour voir les messages
    this.scrollToTop();
    
    // Réinitialiser le message d'erreur au début
    this.error = '';
    
    // Validation
    if (!this.formData.nom || !this.formData.telephone) {
      this.error = 'Le nom et le téléphone sont obligatoires';
      return;
    }
    
    if (!this.formData.adresse || this.formData.adresse.trim() === '') {
      this.error = 'L\'adresse complète est obligatoire';
      return;
    }
    
    if (!this.formData.type_contribuable_id || this.formData.type_contribuable_id === 0) {
      this.error = 'Veuillez sélectionner un type de contribuable';
      return;
    }
    
    if (!this.formData.quartier_id || this.formData.quartier_id === 0) {
      this.error = 'Veuillez sélectionner un quartier. Assurez-vous d\'avoir sélectionné une zone.';
      return;
    }
    
    if (!this.formData.collecteur_id || this.formData.collecteur_id === 0) {
      this.error = 'Veuillez sélectionner un collecteur';
      return;
    }

    this.loading = true;
    
    // Préparer les données
    const data: any = {
      nom: this.formData.nom,
      prenom: this.formData.prenom || undefined,
      telephone: this.formData.telephone,
      type_contribuable_id: this.formData.type_contribuable_id,
      quartier_id: this.formData.quartier_id,
      collecteur_id: this.formData.collecteur_id,
      adresse: this.formData.adresse || undefined,
      numero_identification: this.formData.numero_identification || undefined,
      actif: this.formData.actif
    };
    
    if (this.activeEmail && this.formData.email) {
      data.email = this.formData.email;
    }

    // Ajouter les coordonnées GPS si disponibles
    if (this.formData.latitude !== undefined && this.formData.longitude !== undefined) {
      data.latitude = this.formData.latitude;
      data.longitude = this.formData.longitude;
    }

    // Ajouter nom_activite si fourni
    if (this.formData.nom_activite) {
      data.nom_activite = this.formData.nom_activite;
    }

    // Ajouter les taxes sélectionnées
    if (this.selectedTaxes && this.selectedTaxes.length > 0) {
      data.taxes_ids = this.selectedTaxes;
    }

    // Upload photo si sélectionnée
    if (this.selectedPhoto) {
      this.error = ''; // Réinitialiser l'erreur avant l'upload
      this.apiService.uploadPhoto(this.selectedPhoto).subscribe({
        next: (uploadResponse) => {
          // Construire l'URL complète
          const apiBaseUrl = 'http://localhost:8000'; // TODO: utiliser environment.apiUrl
          data.photo_url = uploadResponse.url.startsWith('http') 
            ? uploadResponse.url 
            : `${apiBaseUrl}${uploadResponse.url}`;
          // Continuer avec la création du contribuable
          this.createContribuableWithData(data);
        },
        error: (err) => {
          this.loading = false;
          const errorMessage = err.error?.detail || err.error?.message || err.message || 'Erreur lors de l\'upload de la photo';
          this.error = errorMessage;
          console.error('Erreur upload photo:', err);
        }
      });
      return; // Sortir, la création se fera dans le callback
    }

    // Si pas de photo, créer directement
    this.createContribuableWithData(data);
  }

  private createContribuableWithData(data: any): void {
    // Réinitialiser le message d'erreur avant la requête
    this.error = '';
    
    this.apiService.createContribuable(data).subscribe({
      next: (response) => {
        console.log('Contribuable créé avec succès:', response);
        // S'assurer que le message d'erreur est effacé avant d'émettre l'événement
        this.error = '';
        this.loading = false;
        // Faire défiler vers le haut pour voir le message de succès (s'il y en a un)
        setTimeout(() => {
          this.scrollToTop();
        }, 50);
        // Émettre l'événement pour fermer le modal
        this.clientCreated.emit();
        // Réinitialiser le formulaire après un court délai pour permettre la fermeture du modal
        setTimeout(() => {
          this.resetForm();
        }, 100);
      },
      error: (err) => {
        this.loading = false;
        // Vérifier si c'est vraiment une erreur ou une réponse inattendue
        console.error('Erreur création contribuable - Détails complets:', {
          status: err.status,
          statusText: err.statusText,
          error: err.error,
          message: err.message
        });
        
        // Si le status est 201 (Created), c'est un succès malgré l'erreur
        if (err.status === 201 || (err.error && typeof err.error === 'object' && 'id' in err.error)) {
          console.log('Création réussie malgré le traitement comme erreur');
          this.error = '';
          this.clientCreated.emit();
          setTimeout(() => {
            this.resetForm();
          }, 100);
          return;
        }
        
        const errorMessage = err.error?.detail || err.error?.message || err.message || 'Erreur lors de la création du contribuable';
        this.error = errorMessage;
        // Faire défiler vers le haut pour voir le message d'erreur
        setTimeout(() => {
          this.scrollToTop();
        }, 50);
      }
    });
  }

  resetForm(): void {
    this.formData = {
      nom: '',
      prenom: '',
      email: '',
      telephone: '',
      type_contribuable_id: 0,
      quartier_id: 0,
      collecteur_id: 0,
      adresse: '',
      nom_activite: '',
      photo_url: '',
      numero_identification: '',
      latitude: undefined,
      longitude: undefined,
      actif: true
    };
    this.selectedZoneId = null;
    this.quartiers = [];
    this.selectedTaxes = [];
    this.error = '';
    this.geolocationStatus = 'idle';
    this.geolocationError = '';
    this.removePhoto();
  }

  onTaxeToggle(taxeId: number): void {
    const index = this.selectedTaxes.indexOf(taxeId);
    if (index > -1) {
      this.selectedTaxes.splice(index, 1);
    } else {
      this.selectedTaxes.push(taxeId);
    }
  }

  isTaxeSelected(taxeId: number): boolean {
    return this.selectedTaxes.includes(taxeId);
  }
}
