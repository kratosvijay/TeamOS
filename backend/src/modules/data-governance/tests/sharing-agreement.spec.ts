import { Test, TestingModule } from '@nestjs/testing';
import { SharingAgreementService } from '../sharing-agreement.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('SharingAgreementService', () => {
  let service: SharingAgreementService;

  const mockPrisma = {};

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        SharingAgreementService,
        { provide: PrismaService, useValue: mockPrisma },
      ],
    }).compile();

    service = module.get<SharingAgreementService>(SharingAgreementService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
