import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class IntegrationGovernanceService {
  constructor(private readonly prisma: PrismaService) {}
  async audit() { return []; }
}