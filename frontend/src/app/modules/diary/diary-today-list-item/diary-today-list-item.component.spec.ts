/* tslint:disable:no-unused-variable */
import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { By } from '@angular/platform-browser';
import { DebugElement } from '@angular/core';

import { DiaryTodayListItemComponent } from './diary-today-list-item.component';
import {DiaryListItemDto} from '@models/diary-entry';

describe('DiaryTodayListItemComponent', () => {
  let component: DiaryTodayListItemComponent;
  let fixture: ComponentFixture<DiaryTodayListItemComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ DiaryTodayListItemComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(DiaryTodayListItemComponent);
    component = fixture.componentInstance;
    component.diaryListItem = { date: '2020-03-01', evening: {}, morning: {} } as DiaryListItemDto;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
