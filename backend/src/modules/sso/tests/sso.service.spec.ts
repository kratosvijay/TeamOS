import { Test, TestingModule } from '@nestjs/testing';
import { SSOService } from '../sso.service';
import { PrismaService } from '../../prisma/prisma.service';
import { AuthService } from '../../auth/auth.service';

describe('SSOService', () => {
  let service: SSOService;
  let prisma: PrismaService;
  let authService: AuthService;

  const mockPrismaService = {
    sSOProvider: {
      create: jest.fn(),
      findMany: jest.fn(),
      findUnique: jest.fn(),
      findFirst: jest.fn(),
    },
    user: {
      findUnique: jest.fn(),
      create: jest.fn(),
    },
    workspaceMember: {
      findUnique: jest.fn(),
      create: jest.fn(),
    },
    userSession: {
      create: jest.fn(),
    },
  };

  const mockAuthService = {
    generateTokenPair: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        SSOService,
        { provide: PrismaService, useValue: mockPrismaService },
        { provide: AuthService, useValue: mockAuthService },
      ],
    }).compile();

    service = module.get<SSOService>(SSOService);
    prisma = module.get<PrismaService>(PrismaService);
    authService = module.get<AuthService>(AuthService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should create SSO provider configuration', async () => {
    mockPrismaService.sSOProvider.create.mockResolvedValue({ id: 'sso-1' });

    const result = await service.createSSOProvider('ws-1', 'Okta', 'https://okta.com/metadata');
    expect(result).toBeDefined();
    expect(mockPrismaService.sSOProvider.create).toHaveBeenCalled();
  });

  it('should verify SSO login and auto provision user', async () => {
    mockPrismaService.sSOProvider.findFirst.mockResolvedValue({ id: 'sso-1', providerType: 'Okta', enabled: true });
    mockPrismaService.user.findUnique.mockResolvedValue(null); // User not found, triggers JIT
    mockPrismaService.user.create.mockResolvedValue({ id: 'user-1', email: 'sso@teamos.com' });
    mockPrismaService.workspaceMember.findUnique.mockResolvedValue(null);
    mockPrismaService.workspaceMember.create.mockResolvedValue({ id: 'member-1' });
    mockPrismaService.userSession.create.mockResolvedValue({ id: 'session-1' });
    mockAuthService.generateTokenPair.mockResolvedValue({ accessToken: 'access', refreshToken: 'refresh' });

    const result = await service.verifySSOLogin('sso@teamos.com', 'Okta', 'ws-1');
    expect(result).toBeDefined();
    expect(result.tokens).toBeDefined();
    expect(mockPrismaService.user.create).toHaveBeenCalled();
  });
});
