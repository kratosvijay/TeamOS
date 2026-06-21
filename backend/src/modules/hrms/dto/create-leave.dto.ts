import { IsString, IsDateString, IsOptional } from 'class-validator';

export class CreateLeaveDto {
  @IsString()
  employeeId: string;

  @IsDateString()
  startDate: string;

  @IsDateString()
  endDate: string;

  @IsString()
  @IsOptional()
  reason?: string;
}
