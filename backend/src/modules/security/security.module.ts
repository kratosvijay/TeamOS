import { Module } from '@nestjs/common';
import { SecurityService } from './security.service';
import { SessionService } from './session.service';
import { SecurityController } from './security.controller';
import { GlobalSecurityGuard } from './global-security.guard';
import { PrismaModule } from '../prisma/prisma.module';
import { AuthModule } from '../auth/auth.module';

@Module({
  imports: [PrismaModule, AuthModule],
  providers: [SecurityService, SessionService, GlobalSecurityGuard],
  controllers: [SecurityController],
  exports: [SecurityService, SessionService, GlobalSecurityGuard],
})
export class SecurityModule {}
