import { Test, TestingModule } from '@nestjs/testing';
import { MCPService } from './mcp.service';
import { PrismaService } from '../prisma/prisma.service';
import { ForbiddenException } from '@nestjs/common';

describe('MCPService', () => {
  let service: MCPService;
  let prisma: PrismaService;

  const mockPrisma = {
    workspaceMember: {
      findUnique: jest.fn(),
    },
    document: {
      findMany: jest.fn(),
    },
    documentPermission: {
      findMany: jest.fn(),
    },
    task: {
      findMany: jest.fn(),
    },
    meeting: {
      findMany: jest.fn(),
    },
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        MCPService,
        { provide: PrismaService, useValue: mockPrisma },
      ],
    }).compile();

    service = module.get<MCPService>(MCPService);
    prisma = module.get<PrismaService>(PrismaService);
  });

  it('should compile and be defined', () => {
    expect(service).toBeDefined();
  });

  it('should throw ForbiddenException if user is not a member of the workspace', async () => {
    mockPrisma.workspaceMember.findUnique.mockResolvedValue(null);

    await expect(service.retrieveContext('w-1', 'u-1', 'query')).rejects.toThrow(
      ForbiddenException,
    );
  });

  it('should fetch documents, tasks, and meetings and format context blocks', async () => {
    mockPrisma.workspaceMember.findUnique.mockResolvedValue({
      workspaceId: 'w-1',
      userId: 'u-1',
      status: 'ACTIVE',
      role: 'DEVELOPER',
    });

    mockPrisma.document.findMany.mockResolvedValue([
      { id: 'd-1', title: 'Doc Architecture', contents: [{ plainText: 'Postgres vector content' }] },
    ]);

    mockPrisma.documentPermission.findMany.mockResolvedValue([]);

    mockPrisma.task.findMany.mockResolvedValue([
      { id: 't-1', key: 'TOS-101', title: 'Configure pgvector', status: 'IN_PROGRESS', priority: 'HIGH', description: 'Run migration' },
    ]);

    mockPrisma.meeting.findMany.mockResolvedValue([
      { id: 'm-1', title: 'Sprint Planning', summaries: [{ summary: 'Decided sprint goals' }], transcripts: [] },
    ]);

    const result = await service.retrieveContext('w-1', 'u-1', 'query');
    expect(result.contextText).toContain('Doc Architecture');
    expect(result.contextText).toContain('TOS-101');
    expect(result.contextText).toContain('Sprint Planning');
    expect(result.citations).toHaveLength(3);
    expect(result.citations[0].type).toBe('DOCUMENT');
    expect(result.citations[1].type).toBe('TASK');
    expect(result.citations[2].type).toBe('MEETING');
  });
});
