import { Component, EventEmitter, Output, OnInit, Input, inject, AfterViewInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ApiService } from '../../../../services/api.service';
import { CollecteurCreate, CollecteurUpdate, Collecteur } from '../../../../interfaces/collecteur.interface';
import { Zone } from '../../../../interfaces/zone.interface';

@Component({
  selector: 'app-create-collecteur',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './create-collecteur.component.html',
  styleUrl: './create-collecteur.component.scss'
})
export class CreateCollecteurComponent implements OnInit, AfterViewInit {
  @Input() collecteur: Collecteur | null = null;
  @Output() collecteurCreated = new EventEmitter<void>();
  
  private apiService = inject(ApiService);
  
  loading: boolean = false;
  error: string = '';
  isEditMode: boolean = false;
  
  // Zones disponibles
  zones: Zone[] = [];
  loadingZones: boolean = false;

  ngAfterViewInit(): void {
    // S'assurer que la référence est disponible
  }

  scrollToTop(): void {
    // Utiliser setTimeout pour s'assurer que le DOM est mis à jour
    setTimeout(() => {
      // Essayer plusieurs sélecteurs pour trouver l'élément scrollable
      let modalScrollable: HTMLElement | null = null;
      
      // Chercher dans le modal actif
      const activeModal = document.querySelector('.modal.active');
      if (activeModal) {
        modalScrollable = activeModal.querySelector('.modal-scrollable-content') as HTMLElement;
      }
      
      // Si pas trouvé, chercher directement
      if (!modalScrollable) {
        modalScrollable = document.querySelector('.modal-scrollable-content') as HTMLElement;
      }
      
      if (modalScrollable) {
        // Scroll vers le haut
        modalScrollable.scrollTo({
          top: 0,
          behavior: 'smooth'
        });
        
        // Essayer aussi de scroller vers le message d'erreur s'il existe
        const errorElement = modalScrollable.querySelector('.bg-red-100, .bg-red-50');
        if (errorElement) {
          errorElement.scrollIntoView({
            behavior: 'smooth',
            block: 'start',
            inline: 'nearest'
          });
        }
      } else {
        // Fallback: utiliser window.scrollTo si l'élément n'est pas trouvé
        window.scrollTo({
          top: 0,
          behavior: 'smooth'
        });
      }
    }, 100);
  }

  private removeUndefinedFields(obj: any): any {
    const cleaned: any = {};
    for (const key in obj) {
      if (obj[key] !== undefined && obj[key] !== null && obj[key] !== '') {
        cleaned[key] = obj[key];
      }
    }
    return cleaned;
  }
  
  // Form data
  formData: CollecteurCreate = {
    nom: '',
    prenom: '',
    email: '',
    telephone: '',
    matricule: '',
    zone_id: undefined,
    heure_cloture: undefined
  };

  ngOnInit(): void {
    // Charger les zones disponibles
    this.loadZones();
    
    if (this.collecteur) {
      this.isEditMode = true;
      this.formData = {
        nom: this.collecteur.nom || '',
        prenom: this.collecteur.prenom || '',
        email: this.collecteur.email || '',
        telephone: this.collecteur.telephone || '',
        matricule: this.collecteur.matricule || '',
        zone_id: this.collecteur.zone_id,
        heure_cloture: this.collecteur.heure_cloture || undefined
      };
    }
  }

  loadZones(): void {
    this.loadingZones = true;
    this.apiService.getZonesReferences(true).subscribe({
      next: (data) => {
        this.zones = Array.isArray(data) ? data : [];
        this.loadingZones = false;
        console.log('Zones chargées pour collecteur:', this.zones.length, 'zones');
      },
      error: (err) => {
        console.error('Erreur chargement zones:', err);
        this.loadingZones = false;
        this.zones = [];
      }
    });
  }

  onSubmit(event?: Event): void {
    // Empêcher le comportement par défaut du formulaire
    if (event) {
      event.preventDefault();
      event.stopPropagation();
    }
    
    console.log('onSubmit appelé, formData:', this.formData);
    
    // Faire défiler vers le haut pour voir les messages
    this.scrollToTop();
    
    // Réinitialiser le message d'erreur au début
    this.error = '';
    
    // Validation
    if (!this.formData.nom || !this.formData.nom.trim()) {
      this.error = 'Le nom est obligatoire';
      this.scrollToTop();
      return;
    }
    
    if (!this.formData.prenom || !this.formData.prenom.trim()) {
      this.error = 'Le prénom est obligatoire';
      this.scrollToTop();
      return;
    }
    
    if (!this.formData.email || !this.formData.email.trim()) {
      this.error = 'L\'email est obligatoire';
      this.scrollToTop();
      return;
    }
    
    // Valider le format de l'email
    const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailPattern.test(this.formData.email.trim())) {
      this.error = 'Le format de l\'email est invalide';
      this.scrollToTop();
      return;
    }
    
    if (!this.formData.telephone || !this.formData.telephone.trim()) {
      this.error = 'Le téléphone est obligatoire';
      this.scrollToTop();
      return;
    }

    if (!this.formData.matricule || !this.formData.matricule.trim()) {
      this.error = 'Le matricule est obligatoire';
      this.scrollToTop();
      return;
    }

    console.log('Validation passée, démarrage de la création...');
    this.loading = true;
    
    if (this.isEditMode && this.collecteur) {
      // Mise à jour
      const updateData: CollecteurUpdate = {
        nom: this.formData.nom,
        prenom: this.formData.prenom,
        email: this.formData.email,
        telephone: this.formData.telephone,
        zone_id: this.formData.zone_id,
        heure_cloture: this.formData.heure_cloture
      };
      
      this.apiService.updateCollecteur(this.collecteur.id, updateData).subscribe({
        next: (response) => {
          console.log('Collecteur mis à jour avec succès:', response);
          this.loading = false;
          this.error = '';
          this.collecteurCreated.emit();
        },
        error: (err) => {
          this.loading = false;
          const errorMessage = err.error?.detail || err.error?.message || err.message || 'Erreur lors de la mise à jour du collecteur';
          this.error = errorMessage;
          console.error('Erreur mise à jour collecteur:', err);
          this.scrollToTop();
        }
      });
    } else {
      // Création - Nettoyer les données avant l'envoi
      const dataToSend: any = {
        nom: this.formData.nom.trim(),
        prenom: this.formData.prenom.trim(),
        email: this.formData.email.trim(),
        telephone: this.formData.telephone.trim(),
        matricule: this.formData.matricule.trim()
      };
      
      // Ne PAS envoyer zone_id s'il n'est pas valide ou s'il est 0
      // Le backend vérifiera si la zone existe, mais on évite d'envoyer des valeurs invalides
      if (this.formData.zone_id !== undefined && this.formData.zone_id !== null && this.formData.zone_id > 0) {
        // Convertir en nombre pour s'assurer que c'est un entier
        const zoneId = Number(this.formData.zone_id);
        if (!isNaN(zoneId) && zoneId > 0) {
          dataToSend.zone_id = zoneId;
        }
      }
      
      // Valider le format de l'heure_cloture (HH:MM)
      if (this.formData.heure_cloture && this.formData.heure_cloture.trim()) {
        const heureTrimmed = this.formData.heure_cloture.trim();
        // Vérifier le format HH:MM
        const heurePattern = /^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$/;
        if (heurePattern.test(heureTrimmed)) {
          dataToSend.heure_cloture = heureTrimmed;
        } else {
          this.error = 'Le format de l\'heure de clôture est invalide. Utilisez le format HH:MM (ex: 18:00)';
          this.loading = false;
          this.scrollToTop();
          return;
        }
      }
      
      // Nettoyer l'objet pour supprimer les champs undefined/null
      const cleanData = this.removeUndefinedFields(dataToSend);
      
      console.log('Données envoyées pour création collecteur:', cleanData);
      
      this.apiService.createCollecteur(cleanData).subscribe({
        next: (response) => {
          console.log('✅ Collecteur créé avec succès:', response);
          this.loading = false;
          this.error = '';
          this.resetForm();
          this.collecteurCreated.emit();
        },
        error: (err) => {
          this.loading = false;
          console.error('Erreur création collecteur - Détails complets:', {
            status: err.status,
            statusText: err.statusText,
            error: err.error,
            message: err.message,
            dataSent: cleanData
          });
          
          // Si le status est 201 (Created), c'est un succès malgré l'erreur
          if (err.status === 201 || (err.error && typeof err.error === 'object' && 'id' in err.error)) {
            console.log('Création réussie malgré le traitement comme erreur');
            this.error = '';
            this.resetForm();
            this.collecteurCreated.emit();
            return;
          }
          
          // Afficher les détails de validation si disponibles
          let errorMessage = 'Erreur lors de la création du collecteur';
          if (err.error) {
            if (typeof err.error === 'string') {
              errorMessage = err.error;
            } else if (err.error.detail) {
              errorMessage = err.error.detail;
            } else if (Array.isArray(err.error)) {
              // Erreurs de validation Pydantic
              const validationErrors = err.error.map((e: any) => {
                const field = e.loc?.join('.') || 'champ';
                const msg = e.msg || 'Erreur de validation';
                return `${field}: ${msg}`;
              }).join(', ');
              errorMessage = `Erreurs de validation: ${validationErrors}`;
            } else if (err.error.message) {
              errorMessage = err.error.message;
            } else if (err.error.error) {
              errorMessage = err.error.error;
            }
          } else if (err.message) {
            errorMessage = err.message;
          }
          
          this.error = errorMessage;
          console.error('Message d\'erreur final:', errorMessage);
          this.scrollToTop();
        }
      });
    }
  }

  resetForm(): void {
    this.formData = {
      nom: '',
      prenom: '',
      email: '',
      telephone: '',
      matricule: '',
      zone_id: undefined,
      heure_cloture: undefined
    };
    this.error = '';
  }
}

