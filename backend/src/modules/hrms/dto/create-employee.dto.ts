import { IsString, IsEmail, IsOptional, IsNumber } from 'class-validator';

export class CreateEmployeeDto {
  @IsString()
  fullName: string;

  @IsEmail()
  email: string;

  @IsString()
  role: string;

  @IsString()
  department: string;

  @IsNumber()
  @IsOptional()
  salary?: number;
}
