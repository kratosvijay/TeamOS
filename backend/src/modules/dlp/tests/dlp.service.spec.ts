import { Test, TestingModule } from '@nestjs/testing';
import { DLPService } from '../dlp.service';
import { PrismaService } from '../../prisma/prisma.service';
import { SecurityService } from '../../security/security.service';
import { BadRequestException } from '@nestjs/common';

describe('DLPService', () => {
  let service: DLPService;
  let prisma: PrismaService;
  let securityService: SecurityService;

  const mockPrismaService = {
    dLPPolicy: {
      findFirst: jest.fn(),
      update: jest.fn(),
      create: jest.fn(),
      findMany: jest.fn(),
    },
  };

  const mockSecurityService = {
    logSecurityIncident: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        DLPService,
        { provide: PrismaService, useValue: mockPrismaService },
        { provide: SecurityService, useValue: mockSecurityService },
      ],
    }).compile();

    service = module.get<DLPService>(DLPService);
    prisma = module.get<PrismaService>(PrismaService);
    securityService = module.get<SecurityService>(SecurityService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should quarantine sensitive content like SSNs', async () => {
    mockPrismaService.dLPPolicy.findMany.mockResolvedValue([
      { name: 'SSN', pattern: '\\b\\d{3}-\\d{2}-\\d{4}\\b', action: 'Quarantine' },
    ]);

    const result = await service.scanContent('ws-1', 'My SSN is 123-45-6789.');
    expect(result.violated).toBe(true);
    expect(result.cleanText).toBe('My SSN is [QUARANTINED].');
    expect(mockSecurityService.logSecurityIncident).toHaveBeenCalled();
  });

  it('should block credit card leakage by throwing exception', async () => {
    mockPrismaService.dLPPolicy.findMany.mockResolvedValue([
      { name: 'Credit Cards', pattern: '\\b\\d{4}[- ]?\\d{4}[- ]?\\d{4}[- ]?\\d{4}\\b', action: 'Block' },
    ]);

    await expect(
      service.scanContent('ws-1', 'Credit Card: 1111-2222-3333-4444'),
    ).rejects.toThrow(BadRequestException);
  });
});
