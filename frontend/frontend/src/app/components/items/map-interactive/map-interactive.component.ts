import { Component, OnInit, OnDestroy, AfterViewInit, OnChanges, SimpleChanges, inject, Input, Output, EventEmitter } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ApiService } from '../../../services/api.service';
import * as L from 'leaflet';

@Component({
  selector: 'app-map-interactive',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './map-interactive.component.html',
  styleUrl: './map-interactive.component.scss'
})
export class MapInteractiveComponent implements OnInit, AfterViewInit, OnDestroy, OnChanges {
  private apiService: ApiService = inject(ApiService);
  
  private map: L.Map | null = null;
  private payesLayer: L.LayerGroup | null = null;
  private partielsLayer: L.LayerGroup | null = null;
  private nonPayesLayer: L.LayerGroup | null = null;
  private markersPayes: L.Marker[] = [];
  private markersPartiels: L.Marker[] = [];
  private markersNonPayes: L.Marker[] = [];
  private hasInitialFit = false;
  private readonly gabonBounds = L.latLngBounds([-3.5, 8.2], [2.5, 15]);
  private readonly portGentilBounds = L.latLngBounds([-0.73, 8.75], [-0.70, 8.78]);
  private readonly portGentilCenter = L.latLng(-0.7175, 8.7700);
  
  @Input() filteredContribuables: any[] | null = null;
  @Input() showPayes = true;
  @Input() showPartiels = true;
  @Input() showNonPayes = true;
  
  @Output() contribuablesLoaded = new EventEmitter<any[]>();
  
  loading = false;
  contribuables: any[] = [];
  
  // Statistiques
  totalContribuables = 0;
  payes = 0;
  partiels = 0;
  nonPayes = 0;
  tauxPaiement = 0;
  montantCollecteTotal = 0;
  nombreCollectesTotal = 0;
  ticketMoyen = 0;

  ngOnInit(): void {}

  ngOnChanges(changes: SimpleChanges): void {
    if (changes['filteredContribuables'] && !changes['filteredContribuables'].firstChange) {
      const value = changes['filteredContribuables'].currentValue;
      if (Array.isArray(value)) {
        this.setFilteredContribuables(value);
      }
    }

    if ((changes['showPayes'] && !changes['showPayes'].firstChange) ||
        (changes['showNonPayes'] && !changes['showNonPayes'].firstChange)) {
      this.updateLayerVisibility();
    }
  }

  ngAfterViewInit(): void {
    this.initMap();
    // Ne charger que si filteredContribuables n'est pas fourni
    if (!this.filteredContribuables) {
      this.loadContribuables();
    } else if (this.filteredContribuables.length > 0) {
      this.setFilteredContribuables(this.filteredContribuables);
    }
  }

  ngOnDestroy(): void {
    if (this.map) {
      this.map.remove();
    }
  }

  private initMap(): void {
    // Initialiser la carte centrée directement sur Port-Gentil avec un zoom rapproché
    this.map = L.map('map', {
      center: this.portGentilCenter,
      zoom: 14,
      zoomControl: true,
      scrollWheelZoom: true,
      maxBounds: this.gabonBounds.pad(0.5)
    });

    // Ajouter la couche de tuiles
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '© OpenStreetMap contributors',
      maxZoom: 19
    }).addTo(this.map);

    this.payesLayer = L.layerGroup().addTo(this.map);
    this.partielsLayer = L.layerGroup().addTo(this.map);
    this.nonPayesLayer = L.layerGroup().addTo(this.map);
    this.hasInitialFit = false;
    
    // Forcer le zoom initial sur Port-Gentil
    setTimeout(() => {
      if (this.map) {
        this.map.setView(this.portGentilCenter, 14);
      }
    }, 100);
  }

  private loadContribuables(): void {
    this.loading = true;
    this.apiService.getContribuablesForMap(true).subscribe({
      next: (data: any[]) => {
        this.contribuables = data;
        this.calculateStats(data);
        this.updateMarkers();
        this.contribuablesLoaded.emit(data);
        this.loading = false;
      },
      error: (err: any) => {
        console.error('Erreur chargement contribuables:', err);
        this.loading = false;
      }
    });
  }

  private calculateStats(contribuables: any[]): void {
    this.totalContribuables = contribuables.length;
    this.payes = contribuables.filter(c => c.statut_paiement === 'paye' || (c.statut_paiement === undefined && c.a_paye !== false)).length;
    this.partiels = contribuables.filter(c => c.statut_paiement === 'partiel').length;
    this.nonPayes = contribuables.filter(c => c.statut_paiement === 'impaye' || (c.statut_paiement === undefined && c.a_paye === false)).length;
    this.tauxPaiement = this.totalContribuables > 0 
      ? Math.round((this.payes / this.totalContribuables) * 100) 
      : 0;

    this.montantCollecteTotal = contribuables.reduce((sum, c) => {
      const montant = typeof c.total_collecte === 'string'
        ? parseFloat(c.total_collecte)
        : Number(c.total_collecte || 0);
      return sum + (isNaN(montant) ? 0 : montant);
    }, 0);

    this.nombreCollectesTotal = contribuables.reduce((sum, c) => {
      const nb = Number(c.nombre_collectes || 0);
      return sum + (isNaN(nb) ? 0 : nb);
    }, 0);

    this.ticketMoyen = this.nombreCollectesTotal > 0
      ? this.montantCollecteTotal / this.nombreCollectesTotal
      : 0;
  }

  private updateMarkers(): void {
    if (!this.map || !this.payesLayer || !this.partielsLayer || !this.nonPayesLayer) return;

    // Nettoyer les anciens marqueurs
    this.payesLayer.clearLayers();
    this.partielsLayer.clearLayers();
    this.nonPayesLayer.clearLayers();
    this.markersPayes = [];
    this.markersPartiels = [];
    this.markersNonPayes = [];

    // Créer des marqueurs stylisés avec popup
    for (const contrib of this.contribuables) {
      const lat = parseFloat(contrib.latitude);
      const lng = parseFloat(contrib.longitude);

      if (isNaN(lat) || isNaN(lng)) continue;

      // Déterminer le statut de paiement (utiliser statut_paiement si disponible, sinon a_paye)
      const statutPaiement = contrib.statut_paiement || (contrib.a_paye !== false ? 'paye' : 'impaye');
      
      let markerColor: string;
      let markerBorder: string;
      let pulseColor: string;
      
      if (statutPaiement === 'paye') {
        markerColor = '#10B981'; // Vert
        markerBorder = '#059669';
        pulseColor = 'rgba(16,185,129,0.35)';
      } else if (statutPaiement === 'partiel') {
        markerColor = '#F59E0B'; // Orange
        markerBorder = '#D97706';
        pulseColor = 'rgba(245,158,11,0.35)';
      } else {
        markerColor = '#EF4444'; // Rouge
        markerBorder = '#DC2626';
        pulseColor = 'rgba(239,68,68,0.35)';
      }

      const icon = L.divIcon({
        html: `
          <div class="map-marker">
            <span class="marker-dot" style="
              background:${markerColor};
              border:3px solid ${markerBorder};
            "></span>
            <span class="marker-pulse" style="background:${pulseColor};"></span>
          </div>
        `,
        className: 'contribuable-marker',
        iconSize: [22, 22],
        iconAnchor: [11, 11]
      });

      const marker = L.marker([lat, lng], {
        icon
      });
      
      // Stocker les données pour les statistiques du cluster et les popups
      (marker as any).contribuableData = contrib;

      const popupContent = this.createPopup(contrib);
      marker.bindPopup(popupContent, {
        maxWidth: 320,
        className: 'custom-popup'
      });

      if (statutPaiement === 'paye') {
        this.markersPayes.push(marker);
        this.payesLayer.addLayer(marker);
      } else if (statutPaiement === 'partiel') {
        this.markersPartiels.push(marker);
        this.partielsLayer.addLayer(marker);
      } else {
        this.markersNonPayes.push(marker);
        this.nonPayesLayer.addLayer(marker);
      }
    }

    this.updateLayerVisibility();

    const allMarkers = [...this.markersPayes, ...this.markersPartiels, ...this.markersNonPayes];
    if (this.map) {
      if (allMarkers.length === 1) {
        const point = allMarkers[0].getLatLng();
        this.map.setView(point, 16, { animate: this.hasInitialFit });
        this.hasInitialFit = true;
      } else if (allMarkers.length > 1) {
        // Centrer sur Port-Gentil avec tous les marqueurs visibles
        const bounds = L.featureGroup(allMarkers).getBounds();
        if (bounds.isValid()) {
          this.map.fitBounds(bounds, { 
            padding: [50, 50],
            animate: this.hasInitialFit, 
            maxZoom: 14 
          });
        } else {
          this.map.setView(this.portGentilCenter, 14);
        }
        this.hasInitialFit = true;
      } else {
        this.map.setView(this.portGentilCenter, 14);
      }
    }
  }

  private updateLayerVisibility(): void {
    if (!this.map || !this.payesLayer || !this.partielsLayer || !this.nonPayesLayer) return;

    if (this.map.hasLayer(this.payesLayer)) {
      this.map.removeLayer(this.payesLayer);
    }
    if (this.map.hasLayer(this.partielsLayer)) {
      this.map.removeLayer(this.partielsLayer);
    }
    if (this.map.hasLayer(this.nonPayesLayer)) {
      this.map.removeLayer(this.nonPayesLayer);
    }

    if (this.showPayes) {
      this.map.addLayer(this.payesLayer);
    }
    if (this.showPartiels) {
      this.map.addLayer(this.partielsLayer);
    }
    if (this.showNonPayes) {
      this.map.addLayer(this.nonPayesLayer);
    }
  }

  private createPopup(contrib: any): string {
    const aPaye = contrib.a_paye !== false;
    const statusColor = aPaye ? '#10B981' : '#EF4444';
    const statusText = aPaye ? 'Payé' : 'Non payé';
    const statusIcon = aPaye ? '✓' : '✗';

    return `
      <div style="padding: 12px; font-family: system-ui, -apple-system, sans-serif;">
        <div style="
          background: ${statusColor};
          color: white;
          padding: 8px 12px;
          border-radius: 8px 8px 0 0;
          margin: -12px -12px 12px -12px;
          font-weight: bold;
        ">
          ${statusIcon} ${statusText}
        </div>
        <div style="margin-bottom: 8px;">
          <strong style="font-size: 16px; color: #1f2937;">${contrib.nom} ${contrib.prenom || ''}</strong>
        </div>
        <div style="font-size: 14px; color: #6b7280; line-height: 1.6;">
          <div><strong>Téléphone:</strong> ${contrib.telephone || 'N/A'}</div>
          <div><strong>Quartier:</strong> ${contrib.quartier || 'N/A'}</div>
          ${contrib.zone ? `<div><strong>Zone:</strong> ${contrib.zone}</div>` : ''}
          ${contrib.total_collecte ? `<div><strong>Total collecté:</strong> ${contrib.total_collecte.toLocaleString('fr-FR')} FCFA</div>` : ''}
          ${contrib.nombre_collectes ? `<div><strong>Nombre de collectes:</strong> ${contrib.nombre_collectes}</div>` : ''}
        </div>
      </div>
    `;
  }

  // Méthode publique pour définir les contribuables filtrés
  setFilteredContribuables(contribuables: any[]): void {
    const list = Array.isArray(contribuables) ? contribuables : [];
    this.contribuables = list;
    this.hasInitialFit = false;
    this.calculateStats(list);
    this.updateMarkers();
    this.refreshView();
  }

  // Méthode pour zoomer sur un point
  zoomToPoint(latitude: number, longitude: number, zoom: number = 16): void {
    if (this.map) {
      this.map.setView([latitude, longitude], zoom, { animate: true });
    }
  }

  zoomToPortGentil(): void {
    if (this.map) {
      this.map.fitBounds(this.portGentilBounds, { maxZoom: 14, animate: true });
      this.hasInitialFit = true;
    }
  }

  refreshView(): void {
    if (this.map) {
      setTimeout(() => {
        this.map?.invalidateSize();
      }, 50);
    }
  }

  formatCurrency(amount: number): string {
    return new Intl.NumberFormat('fr-FR', {
      style: 'currency',
      currency: 'XAF',
      minimumFractionDigits: 0
    }).format(amount || 0);
  }

  formatNumber(value: number): string {
    return new Intl.NumberFormat('fr-FR').format(value || 0);
  }
}
