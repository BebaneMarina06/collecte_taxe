import { Pipe, PipeTransform } from '@angular/core';

@Pipe({
  name: 'findContribuableById',
  standalone: true
})
export class FindContribuableByIdPipe implements PipeTransform {
  transform(contribuables: any[], id: number): any {
    if (!contribuables || !id) return null;
    return contribuables.find(c => c.id === id);
  }
}
