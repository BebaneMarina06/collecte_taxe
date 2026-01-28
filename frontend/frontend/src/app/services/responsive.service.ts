import { Injectable, effect } from '@angular/core';
import { signal, Signal } from '@angular/core';

export interface ResponsiveConfig {
  mobileBreakpoint: number;
  tabletBreakpoint: number;
  desktopBreakpoint: number;
  enableZoom: boolean;
  mobileZoom: number;
  tabletZoom: number;
  desktopZoom: number;
}

export type DeviceType = 'mobile' | 'tablet' | 'desktop' | 'largeDesktop';

@Injectable({
  providedIn: 'root'
})
export class ResponsiveService {
  private readonly defaultConfig: ResponsiveConfig = {
    mobileBreakpoint: 480,
    tabletBreakpoint: 768,
    desktopBreakpoint: 1024,
    enableZoom: true,
    mobileZoom: 0.85,    // 85% zoom sur mobile
    tabletZoom: 0.95,    // 95% zoom sur tablette
    desktopZoom: 1.0,    // 100% sur desktop normal
  };

  private config: ResponsiveConfig = { ...this.defaultConfig };
  
  // Signals pour la réactivité
  public windowWidth = signal<number>(this.getWindowWidth());
  public windowHeight = signal<number>(this.getWindowHeight());
  public deviceType = signal<DeviceType>(this.calculateDeviceType());
  public currentZoom = signal<number>(this.calculateZoom());
  public isMobile = signal<boolean>(this.isCurrentlyMobile());
  public isTablet = signal<boolean>(this.isCurrentlyTablet());
  public isDesktop = signal<boolean>(this.isCurrentlyDesktop());

  constructor() {
    this.initResizeListener();
    this.setupEffects();
  }

  /**
   * Initialise l'écouteur de redimensionnement de fenêtre
   */
  private initResizeListener(): void {
    window.addEventListener('resize', () => this.onWindowResize());
    window.addEventListener('orientationchange', () => this.onWindowResize());
  }

  /**
   * Gère le redimensionnement de la fenêtre
   */
  private onWindowResize(): void {
    const newWidth = this.getWindowWidth();
    const newHeight = this.getWindowHeight();

    if (
      newWidth !== this.windowWidth() ||
      newHeight !== this.windowHeight()
    ) {
      this.windowWidth.set(newWidth);
      this.windowHeight.set(newHeight);
      this.updateDeviceType();
      this.updateZoom();
    }
  }

  /**
   * Récupère la largeur actuelle de la fenêtre
   */
  private getWindowWidth(): number {
    return typeof window !== 'undefined'
      ? Math.max(window.innerWidth, document.documentElement.clientWidth)
      : 0;
  }

  /**
   * Récupère la hauteur actuelle de la fenêtre
   */
  private getWindowHeight(): number {
    return typeof window !== 'undefined'
      ? Math.max(window.innerHeight, document.documentElement.clientHeight)
      : 0;
  }

  /**
   * Calcule le type d'appareil basé sur la largeur de l'écran
   */
  private calculateDeviceType(): DeviceType {
    const width = this.windowWidth();

    if (width < this.config.mobileBreakpoint) return 'mobile';
    if (width < this.config.tabletBreakpoint) return 'tablet';
    if (width < this.config.desktopBreakpoint) return 'desktop';
    return 'largeDesktop';
  }

  /**
   * Met à jour le type d'appareil
   */
  private updateDeviceType(): void {
    const newDeviceType = this.calculateDeviceType();
    if (newDeviceType !== this.deviceType()) {
      this.deviceType.set(newDeviceType);
    }
  }

  /**
   * Calcule le zoom optimal basé sur la largeur et le type d'appareil
   */
  private calculateZoom(): number {
    if (!this.config.enableZoom) return 1;

    const width = this.windowWidth();
    const deviceType = this.deviceType();

    switch (deviceType) {
      case 'mobile':
        // Sur mobile: dézoomer progressivement selon la largeur
        if (width < 360) return this.config.mobileZoom - 0.05; // 80%
        if (width < 480) return this.config.mobileZoom;         // 85%
        return 0.9;                                              // 90%

      case 'tablet':
        // Sur tablette: ajustement léger
        if (width < 600) return 0.9;
        return this.config.tabletZoom;                           // 95%

      case 'desktop':
        // Sur desktop classique: 100%
        return this.config.desktopZoom;                          // 100%

      case 'largeDesktop':
        // Sur grand écran: zoom à 67% comme demandé pour éviter l'espace vide
        return width > 1920 ? 0.67 : 1.0;

      default:
        return 1.0;
    }
  }

  /**
   * Met à jour le zoom et l'applique au DOM
   */
  private updateZoom(): void {
    const newZoom = this.calculateZoom();
    if (newZoom !== this.currentZoom()) {
      this.currentZoom.set(newZoom);
      this.applyZoom(newZoom);
    }
  }

  /**
   * Applique le zoom au document
   */
  private applyZoom(zoomLevel: number): void {
    if (typeof document !== 'undefined') {
      const html = document.documentElement;
      const scale = Math.round(zoomLevel * 100);
      
      // Appliquer le zoom via CSS transform et viewport
      html.style.transform = `scale(${zoomLevel})`;
      html.style.transformOrigin = '0 0';
      html.style.width = `${100 / zoomLevel}%`;
      html.style.height = `${100 / zoomLevel}%`;

      // Alternative avec zoom CSS (plus supportée par les navigateurs modernes)
      (html.style as any).zoom = scale + '%';

      console.log(
        `[ResponsiveService] Zoom appliqué: ${scale}% (Device: ${this.deviceType()}, Width: ${this.windowWidth()}px)`
      );
    }
  }

  /**
   * Configure le service avec une configuration personnalisée
   */
  public setConfig(config: Partial<ResponsiveConfig>): void {
    this.config = { ...this.config, ...config };
    this.updateDeviceType();
    this.updateZoom();
  }

  /**
   * Retourne la configuration actuelle
   */
  public getConfig(): ResponsiveConfig {
    return { ...this.config };
  }

  /**
   * Vérifie si l'écran est mobile
   */
  private isCurrentlyMobile(): boolean {
    return this.deviceType() === 'mobile';
  }

  /**
   * Vérifie si l'écran est tablette
   */
  private isCurrentlyTablet(): boolean {
    return this.deviceType() === 'tablet';
  }

  /**
   * Vérifie si l'écran est desktop
   */
  private isCurrentlyDesktop(): boolean {
    return ['desktop', 'largeDesktop'].includes(this.deviceType());
  }

  /**
   * Configure les effets réactifs pour les signaux
   */
  private setupEffects(): void {
    // Mettre à jour les signaux booléens
    effect(() => {
      this.isMobile.set(this.isCurrentlyMobile());
    });

    effect(() => {
      this.isTablet.set(this.isCurrentlyTablet());
    });

    effect(() => {
      this.isDesktop.set(this.isCurrentlyDesktop());
    });

    // Appliquer le zoom quand il change
    effect(() => {
      const zoom = this.currentZoom();
      this.applyZoom(zoom);
    });
  }

  /**
   * Retourne un signal booléen pour une requête média personnalisée
   */
  public matchMedia(query: string): Signal<boolean> {
    const signal = signalWithMediaQuery(query);
    return signal;
  }

  /**
   * Force un recalcul du zoom (utile après certaines opérations)
   */
  public recalculateZoom(): void {
    this.updateZoom();
  }

  /**
   * Retourne la largeur disponible en pixels réels (sans zoom)
   */
  public getRealWidth(): number {
    return this.windowWidth() / this.currentZoom();
  }

  /**
   * Retourne la hauteur disponible en pixels réels (sans zoom)
   */
  public getRealHeight(): number {
    return this.windowHeight() / this.currentZoom();
  }
}

/**
 * Crée un signal réactif pour une media query
 */

function signalWithMediaQuery(query: string): Signal<boolean> {
  const mediaSignal = signal<boolean>(false);

  if (typeof window !== 'undefined') {
    const mediaQuery = window.matchMedia(query);
    mediaSignal.set(mediaQuery.matches);

    mediaQuery.addEventListener('change', (e) => {
      mediaSignal.set(e.matches);
    });
  }

  return mediaSignal;
}
