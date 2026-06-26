import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class EventStreamService {
  constructor(private readonly prisma: PrismaService) {}
  async stream() { return { active: true }; }
}