import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { PrismaModule } from './modules/prisma/prisma.module';
import { AuthModule } from './modules/auth/auth.module';
import { WorkspaceModule } from './modules/workspace/workspace.module';
import { WorkspaceSettingsModule } from './modules/workspace-settings/workspace-settings.module';
import { FeatureFlagModule } from './modules/feature-flag/feature-flag.module';
import { ProjectModule } from './modules/project/project.module';
import { EventModule } from './modules/event/event.module';
import { ChatModule } from './modules/chat/chat.module';
import { MeetingModule } from './modules/meeting/meeting.module';
import { DocumentModule } from './modules/document/document.module';
import { DeviceModule } from './modules/device/device.module';
import { NotificationModule } from './modules/notification/notification.module';
import { MentionModule } from './modules/mention/mention.module';
import { WatcherModule } from './modules/watcher/watcher.module';
import { DashboardModule } from './modules/dashboard/dashboard.module';
import { SearchModule } from './modules/search/search.module';
import { QueueModule } from './modules/queue/queue.module';
import { AIModule } from './modules/ai/ai.module';
import { StorageModule } from './modules/storage/storage.module';
import { TaskModule } from './modules/task/task.module';
import { SprintModule } from './modules/sprint/sprint.module';
import { CustomFieldModule } from './modules/custom-field/custom-field.module';
import { SavedFilterModule } from './modules/saved-filter/saved-filter.module';
import { AuditModule } from './modules/audit/audit.module';
import { TaskTemplateModule } from './modules/task-template/task-template.module';
import { ReportingModule } from './modules/reporting/reporting.module';
import { LiveKitModule } from './modules/livekit/livekit.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: ['.env', '.env.development'],
    }),
    PrismaModule,
    AuthModule,
    WorkspaceModule,
    WorkspaceSettingsModule,
    FeatureFlagModule,
    ProjectModule,
    EventModule,
    ChatModule,
    MeetingModule,
    DocumentModule,
    DeviceModule,
    NotificationModule,
    MentionModule,
    WatcherModule,
    DashboardModule,
    SearchModule,
    QueueModule,
    AIModule,
    StorageModule,
    TaskModule,
    SprintModule,
    CustomFieldModule,
    SavedFilterModule,
    AuditModule,
    TaskTemplateModule,
    ReportingModule,
    LiveKitModule,
  ],
})
export class AppModule {}

