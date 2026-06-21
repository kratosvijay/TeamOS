import { Module } from '@nestjs/common';
import { SavedFilterService } from './saved-filter.service';
import { SavedFilterController } from './saved-filter.controller';
import { AuthModule } from '../auth/auth.module';

@Module({
  imports: [AuthModule],
  controllers: [SavedFilterController],
  providers: [SavedFilterService],
  exports: [SavedFilterService],
})
export class SavedFilterModule {}
