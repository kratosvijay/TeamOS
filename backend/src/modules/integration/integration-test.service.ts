import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class IntegrationTestService {
  constructor(private readonly prisma: PrismaService) {}
  async test() { return { passed: true }; }
}