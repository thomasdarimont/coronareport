import { Component, OnInit, Input } from '@angular/core';
import { DiaryEntryListItemDto } from '@models/diary-entry';

@Component({
  selector: 'app-diary-entry-success',
  templateUrl: './diary-entry-success.component.html',
  styleUrls: ['./diary-entry-success.component.scss']
})
export class DiaryEntrySuccessComponent implements OnInit {
  @Input() entry: DiaryEntryListItemDto;
  @Input() label: string;

  constructor() { }

  ngOnInit() {
  }

  get isReadonly(): boolean {
    if (!this.entry._links.edit) { return true; }
    return false;
  }

  get symptomsString(): string {
    return this.entry.symptoms.map(s => s.name).join(', ');
  }

  get contactsString(): string {
    return this.entry.contacts.map(s => `${s.firstName} ${s.lastName}`).join(', ');
  }
}
