import { Module } from '@nestjs/common';
import { WarehouseService } from './warehouse.service';
import { WarehouseProcessor } from './warehouse.processor';
import { PrismaModule } from '../prisma/prisma.module';

@Module({
  imports: [PrismaModule],
  providers: [WarehouseService, WarehouseProcessor],
  exports: [WarehouseService, WarehouseProcessor],
})
export class WarehouseModule {}
