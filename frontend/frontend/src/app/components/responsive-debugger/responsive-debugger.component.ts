import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ResponsiveService, DeviceType } from '../services/responsive.service';

/**
 * Composant de débogage pour afficher les informations de responsivité
 * À utiliser uniquement en développement
 */
@Component({
  selector: 'app-responsive-debugger',
  standalone: true,
  imports: [CommonModule],
  template: `
    <div 
      class="responsive-debugger"
      *ngIf="isDevMode"
      [@.disabled]
    >
      <div class="debugger-content">
        <h3>📱 Info Responsivité</h3>
        
        <div class="info-grid">
          <div class="info-item">
            <label>Type d'appareil:</label>
            <span class="badge">{{ responsiveService.deviceType() }}</span>
          </div>
          
          <div class="info-item">
            <label>Largeur:</label>
            <span>{{ responsiveService.windowWidth() }}px</span>
          </div>
          
          <div class="info-item">
            <label>Hauteur:</label>
            <span>{{ responsiveService.windowHeight() }}px</span>
          </div>
          
          <div class="info-item">
            <label>Zoom actuel:</label>
            <span class="badge-zoom">{{ (responsiveService.currentZoom() * 100) | number: '1.0-0' }}%</span>
          </div>
          
          <div class="info-item">
            <label>Mobile:</label>
            <span [class.active]="responsiveService.isMobile()">
              {{ responsiveService.isMobile() ? '✓' : '✗' }}
            </span>
          </div>
          
          <div class="info-item">
            <label>Tablette:</label>
            <span [class.active]="responsiveService.isTablet()">
              {{ responsiveService.isTablet() ? '✓' : '✗' }}
            </span>
          </div>
          
          <div class="info-item">
            <label>Desktop:</label>
            <span [class.active]="responsiveService.isDesktop()">
              {{ responsiveService.isDesktop() ? '✓' : '✗' }}
            </span>
          </div>
        </div>
      </div>
    </div>
  `,
  styles: [`
    .responsive-debugger {
      position: fixed;
      bottom: 20px;
      right: 20px;
      z-index: 9999;
      background: rgba(30, 41, 59, 0.95);
      color: #f8fafc;
      border: 1px solid #64748b;
      border-radius: 8px;
      padding: 12px;
      font-size: 12px;
      font-family: monospace;
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
      backdrop-filter: blur(10px);
      max-width: 280px;
    }

    .debugger-content h3 {
      margin: 0 0 12px 0;
      font-size: 13px;
      font-weight: 600;
      text-transform: uppercase;
      letter-spacing: 0.05em;
      color: #cbd5e1;
    }

    .info-grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 8px;
    }

    .info-item {
      display: flex;
      flex-direction: column;
      gap: 2px;
    }

    .info-item label {
      font-size: 11px;
      color: #94a3b8;
      font-weight: 600;
      text-transform: uppercase;
    }

    .info-item span {
      font-size: 12px;
      color: #f8fafc;
    }

    .badge {
      display: inline-block;
      background: #3b82f6;
      padding: 2px 6px;
      border-radius: 4px;
      font-size: 11px;
      font-weight: 600;
      text-align: center;
    }

    .badge-zoom {
      display: inline-block;
      background: #10b981;
      padding: 2px 6px;
      border-radius: 4px;
      font-size: 11px;
      font-weight: 600;
      text-align: center;
    }

    .info-item span.active {
      color: #10b981;
      font-weight: 700;
    }

    @media (max-width: 480px) {
      .responsive-debugger {
        bottom: 10px;
        right: 10px;
        padding: 8px;
        max-width: 200px;
      }

      .info-grid {
        grid-template-columns: 1fr;
      }
    }
  `]
})
export class ResponsiveDebuggerComponent {
  isDevMode = !this.isProduction();

  constructor(public responsiveService: ResponsiveService) {}

  private isProduction(): boolean {
    return false; // Changer à true en production si nécessaire
  }
}
