import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ApiService } from '../../../../../services/api.service';
import { ModalComponent } from '../../../../items/modal/modal.component';
import { ServiceMunicipal, ServiceMunicipalCreate } from '../../../../../interfaces/parametrage.interface';

@Component({
  selector: 'app-gestion-services',
  standalone: true,
  imports: [CommonModule, FormsModule, ModalComponent],
  templateUrl: './gestion-services.component.html',
  styleUrl: './gestion-services.component.scss'
})
export class GestionServicesComponent implements OnInit {
  private apiService = inject(ApiService);

  services: ServiceMunicipal[] = [];
  loading: boolean = true;
  searchTerm: string = '';
  activeModal: boolean = false;
  selectedService: ServiceMunicipal | null = null;
  isEditMode: boolean = false;

  // Formulaire
  serviceForm: ServiceMunicipalCreate = {
    nom: '',
    code: '',
    description: '',
    responsable: '',
    telephone: '',
    email: '',
    actif: true
  };

  // Services municipaux pré-définis
  servicesDefault = [
    { nom: 'Direction des Finances', code: 'DIR-FIN', description: 'Gestion des finances municipales', responsable: '', telephone: '', email: '' },
    { nom: 'Direction de l\'Urbanisme', code: 'DIR-URB', description: 'Urbanisme et aménagement du territoire', responsable: '', telephone: '', email: '' },
    { nom: 'Direction de l\'Hygiène et Salubrité', code: 'DIR-HYG', description: 'Hygiène publique et salubrité', responsable: '', telephone: '', email: '' },
    { nom: 'Direction des Affaires Sociales', code: 'DIR-SOC', description: 'Affaires sociales et action sociale', responsable: '', telephone: '', email: '' },
    { nom: 'Direction de la Communication', code: 'DIR-COM', description: 'Communication municipale', responsable: '', telephone: '', email: '' },
    { nom: 'Direction des Marchés', code: 'DIR-MAR', description: 'Gestion des marchés municipaux', responsable: '', telephone: '', email: '' },
    { nom: 'Direction de l\'État Civil', code: 'DIR-EC', description: 'État civil et documentation', responsable: '', telephone: '', email: '' },
    { nom: 'Direction des Ressources Humaines', code: 'DIR-RH', description: 'Gestion du personnel municipal', responsable: '', telephone: '', email: '' },
    { nom: 'Direction Technique', code: 'DIR-TECH', description: 'Services techniques et infrastructures', responsable: '', telephone: '', email: '' },
    { nom: 'Direction de l\'Environnement', code: 'DIR-ENV', description: 'Environnement et développement durable', responsable: '', telephone: '', email: '' },
    { nom: 'Service de Collecte des Taxes', code: 'SRV-TAX', description: 'Collecte et recouvrement des taxes', responsable: '', telephone: '', email: '' },
    { nom: 'Service du Patrimoine', code: 'SRV-PAT', description: 'Gestion du patrimoine municipal', responsable: '', telephone: '', email: '' }
  ];

  ngOnInit(): void {
    this.loadServices();
  }

  loadServices(): void {
    this.loading = true;
    this.apiService.getServicesMunicipaux({ actif: true }).subscribe({
      next: (data: ServiceMunicipal[]) => {
        this.services = data;
        this.loading = false;
      },
      error: (err) => {
        console.error('Erreur lors du chargement des services:', err);
        // Si l'endpoint n'existe pas encore, utiliser les données par défaut
        this.services = this.servicesDefault.map((s, i) => ({
          id: i + 1,
          nom: s.nom,
          code: s.code,
          description: s.description,
          responsable: s.responsable,
          telephone: s.telephone,
          email: s.email,
          actif: true,
          created_at: new Date().toISOString(),
          updated_at: new Date().toISOString()
        }));
        this.loading = false;
      }
    });
  }

  onSearch(): void {
    if (!this.searchTerm) {
      this.loadServices();
      return;
    }
    this.services = this.services.filter(s =>
      s.nom.toLowerCase().includes(this.searchTerm.toLowerCase()) ||
      s.code.toLowerCase().includes(this.searchTerm.toLowerCase()) ||
      s.description?.toLowerCase().includes(this.searchTerm.toLowerCase())
    );
  }

  openCreateModal(): void {
    this.isEditMode = false;
    this.selectedService = null;
    this.resetForm();
    this.activeModal = true;
  }

  openEditModal(service: ServiceMunicipal): void {
    this.isEditMode = true;
    this.selectedService = service;
    this.serviceForm = {
      nom: service.nom,
      code: service.code,
      description: service.description || '',
      responsable: service.responsable || '',
      telephone: service.telephone || '',
      email: service.email || '',
      actif: service.actif
    };
    this.activeModal = true;
  }

  closeModal(): void {
    this.activeModal = false;
    this.resetForm();
  }

  resetForm(): void {
    this.serviceForm = {
      nom: '',
      code: '',
      description: '',
      responsable: '',
      telephone: '',
      email: '',
      actif: true
    };
  }

  saveService(): void {
    if (!this.serviceForm.nom || !this.serviceForm.code) {
      alert('Veuillez remplir tous les champs obligatoires');
      return;
    }

    if (this.isEditMode && this.selectedService) {
      this.apiService.updateServiceMunicipal(this.selectedService.id, this.serviceForm).subscribe({
        next: () => {
          this.loadServices();
          this.closeModal();
        },
        error: (err) => {
          console.error('Erreur lors de la mise à jour:', err);
          alert('Erreur lors de la mise à jour du service municipal');
        }
      });
    } else {
      this.apiService.createServiceMunicipal(this.serviceForm).subscribe({
        next: () => {
          this.loadServices();
          this.closeModal();
        },
        error: (err) => {
          console.error('Erreur lors de la création:', err);
          alert('Erreur lors de la création du service municipal');
        }
      });
    }
  }

  deleteService(service: ServiceMunicipal): void {
    if (confirm(`Êtes-vous sûr de vouloir supprimer le service "${service.nom}" ?`)) {
      this.apiService.deleteServiceMunicipal(service.id).subscribe({
        next: () => {
          this.loadServices();
        },
        error: (err) => {
          console.error('Erreur lors de la suppression:', err);
          alert('Erreur lors de la suppression du service municipal');
        }
      });
    }
  }

  toggleActif(service: ServiceMunicipal): void {
    this.apiService.updateServiceMunicipal(service.id, { actif: !service.actif }).subscribe({
      next: () => {
        this.loadServices();
      },
      error: (err) => {
        console.error('Erreur lors de la mise à jour:', err);
      }
    });
  }

  // Charger les données par défaut
  loadDefaultData(): void {
    if (confirm('Voulez-vous charger les services municipaux pré-définis ?')) {
      let count = 0;
      this.servicesDefault.forEach(service => {
        this.apiService.createServiceMunicipal(service).subscribe({
          next: () => {
            count++;
            if (count === this.servicesDefault.length) {
              this.loadServices();
              alert('Services municipaux chargés avec succès !');
            }
          },
          error: (err) => {
            console.error('Erreur lors de la création:', err);
          }
        });
      });
    }
  }
}
