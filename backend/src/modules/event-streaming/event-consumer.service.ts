import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class EventConsumerService {
  constructor(private readonly prisma: PrismaService) {}
}