import { Module } from '@nestjs/common';
import { DocumentGateway } from './document.gateway';

@Module({
  providers: [DocumentGateway],
  exports: [DocumentGateway],
})
export class DocumentModule {}
