import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class FlowRuntimeService {
  constructor(private readonly prisma: PrismaService) {}
  async run() { return { success: true }; }
}