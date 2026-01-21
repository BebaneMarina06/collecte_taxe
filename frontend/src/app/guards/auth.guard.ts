import { Injectable } from '@angular/core';
import { Router, CanActivate, ActivatedRouteSnapshot, RouterStateSnapshot } from '@angular/router';
import { AuthService } from '../services/auth.service';

@Injectable({
  providedIn: 'root'
})
export class AuthGuard implements CanActivate {
  constructor(
    private authService: AuthService,
    private router: Router
  ) {}

  canActivate(
    route: ActivatedRouteSnapshot,
    state: RouterStateSnapshot
  ): boolean | Promise<boolean> {
    const currentUrl = state.url;
    
    // Si pas de token, rediriger immédiatement vers /login (synchrone)
    if (!this.authService.isAuthenticated()) {
      // Nettoyer le cache au cas où il y aurait des données obsolètes
      this.authService.logout();
      this.router.navigate(['/login'], { 
        queryParams: { returnUrl: currentUrl },
        replaceUrl: true 
      }).catch(() => {
        // Ignorer les erreurs de navigation
      });
      return false;
    }

    // Si un token existe, vérifier sa validité en appelant l'API (asynchrone)
    // Même si l'utilisateur est en cache, le token peut être expiré
    return new Promise<boolean>((resolve) => {
      this.authService.getCurrentUser().subscribe({
        next: () => {
          // Token valide, autoriser l'accès
          resolve(true);
        },
        error: (error) => {
          // Token invalide ou expiré, déconnecter et rediriger
          this.authService.logout();
          // Ne rediriger que si on n'est pas déjà sur la page de login
          if (!currentUrl.includes('/login')) {
            this.router.navigate(['/login'], { 
              queryParams: { returnUrl: currentUrl },
              replaceUrl: true 
            }).catch(() => {
              // Ignorer les erreurs de navigation
            });
          }
          resolve(false);
        }
      });
    });
  }
}

