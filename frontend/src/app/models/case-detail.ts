import {HalResponse} from '@models/hal-response';
import {CaseCommentDto} from '@models/case-comment';

export interface CaseDetailDto extends HalResponse {
  caseId?: string;

  firstName: string;
  lastName: string;

  testDate?: Date;

  quarantineStartDate: Date;
  quarantineEndDate: Date;

  street?: string;
  houseNumber?: string;
  city?: string;
  zipCode?: string;

  mobilePhone?: string;
  phone?: string;

  email?: string;

  dateOfBirth: Date;

  comments?: CaseCommentDto[];

  status?: string;

  infected: boolean;
}
