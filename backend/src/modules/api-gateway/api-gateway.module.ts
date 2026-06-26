import { Module, NestModule, MiddlewareConsumer } from '@nestjs/common';
import { PrismaModule } from '../prisma/prisma.module';
import { ApiGatewayService } from './api-gateway.service';
import { ApiGatewayController } from './api-gateway.controller';
import { ApiGatewayMiddleware } from './api-gateway.middleware';

@Module({
  imports: [PrismaModule],
  controllers: [ApiGatewayController],
  providers: [ApiGatewayService],
  exports: [ApiGatewayService],
})
export class ApiGatewayModule implements NestModule {
  configure(consumer: MiddlewareConsumer) {
    consumer
      .apply(ApiGatewayMiddleware)
      .forRoutes('*');
  }
}
