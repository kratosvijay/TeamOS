import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class ConnectorGeneratorService {
  constructor(private readonly prisma: PrismaService) {}
  async generate() { return { generated: true }; }
}