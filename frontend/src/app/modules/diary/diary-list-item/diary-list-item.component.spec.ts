/* tslint:disable:no-unused-variable */
import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { By } from '@angular/platform-browser';
import { DebugElement } from '@angular/core';

import { DiaryListItemComponent } from './diary-list-item.component';
import {DiaryListItemDto} from '@models/diary-entry';

describe('DiaryListItemComponent', () => {
  let component: DiaryListItemComponent;
  let fixture: ComponentFixture<DiaryListItemComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ DiaryListItemComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(DiaryListItemComponent);
    component = fixture.componentInstance;
    component.diaryListItem = { morning: {}, evening: {}, date: '2020-03-01'} as DiaryListItemDto;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
