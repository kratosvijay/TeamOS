import { Module } from '@nestjs/common';
import { DigitalTwinService } from './digital-twin.service';
import { PrismaModule } from '../prisma/prisma.module';

@Module({
  imports: [PrismaModule],
  providers: [DigitalTwinService],
  exports: [DigitalTwinService],
})
export class DigitalTwinModule {}
