import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class DesktopAutomationService {
  constructor(private readonly prisma: PrismaService) {}
}