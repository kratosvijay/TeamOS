import { Module } from '@nestjs/common';
import { EdiService } from './edi.service';
import { EdiParserService } from './edi-parser.service';
import { As2Service } from './as2.service';
import { PrismaModule } from '../prisma/prisma.module';

@Module({
  imports: [PrismaModule],
  providers: [EdiService, EdiParserService, As2Service],
  exports: [EdiService, EdiParserService, As2Service],
})
export class B2bModule {}