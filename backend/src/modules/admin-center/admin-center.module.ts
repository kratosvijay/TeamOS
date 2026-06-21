import { Module } from '@nestjs/common';
import { AdminCenterController } from './admin-center.controller';
import { PrismaModule } from '../prisma/prisma.module';
import { ComplianceModule } from '../compliance/compliance.module';
import { SecurityModule } from '../security/security.module';

@Module({
  imports: [PrismaModule, ComplianceModule, SecurityModule],
  controllers: [AdminCenterController],
})
export class AdminCenterModule {}
