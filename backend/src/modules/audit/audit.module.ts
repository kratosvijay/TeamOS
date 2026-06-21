import { Module, Global } from '@nestjs/common';
import { AuditService } from './audit.service';
import { AuditController } from './audit.controller';
import { ActivityController } from './activity.controller';
import { AuthModule } from '../auth/auth.module';

@Global()
@Module({
  imports: [AuthModule],
  controllers: [AuditController, ActivityController],
  providers: [AuditService],
  exports: [AuditService],
})
export class AuditModule {}
