import { Test, TestingModule } from '@nestjs/testing';
import { AuditExportService } from '../audit-export.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('AuditExportService', () => {
  let service: AuditExportService;
  let prisma: PrismaService;

  const mockPrismaService = {
    auditExport: {
      create: jest.fn(),
      update: jest.fn(),
      findMany: jest.fn(),
    },
    auditTrail: {
      findMany: jest.fn(),
    },
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AuditExportService,
        { provide: PrismaService, useValue: mockPrismaService },
      ],
    }).compile();

    service = module.get<AuditExportService>(AuditExportService);
    prisma = module.get<PrismaService>(PrismaService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should trigger and compile JSON audit exports successfully', async () => {
    mockPrismaService.auditExport.create.mockResolvedValue({ id: 'job-1', status: 'PENDING' });
    mockPrismaService.auditTrail.findMany.mockResolvedValue([
      { id: 'log-1', action: 'LOGIN', entityType: 'User', entityId: 'user-1', createdAt: new Date() },
    ]);
    mockPrismaService.auditExport.update.mockResolvedValue({ id: 'job-1', status: 'COMPLETED' });

    const result = await service.triggerAuditExport('ws-1', 'JSON', ['LOGIN']);
    expect(result.job.status).toBe('COMPLETED');
    expect(result.data).toContain('log-1');
  });

  it('should trigger and compile CSV audit exports successfully', async () => {
    mockPrismaService.auditExport.create.mockResolvedValue({ id: 'job-2', status: 'PENDING' });
    mockPrismaService.auditTrail.findMany.mockResolvedValue([
      { id: 'log-1', action: 'LOGIN', entityType: 'User', entityId: 'user-1', createdAt: new Date() },
    ]);
    mockPrismaService.auditExport.update.mockResolvedValue({ id: 'job-2', status: 'COMPLETED' });

    const result = await service.triggerAuditExport('ws-1', 'CSV', []);
    expect(result.job.status).toBe('COMPLETED');
    expect(result.data).toContain('ID,Action,EntityType,EntityID,IPAddress,CreatedAt');
    expect(result.data).toContain('log-1');
  });
});
