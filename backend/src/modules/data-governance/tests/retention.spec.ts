import { Test, TestingModule } from '@nestjs/testing';
import { RetentionService } from '../retention.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('RetentionService', () => {
  let service: RetentionService;

  const mockPrisma = {};

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        RetentionService,
        { provide: PrismaService, useValue: mockPrisma },
      ],
    }).compile();

    service = module.get<RetentionService>(RetentionService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
