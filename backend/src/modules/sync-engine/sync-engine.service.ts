import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class SyncEngineService {
  constructor(private readonly prisma: PrismaService) {}
  async sync() { return { completed: true }; }
}