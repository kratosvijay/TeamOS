import { Test, TestingModule } from '@nestjs/testing';
import { QueryPlannerService } from '../query-planner.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('QueryPlannerService', () => {
  let service: QueryPlannerService;

  const mockPrisma = {};

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        QueryPlannerService,
        { provide: PrismaService, useValue: mockPrisma },
      ],
    }).compile();

    service = module.get<QueryPlannerService>(QueryPlannerService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
