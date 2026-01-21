import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { Router, RouterLink } from '@angular/router';
import { AuthService } from '../../services/auth.service';

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, RouterLink],
  template: `
    <div class="login-container">
      <div class="login-content">
        <div class="login-header">
          <h1 class="login-title">Taxes Municipales</h1>
          <p class="login-subtitle">Mairie de Libreville - Gabon</p>
        </div>

        <div class="logo-section">
          <div class="emblem-container">
            <img src="/assets/logo_app.png" alt="Logo Mairie de Libreville" class="emblem-logo">
          </div>
        </div>

        <div class="login-form-container">
          <h2 class="form-title">Connectez-vous à votre compte</h2>
        <div class="back-link">
          <a [routerLink]="['/']">
            ← Retour au portail
          </a>
        </div>

          <div *ngIf="errorMessage" class="error-message">
            <svg class="error-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <circle cx="12" cy="12" r="10"></circle>
              <line x1="12" y1="8" x2="12" y2="12"></line>
              <line x1="12" y1="16" x2="12.01" y2="16"></line>
            </svg>
            <span>{{ errorMessage }}</span>
          </div>

          <form [formGroup]="loginForm" (ngSubmit)="onSubmit()" class="login-form">
            <div class="form-group">
              <label for="email" class="form-label">Email</label>
              <div class="input-wrapper" [class.error]="email?.invalid && email?.touched">
                <svg class="input-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"></path>
                  <polyline points="22,6 12,13 2,6"></polyline>
                </svg>
                <input
                  type="email"
                  id="email"
                  formControlName="email"
                  class="form-input"
                  placeholder="votre.email@example.com"
                  [class.error]="email?.invalid && email?.touched"
                  [readonly]="step === 'verify'"
                />
              </div>
              <div *ngIf="email?.invalid && email?.touched" class="error-text">
                <span *ngIf="email?.errors?.['required']">L'email est requis</span>
                <span *ngIf="email?.errors?.['email']">Format d'email invalide</span>
              </div>
            </div>

            <div *ngIf="step === 'verify'" class="form-group">
              <label for="code" class="form-label">Code de vérification</label>
              <div class="input-wrapper" [class.error]="code?.invalid && code?.touched">
                <svg class="input-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <circle cx="12" cy="12" r="10"></circle>
                  <polyline points="9 12 12 15 15 9"></polyline>
                </svg>
                <input
                  type="text"
                  id="code"
                  formControlName="code"
                  class="form-input"
                  placeholder="Code reçu par email"
                  maxlength="6"
                  [class.error]="code?.invalid && code?.touched"
                />
              </div>
              <div *ngIf="code?.invalid && code?.touched" class="error-text">
                <span>Le code est requis</span>
              </div>
              <div class="forgot-password">
                <button type="button" class="forgot-link" (click)="resendOtp()" [disabled]="loading">
                  Renvoyer le code
                </button>
              </div>
            </div>

            <button
              type="submit"
              class="login-button"
              [disabled]="loading || loginForm.invalid"
            >
              <span *ngIf="!loading" class="button-content">
                <svg class="button-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <path d="M5 12h14M12 5l7 7-7 7"/>
                </svg>
                {{ step === 'request' ? 'Recevoir un code' : 'Se connecter' }}
              </span>
              <span *ngIf="loading" class="button-content">
                <svg class="spinner" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <circle cx="12" cy="12" r="10" opacity="0.25"></circle>
                  <path d="M12 2a10 10 0 0 1 10 10" opacity="0.75"></path>
                </svg>
                {{ step === 'request' ? 'Envoi du code...' : 'Connexion en cours...' }}
              </span>
            </button>
          </form>
        </div>

        <div class="login-footer">
          <p>&copy; 2025 Mairie de Libreville - Tous droits réservés</p>
        </div>
      </div>
    </div>
  `,
  styles: [`
    .login-container {
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      background: #f8fafc;
      padding: 2rem;
      position: relative;
      overflow: hidden;
    }
    .login-container::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      background-image:
        radial-gradient(circle at 20% 30%, rgba(12, 82, 156, 0.05) 0%, transparent 50%),
        radial-gradient(circle at 80% 70%, rgba(12, 82, 156, 0.05) 0%, transparent 50%);
      pointer-events: none;
    }
    .login-container::after {
      content: '';
      position: absolute;
      top: -50%;
      right: -10%;
      width: 600px;
      height: 600px;
      background: linear-gradient(135deg, rgba(12, 82, 156, 0.03) 0%, transparent 100%);
      border-radius: 50%;
      pointer-events: none;
    }
    .login-content {
      width: 100%;
      max-width: 480px;
      background: white;
      border-radius: 20px;
      box-shadow:
        0 1px 3px rgba(0, 0, 0, 0.05),
        0 10px 25px rgba(0, 0, 0, 0.08),
        0 20px 48px rgba(0, 0, 0, 0.06);
      padding: 3rem 2.5rem;
      position: relative;
      z-index: 1;
      border: 1px solid rgba(0, 0, 0, 0.04);
    }
    .login-header {
      text-align: center;
      margin-bottom: 2rem;
    }
    .login-title {
      font-size: 1.75rem;
      font-weight: 700;
      color: #1a202c;
      margin: 0 0 0.5rem 0;
      letter-spacing: -0.5px;
    }
    .login-subtitle {
      font-size: 0.875rem;
      color: #718096;
      margin: 0;
    }
    .logo-section {
      display: flex;
      justify-content: center;
      margin-bottom: 2.5rem;
    }
    .emblem-container {
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 0.75rem;
    }
    .emblem-logo {
      width: 120px;
      height: 120px;
      object-fit: contain;
      filter: drop-shadow(0 4px 6px rgba(0, 0, 0, 0.1));
    }
    .login-form-container {
      margin-bottom: 2rem;
    }
    .back-link {
      text-align: left;
      margin-bottom: 1rem;
    }
    .back-link a {
      font-size: 0.875rem;
      color: rgba(12, 82, 156, 1);
      text-decoration: none;
      font-weight: 600;
    }
    .back-link a:hover {
      text-decoration: underline;
      color: rgba(10, 70, 140, 1);
    }
    .form-title {
      font-size: 1.125rem;
      font-weight: 600;
      color: #2d3748;
      text-align: center;
      margin: 0 0 1.5rem 0;
    }
    .error-message {
      display: flex;
      align-items: center;
      gap: 0.5rem;
      background-color: #fed7d7;
      border: 1px solid #fc8181;
      color: #c53030;
      padding: 0.75rem 1rem;
      border-radius: 8px;
      margin-bottom: 1.5rem;
      font-size: 0.875rem;
    }
    .error-icon {
      width: 18px;
      height: 18px;
      flex-shrink: 0;
    }
    .login-form {
      display: flex;
      flex-direction: column;
      gap: 1.25rem;
    }
    .form-group {
      display: flex;
      flex-direction: column;
      gap: 0.5rem;
    }
    .form-label {
      font-size: 0.875rem;
      font-weight: 600;
      color: #2d3748;
      margin-bottom: 0.25rem;
    }
    .input-wrapper {
      position: relative;
      display: flex;
      align-items: center;
      background-color: #f7fafc;
      border: 1.5px solid #e2e8f0;
      border-radius: 12px;
      transition: all 0.2s ease;
    }
    .input-wrapper:focus-within {
      border-color: rgba(12, 82, 156, 1);
      background-color: white;
      box-shadow: 0 0 0 3px rgba(12, 82, 156, 0.08);
    }
    .input-wrapper.error {
      border-color: #fc8181;
      background-color: #fff5f5;
    }
    .input-icon {
      width: 20px;
      height: 20px;
      color: #a0aec0;
      margin-left: 1rem;
      flex-shrink: 0;
    }
    .form-input {
      flex: 1;
      padding: 0.875rem 1rem;
      border: none;
      background: transparent;
      font-size: 0.9375rem;
      color: #2d3748;
      outline: none;
    }
    .form-input::placeholder {
      color: #a0aec0;
    }
    .form-input.error {
      color: #c53030;
    }
    .password-toggle {
      background: none;
      border: none;
      padding: 0.5rem 1rem;
      cursor: pointer;
      color: #a0aec0;
      display: flex;
      align-items: center;
      transition: color 0.2s ease;
    }
    .password-toggle:hover {
      color: rgba(12, 82, 156, 1);
    }
    .password-toggle svg {
      width: 20px;
      height: 20px;
    }
    .error-text {
      font-size: 0.75rem;
      color: #c53030;
      margin-top: 0.25rem;
    }
    .forgot-password {
      display: flex;
      justify-content: flex-end;
      margin-top: -0.5rem;
    }
    .forgot-link {
      font-size: 0.875rem;
      color: rgba(12, 82, 156, 1);
      text-decoration: none;
      font-weight: 500;
      transition: color 0.2s ease;
    }
    .forgot-link:hover {
      color: rgba(10, 70, 140, 1);
      text-decoration: underline;
    }
    .login-button {
      width: 100%;
      padding: 1rem;
      background: rgba(12, 82, 156, 1);
      color: white;
      border: none;
      border-radius: 12px;
      font-size: 1rem;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.2s ease;
      margin-top: 0.5rem;
      box-shadow: 0 2px 4px rgba(12, 82, 156, 0.2);
    }
    .login-button:hover:not(:disabled) {
      background: rgba(10, 70, 140, 1);
      transform: translateY(-1px);
      box-shadow: 0 4px 8px rgba(12, 82, 156, 0.3);
    }
    .login-button:active:not(:disabled) {
      transform: translateY(0);
      box-shadow: 0 2px 4px rgba(12, 82, 156, 0.2);
    }
    .login-button:disabled {
      opacity: 0.6;
      cursor: not-allowed;
      transform: none;
    }
    .button-content {
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 0.5rem;
    }
    .button-icon {
      width: 20px;
      height: 20px;
    }
    .spinner {
      width: 20px;
      height: 20px;
      animation: spin 1s linear infinite;
    }
    @keyframes spin {
      from { transform: rotate(0deg); }
      to { transform: rotate(360deg); }
    }
    .login-footer {
      text-align: center;
      padding-top: 1.5rem;
      border-top: 1px solid #e2e8f0;
      margin-top: 2rem;
    }
    .login-footer p {
      font-size: 0.75rem;
      color: #718096;
      margin: 0;
    }
    @media (max-width: 640px) {
      .login-container { padding: 1rem; }
      .login-content { padding: 2rem 1.5rem; border-radius: 16px; }
      .login-title { font-size: 1.5rem; }
      .emblem-logo { width: 100px; height: 100px; }
    }
  `]
})
export class LoginComponent {
  loginForm: FormGroup;
  loading = false;
  errorMessage = '';
  step: 'request' | 'verify' = 'request';

  constructor(
    private fb: FormBuilder,
    private authService: AuthService,
    private router: Router
  ) {
    this.loginForm = this.fb.group({
      email: ['', [Validators.required, Validators.email]],
      code: ['']
    });
  }

  get email() {
    return this.loginForm.get('email');
  }

  get code() {
    return this.loginForm.get('code');
  }

  onSubmit() {
    if (this.step === 'request') {
      this.requestOtp();
    } else {
      this.verifyOtp();
    }
  }

  private requestOtp() {
    if (this.email?.invalid) {
      this.email?.markAsTouched();
      return;
    }

    this.loading = true;
    this.errorMessage = '';

    this.authService.requestOtp({ email: this.email?.value }).subscribe({
      next: () => {
        this.loading = false;
        this.step = 'verify';
        this.loginForm.get('code')?.setValidators([Validators.required]);
        this.loginForm.get('code')?.updateValueAndValidity();
      },
      error: (err) => {
        this.loading = false;
        this.errorMessage = err.error?.detail || 'Impossible d\'envoyer le code. Veuillez réessayer.';
      }
    });
  }

  private verifyOtp() {
    if (this.loginForm.invalid) {
      this.loginForm.markAllAsTouched();
      return;
    }

    this.loading = true;
    this.errorMessage = '';

    this.authService.verifyOtp({
      email: this.email?.value,
      code: this.code?.value
    }).subscribe({
      next: () => {
        this.loading = false;
        this.router.navigate(['/dashboard']);
      },
      error: (err) => {
        this.loading = false;
        this.errorMessage = err.error?.detail || 'Code invalide ou expiré.';
      }
    });
  }

  resendOtp() {
    if (this.step !== 'verify') {
      return;
    }
    this.requestOtp();
  }
}

