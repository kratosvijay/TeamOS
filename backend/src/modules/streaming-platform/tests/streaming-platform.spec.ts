import { Test, TestingModule } from '@nestjs/testing';
import { StreamingPlatformService } from '../streaming-platform.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('StreamingPlatformService', () => {
  let service: StreamingPlatformService;

  const mockPrisma = {};

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        StreamingPlatformService,
        { provide: PrismaService, useValue: mockPrisma },
      ],
    }).compile();

    service = module.get<StreamingPlatformService>(StreamingPlatformService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
