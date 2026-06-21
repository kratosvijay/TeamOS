import { Module } from '@nestjs/common';
import { SCIMService } from './scim.service';
import { SCIMController } from './scim.controller';
import { PrismaModule } from '../prisma/prisma.module';

@Module({
  imports: [PrismaModule],
  providers: [SCIMService],
  controllers: [SCIMController],
  exports: [SCIMService],
})
export class SCIMModule {}
