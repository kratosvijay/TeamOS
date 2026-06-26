import { Module } from '@nestjs/common';
import { EnterpriseEventBusService } from './enterprise-event-bus.service';
import { PrismaModule } from '../prisma/prisma.module';

@Module({
  imports: [PrismaModule],
  providers: [EnterpriseEventBusService],
  exports: [EnterpriseEventBusService],
})
export class EnterpriseEventBusModule {}
