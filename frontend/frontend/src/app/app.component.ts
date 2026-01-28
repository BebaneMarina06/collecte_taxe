import { Component, OnInit } from '@angular/core';
import { RouterOutlet } from '@angular/router';
import { ResponsiveService } from './services/responsive.service';

@Component({
  selector: 'app-root',
  imports: [RouterOutlet],
  standalone: true,
  templateUrl: './app.component.html',
  styleUrl: './app.component.scss'
})
export class AppComponent implements OnInit {
  title = 'Gestion des Taxes Municipales';

  constructor(private responsiveService: ResponsiveService) {}

  ngOnInit(): void {
    // Le service se charge automatiquement de l'initialisation
    // et applique le zoom adapté au chargement
    console.log('[AppComponent] Application initialisée');
  }
}
