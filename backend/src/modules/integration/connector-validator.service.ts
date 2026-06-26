import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class ConnectorValidatorService {
  constructor(private readonly prisma: PrismaService) {}
  async validate() { return { valid: true }; }
}