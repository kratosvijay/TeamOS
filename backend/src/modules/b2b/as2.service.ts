import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class As2Service {
  constructor(private readonly prisma: PrismaService) {}
}