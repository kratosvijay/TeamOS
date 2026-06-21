import { Module, Global } from '@nestjs/common';
import { MentionService } from './mention.service';
import { NotificationModule } from '../notification/notification.module';

@Global()
@Module({
  imports: [NotificationModule],
  providers: [MentionService],
  exports: [MentionService],
})
export class MentionModule {}
