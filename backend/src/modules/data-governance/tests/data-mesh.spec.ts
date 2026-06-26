import { Test, TestingModule } from '@nestjs/testing';
import { DataMeshService } from '../data-mesh.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('DataMeshService', () => {
  let service: DataMeshService;

  const mockPrisma = {};

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        DataMeshService,
        { provide: PrismaService, useValue: mockPrisma },
      ],
    }).compile();

    service = module.get<DataMeshService>(DataMeshService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
