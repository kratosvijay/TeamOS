import { IsDateString } from 'class-validator';

export class CreatePayrollDto {
  @IsDateString()
  periodStart: string;

  @IsDateString()
  periodEnd: string;
}
