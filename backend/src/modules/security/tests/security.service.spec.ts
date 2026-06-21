import { Test, TestingModule } from '@nestjs/testing';
import { SecurityService } from '../security.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('SecurityService', () => {
  let service: SecurityService;
  let prisma: PrismaService;

  const mockPrismaService = {
    securityPolicy: {
      upsert: jest.fn(),
      findUnique: jest.fn(),
    },
    securityIncident: {
      create: jest.fn(),
      findMany: jest.fn(),
    },
    mFARecoveryCode: {
      deleteMany: jest.fn(),
      createMany: jest.fn(),
      findFirst: jest.fn(),
      update: jest.fn(),
    },
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        SecurityService,
        { provide: PrismaService, useValue: mockPrismaService },
      ],
    }).compile();

    service = module.get<SecurityService>(SecurityService);
    prisma = module.get<PrismaService>(PrismaService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should upsert security policies successfully', async () => {
    mockPrismaService.securityPolicy.upsert.mockResolvedValue({ id: 'policy-1' });

    const result = await service.createOrUpdatePolicy('ws-1', true, 1800, false, ['192.168.1.1']);
    expect(result).toBeDefined();
    expect(mockPrismaService.securityPolicy.upsert).toHaveBeenCalled();
  });

  it('should validate allowed IP address', async () => {
    mockPrismaService.securityPolicy.findUnique.mockResolvedValue({
      workspaceId: 'ws-1',
      ipAllowlist: ['192.168.1.1'],
    });

    const isAllowed = await service.validateIP('ws-1', '192.168.1.1');
    expect(isAllowed).toBe(true);
  });

  it('should block unauthorized IP address and log incident', async () => {
    mockPrismaService.securityPolicy.findUnique.mockResolvedValue({
      workspaceId: 'ws-1',
      ipAllowlist: ['192.168.1.1'],
    });

    const isAllowed = await service.validateIP('ws-1', '10.0.0.1');
    expect(isAllowed).toBe(false);
    expect(mockPrismaService.securityIncident.create).toHaveBeenCalled();
  });

  it('should generate and verify MFA recovery codes', async () => {
    mockPrismaService.mFARecoveryCode.createMany.mockResolvedValue({ count: 8 });
    const codes = await service.generateRecoveryCodes('user-1');
    expect(codes).toHaveLength(8);

    mockPrismaService.mFARecoveryCode.findFirst.mockResolvedValue({ id: 'code-1', codeHash: 'hashed' });
    mockPrismaService.mFARecoveryCode.update.mockResolvedValue({ id: 'code-1', used: true });

    const verified = await service.verifyRecoveryCode('user-1', codes[0]);
    expect(verified).toBe(true);
  });
});
