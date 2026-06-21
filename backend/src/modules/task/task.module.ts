import { Module } from '@nestjs/common';
import { TaskService } from './task.service';
import { TaskController } from './task.controller';
import { BulkService } from './bulk.service';
import { KanbanGateway } from './kanban.gateway';
import { TaskSchedulerService } from './task-scheduler.service';
import { AuthModule } from '../auth/auth.module';
import { WatcherModule } from '../watcher/watcher.module';

@Module({
  imports: [AuthModule, WatcherModule],
  controllers: [TaskController],
  providers: [
    TaskService,
    BulkService,
    KanbanGateway,
    TaskSchedulerService,
  ],
  exports: [TaskService, BulkService, KanbanGateway],
})
export class TaskModule {}
