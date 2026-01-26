import {Component, Input, model, ModelSignal} from '@angular/core';
import {ContenerComponent} from '../contener/contener.component';

@Component({
  selector: 'app-modal',
  imports: [],
  standalone : true,
  templateUrl: './modal.component.html',
  styleUrl: './modal.component.scss'
})
export class ModalComponent {
  active : ModelSignal<boolean> = model<boolean>(false);
  @Input() title : string | null = null;
  toggleActive(event?: Event)
  {
    if (event) {
      event.stopPropagation();
    }
    this.active.set(!this.active());
  }
}
