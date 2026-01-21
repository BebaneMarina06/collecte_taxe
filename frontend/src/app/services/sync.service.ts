import { Injectable } from '@angular/core';
import { Subject, interval, Subscription } from 'rxjs';
import { startWith } from 'rxjs/operators';

@Injectable({
  providedIn: 'root'
})
export class SyncService {
  private syncInterval = 10000; // 10 secondes par défaut
  private syncSubscription?: Subscription;
  private syncSubject = new Subject<void>();
  
  // Observable pour que les composants s'abonnent
  sync$ = this.syncSubject.asObservable();
  
  // État de la synchronisation
  private isActive = false;

  constructor() {
    // On ne démarre plus automatiquement la synchronisation pour éviter
    // les rafraîchissements trop fréquents qui font « clignoter » les écrans.
    // Les composants peuvent appeler this.start() explicitement si besoin.
  }

  /**
   * Démarrer la synchronisation automatique
   */
  start(intervalMs: number = this.syncInterval): void {
    if (this.isActive) {
      this.stop();
    }
    
    this.syncInterval = intervalMs;
    this.isActive = true;
    
    this.syncSubscription = interval(this.syncInterval)
      .pipe(startWith(0)) // Émettre immédiatement au démarrage
      .subscribe(() => {
        this.syncSubject.next();
      });
  }

  /**
   * Arrêter la synchronisation automatique
   */
  stop(): void {
    if (this.syncSubscription) {
      this.syncSubscription.unsubscribe();
      this.syncSubscription = undefined;
    }
    this.isActive = false;
  }

  /**
   * Forcer une synchronisation immédiate
   */
  forceSync(): void {
    this.syncSubject.next();
  }

  /**
   * Vérifier si la synchronisation est active
   */
  get active(): boolean {
    return this.isActive;
  }

  /**
   * Changer l'intervalle de synchronisation
   */
  setInterval(intervalMs: number): void {
    if (this.isActive) {
      this.start(intervalMs);
    } else {
      this.syncInterval = intervalMs;
    }
  }
}

