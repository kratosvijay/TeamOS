import { Module } from '@nestjs/common';
import { MCPService } from './mcp.service';
import { PrismaModule } from '../prisma/prisma.module';

@Module({
  imports: [PrismaModule],
  providers: [MCPService],
  exports: [MCPService],
})
export class MCPModule {}
