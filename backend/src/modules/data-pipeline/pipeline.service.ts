import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class PipelineService {
  constructor(private readonly prisma: PrismaService) {}
  async execute() { return { runId: 'run-123' }; }
}