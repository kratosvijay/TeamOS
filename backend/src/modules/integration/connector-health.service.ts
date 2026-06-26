import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class ConnectorHealthService {
  constructor(private readonly prisma: PrismaService) {}
  async check() { return { status: 'OK' }; }
}