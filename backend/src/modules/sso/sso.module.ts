import { Module } from '@nestjs/common';
import { SSOService } from './sso.service';
import { SSOController } from './sso.controller';
import { PrismaModule } from '../prisma/prisma.module';
import { AuthModule } from '../auth/auth.module';

@Module({
  imports: [PrismaModule, AuthModule],
  providers: [SSOService],
  controllers: [SSOController],
  exports: [SSOService],
})
export class SSOModule {}
