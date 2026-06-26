import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class ConnectorMarketplaceService {
  constructor(private readonly prisma: PrismaService) {}
  async list() { return []; }
}