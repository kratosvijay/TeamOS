import { Module } from '@nestjs/common';
import { AIService } from './ai.service';
import { AIController } from './ai.controller';
import { AIGateway } from './ai.gateway';
import { AIProcessor } from './ai.processor';
import { PrismaModule } from '../prisma/prisma.module';
import { SearchModule } from '../search/search.module';
import { MCPModule } from '../mcp/mcp.module';
import { AuthModule } from '../auth/auth.module';

@Module({
  imports: [
    PrismaModule,
    SearchModule,
    MCPModule,
    AuthModule,
  ],
  controllers: [AIController],
  providers: [
    AIService,
    AIGateway,
    AIProcessor,
  ],
  exports: [AIService],
})
export class AIModule {}
