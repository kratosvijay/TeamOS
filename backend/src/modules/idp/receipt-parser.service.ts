import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class ReceiptParserService {
  constructor(private readonly prisma: PrismaService) {}
}