import { Module } from '@nestjs/common';
import { TaskTemplateService } from './task-template.service';
import { TaskTemplateController } from './task-template.controller';
import { TaskModule } from '../task/task.module';
import { AuthModule } from '../auth/auth.module';

@Module({
  imports: [TaskModule, AuthModule],
  controllers: [TaskTemplateController],
  providers: [TaskTemplateService],
  exports: [TaskTemplateService],
})
export class TaskTemplateModule {}
