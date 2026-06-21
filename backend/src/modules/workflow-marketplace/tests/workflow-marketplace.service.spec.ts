import { Test, TestingModule } from '@nestjs/testing';
import { WorkflowMarketplaceService } from '../workflow-marketplace.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('WorkflowMarketplaceService', () => {
  let service: WorkflowMarketplaceService;

  const mockPrismaService = {
    workflow: {
      create: jest.fn(),
    },
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        WorkflowMarketplaceService,
        { provide: PrismaService, useValue: mockPrismaService },
      ],
    }).compile();

    service = module.get<WorkflowMarketplaceService>(WorkflowMarketplaceService);
  });

  it('should list pre-seeded workflow marketplace templates', async () => {
    const templates = await service.listTemplates();
    expect(templates.length).toBeGreaterThan(0);
    expect(templates[0]).toHaveProperty('name');
    expect(templates[0]).toHaveProperty('category');
  });

  it('should install a template to target workspace', async () => {
    mockPrismaService.workflow.create.mockResolvedValue({ id: 'w-installed', name: 'Leave Request Automation' });

    const result = await service.installTemplate('ws-1', 'user-1', 'Leave Request Automation');
    expect(result.name).toBe('Leave Request Automation');
    expect(mockPrismaService.workflow.create).toHaveBeenCalledWith({
      data: expect.objectContaining({
        workspaceId: 'ws-1',
        name: 'Leave Request Automation',
        status: 'DRAFT',
      }),
    });
  });

  it('should throw error for unknown template name', async () => {
    await expect(service.installTemplate('ws-1', 'user-1', 'Non Existent SOP')).rejects.toThrow();
  });
});
