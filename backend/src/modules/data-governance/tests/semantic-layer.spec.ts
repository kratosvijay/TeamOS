import { Test, TestingModule } from '@nestjs/testing';
import { SemanticLayerService } from '../semantic-layer.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('SemanticLayerService', () => {
  let service: SemanticLayerService;

  const mockPrisma = {};

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        SemanticLayerService,
        { provide: PrismaService, useValue: mockPrisma },
      ],
    }).compile();

    service = module.get<SemanticLayerService>(SemanticLayerService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
