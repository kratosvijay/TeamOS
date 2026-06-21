import { Module, Global } from '@nestjs/common';
import { EventService } from './event.service';
import { ProjectProvisioningWorker } from './event.processor';

@Global()
@Module({
  providers: [EventService, ProjectProvisioningWorker],
  exports: [EventService],
})
export class EventModule {}
