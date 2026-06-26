import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class RpaBotService {
  constructor(private readonly prisma: PrismaService) {}
  async runBot() { return { status: 'completed' }; }
}