import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma/prisma.module';
import { SdkModule } from '../sdk/sdk.module';
import { ExtensionRuntimeService } from './extension-runtime.service';

@Module({
  imports: [PrismaModule, SdkModule],
  providers: [ExtensionRuntimeService],
  exports: [ExtensionRuntimeService],
})
export class ExtensionRuntimeModule {}
