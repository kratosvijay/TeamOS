import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class IntegrationAiService {
  constructor(private readonly prisma: PrismaService) {}
  async recommend() { return {}; }
}