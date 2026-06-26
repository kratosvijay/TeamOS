import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class EdiService {
  constructor(private readonly prisma: PrismaService) {}
  async parse() { return { status: 'parsed' }; }
}