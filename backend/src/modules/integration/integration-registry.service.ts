import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class IntegrationRegistryService {
  constructor(private readonly prisma: PrismaService) {}
  async register() { return { registered: true }; }
}