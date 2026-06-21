import { Module } from '@nestjs/common';
import { MeetingController } from './meeting.controller';
import { MeetingService } from './meeting.service';
import { MeetingGateway } from './meeting.gateway';
import { PrismaModule } from '../prisma/prisma.module';
import { LiveKitModule } from '../livekit/livekit.module';
import { StorageModule } from '../storage/storage.module';
import { NotificationModule } from '../notification/notification.module';
import { EventModule } from '../event/event.module';
import { AuthModule } from '../auth/auth.module';

@Module({
  imports: [
    PrismaModule,
    LiveKitModule,
    StorageModule,
    NotificationModule,
    EventModule,
    AuthModule,
  ],
  controllers: [MeetingController],
  providers: [MeetingService, MeetingGateway],
  exports: [MeetingService],
})
export class MeetingModule {}
