import { Test, TestingModule } from '@nestjs/testing';
import { ProjectProvisioningWorker } from './event.processor';
import { PrismaService } from '../prisma/prisma.service';

describe('ProjectProvisioningWorker', () => {
  let worker: ProjectProvisioningWorker;
  let prisma: PrismaService;

  const mockPrismaService = {
    project: {
      findUnique: jest.fn().mockResolvedValue({ workspaceId: 'work-123' }),
    },
    channel: {
      create: jest.fn(),
    },
    meeting: {
      create: jest.fn(),
    },
    document: {
      create: jest.fn(),
    },
    sprint: {
      create: jest.fn(),
    },
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ProjectProvisioningWorker,
        { provide: PrismaService, useValue: mockPrismaService },
      ],
    }).compile();

    worker = module.get<ProjectProvisioningWorker>(ProjectProvisioningWorker);
    prisma = module.get<PrismaService>(PrismaService);
  });

  it('should create project resources correctly', async () => {
    // Verify that the private mock handlers execute Prisma creations
    const projectId = 'proj-123';
    const workspaceId = 'work-123';
    const userId = 'user-123';
    const projectKey = 'TOS';

    await (worker as any).createChatChannel(workspaceId, projectId, projectKey);
    expect(mockPrismaService.channel.create).toHaveBeenCalled();

    await (worker as any).createMeetingRoom(projectId, projectKey);
    expect(mockPrismaService.meeting.create).toHaveBeenCalled();

    await (worker as any).createDocumentSpace(projectId, userId);
    expect(mockPrismaService.document.create).toHaveBeenCalled();

    await (worker as any).createDefaultSprint(projectId);
    expect(mockPrismaService.sprint.create).toHaveBeenCalled();
  });
});
