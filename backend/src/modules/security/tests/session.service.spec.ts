import { Test, TestingModule } from '@nestjs/testing';
import { SessionService } from '../session.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('SessionService', () => {
  let service: SessionService;
  let prisma: PrismaService;

  const mockPrismaService = {
    userSession: {
      create: jest.fn(),
      findMany: jest.fn(),
      count: jest.fn(),
      delete: jest.fn(),
      deleteMany: jest.fn(),
    },
    workspaceMember: {
      findMany: jest.fn(),
    },
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        SessionService,
        { provide: PrismaService, useValue: mockPrismaService },
      ],
    }).compile();

    service = module.get<SessionService>(SessionService);
    prisma = module.get<PrismaService>(PrismaService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should create session and compute risk score correctly', async () => {
    mockPrismaService.userSession.create.mockResolvedValue({ id: 'session-1', riskScore: 60 });

    const result = await service.createSession(
      'user-1',
      { browser: 'Safari', os: 'iOS', isNewDevice: true, isVPN: true },
      '192.168.1.10',
    );

    expect(result).toBeDefined();
    expect(mockPrismaService.userSession.create).toHaveBeenCalledWith(
      expect.objectContaining({
        data: expect.objectContaining({
          riskScore: 60, // 20 (new device) + 40 (VPN)
        }),
      }),
    );
  });

  it('should terminate specific session', async () => {
    mockPrismaService.userSession.delete.mockResolvedValue({ id: 'session-1' });

    const result = await service.terminateSession('session-1');
    expect(result).toBeDefined();
    expect(mockPrismaService.userSession.delete).toHaveBeenCalled();
  });
});
