import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class SecretsManagerService {
  constructor(private readonly prisma: PrismaService) {}
  async rotate() { return { rotated: true }; }
}