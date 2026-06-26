import { Module } from '@nestjs/common';
import { OcrService } from './ocr.service';
import { OcrExtractorService } from './ocr-extractor.service';
import { DocumentClassifierService } from './document-classifier.service';
import { DocumentContextService } from './document-context.service';
import { InvoiceParserService } from './invoice-parser.service';
import { ReceiptParserService } from './receipt-parser.service';
import { PrismaModule } from '../prisma/prisma.module';

@Module({
  imports: [PrismaModule],
  providers: [OcrService, OcrExtractorService, DocumentClassifierService, DocumentContextService, InvoiceParserService, ReceiptParserService],
  exports: [OcrService, OcrExtractorService, DocumentClassifierService, DocumentContextService, InvoiceParserService, ReceiptParserService],
})
export class IdpModule {}