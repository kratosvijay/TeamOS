import { Test, TestingModule } from '@nestjs/testing';
import { SearchController } from '../search.controller';
import { SearchService } from '../search.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('SearchController', () => {
  let controller: SearchController;
  let searchService: SearchService;
  let prismaService: PrismaService;

  const mockSearchService = {
    search: jest.fn(),
  };

  const mockPrismaService = {
    documentEmbedding: {
      findMany: jest.fn(),
    },
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [SearchController],
      providers: [
        { provide: SearchService, useValue: mockSearchService },
        { provide: PrismaService, useValue: mockPrismaService },
      ],
    }).compile();

    controller = module.get<SearchController>(SearchController);
    searchService = module.get<SearchService>(SearchService);
    prismaService = module.get<PrismaService>(PrismaService);
  });

  it('should return empty list if query is empty', async () => {
    const result = await controller.globalSearch('workspace-1', '');
    expect(result).toEqual([]);
  });

  it('should rank items from both OpenSearch and vector embeddings', async () => {
    mockSearchService.search.mockResolvedValue([
      { id: 'doc-1', source: { title: 'Doc One' } },
    ]);

    mockPrismaService.documentEmbedding.findMany.mockResolvedValue([
      {
        documentId: 'doc-2',
        embeddingVectorFallback: [0.1, 0.2],
        document: { title: 'Doc Two' },
      },
    ]);

    const result = await controller.globalSearch('workspace-1', 'testQuery');
    expect(result).toHaveLength(2);
    expect(result[0].id).toBe('doc-2'); // higher simulated vector score
    expect(result[1].id).toBe('doc-1');
  });
});
