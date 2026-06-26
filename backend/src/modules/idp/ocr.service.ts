import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class OcrService {
  constructor(private readonly prisma: PrismaService) {}
  async scan() { return { text: '' }; }
}