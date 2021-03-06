import { DiaryDto } from '@models/diary-entry';
import { ApiService } from '@services/api.service';
import { ForgottenContactDialogComponent } from './forgotten-contact-dialog/forgotten-contact-dialog.component';
import { AsideService } from '@services/aside.service';
import { DiaryEntryDto } from '@models/diary-entry';
import { Component, OnInit, OnDestroy } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { SubSink } from 'subsink';
import { KeyValue } from '@angular/common';
import { ForgottenContactBannerComponent } from './forgotten-contact-banner/forgotten-contact-banner.component';
import { MatDialog } from '@angular/material/dialog';

@Component({
  selector: 'app-diary',
  templateUrl: './diary.component.html',
  styleUrls: ['./diary.component.scss']
})
export class DiaryComponent implements OnInit, OnDestroy {
  diary: DiaryDto;
  private subs = new SubSink();

  constructor(
    private route: ActivatedRoute,
    private asideService: AsideService,
    private dialog: MatDialog,
    private apiService: ApiService) { }

  ngOnInit() {
    this.subs.add(this.route.data.subscribe(data => {
      this.diary = data.diary;
    }));
    this.asideService.setAsideComponentContent(ForgottenContactBannerComponent);
  }

  ngOnDestroy() {
    this.subs.unsubscribe();
    this.asideService.clearAsideComponentContent();
  }

  openContactDialog() {
    this.subs.add(this.apiService.getContactPersons()
      .subscribe(contactPersons => this.dialog.open(ForgottenContactDialogComponent, {
        data: {
          contactPersons
        }
      })));
  }
}
