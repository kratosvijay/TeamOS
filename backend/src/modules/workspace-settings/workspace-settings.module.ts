import { Module } from '@nestjs/common';
import { WorkspaceSettingsService } from './workspace-settings.service';
import { WorkspaceSettingsController } from './workspace-settings.controller';
import { AuthModule } from '../auth/auth.module';

@Module({
  imports: [AuthModule],
  controllers: [WorkspaceSettingsController],
  providers: [WorkspaceSettingsService],
  exports: [WorkspaceSettingsService],
})
export class WorkspaceSettingsModule {}
