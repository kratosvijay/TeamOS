import { Module } from '@nestjs/common';
import { MarketplaceService } from './marketplace.service';
import { MarketplaceController } from './marketplace.controller';
import { IntegrationModule } from '../integration/integration.module';
import { AuthModule } from '../auth/auth.module';

@Module({
  imports: [IntegrationModule, AuthModule],
  controllers: [MarketplaceController],
  providers: [MarketplaceService],
  exports: [MarketplaceService],
})
export class MarketplaceModule {}
