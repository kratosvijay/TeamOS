import { Test, TestingModule } from '@nestjs/testing';
import { DataPrivacyService } from '../data-privacy.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('DataPrivacyService', () => {
  let service: DataPrivacyService;

  const mockPrisma = {};

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        DataPrivacyService,
        { provide: PrismaService, useValue: mockPrisma },
      ],
    }).compile();

    service = module.get<DataPrivacyService>(DataPrivacyService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
