import {Component, inject, model, ModelSignal, signal} from '@angular/core';
import {ContenerComponent} from '../../items/contener/contener.component';
import {ClientsTableComponent} from '../../items/tables/clients-table/clients-table.component';
import {ModalComponent} from '../../items/modal/modal.component';
import {CreateClientComponent} from '../../items/modals/create-client/create-client.component';
import {Contribuable} from '../../../interfaces/contribuable.interface';

@Component({
  selector: 'app-clients',
  standalone : true,
  imports: [
    ContenerComponent,
    ClientsTableComponent,
    ModalComponent,
    CreateClientComponent
  ],
  templateUrl: './clients.component.html',
  styleUrl: './clients.component.scss'
})
export class ClientsComponent {
  activeModal : ModelSignal<boolean> = model<boolean>(false);
  activeModalEdit = signal<boolean>(false);
  selectedContribuable: Contribuable | null = null;

  onActiveModal(value : boolean) : void {
    this.activeModal.set(value);
  }

  onEditClient(contribuable: Contribuable): void {
    this.selectedContribuable = contribuable;
    this.activeModalEdit.set(true);
  }

  onClientCreated(): void {
    this.activeModal.set(false);
    this.activeModalEdit.set(false);
    this.selectedContribuable = null;
    // La table se rechargera automatiquement via le signal
  }
}
