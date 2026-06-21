import { Test, TestingModule } from '@nestjs/testing';
import { SCIMService } from '../scim.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('SCIMService', () => {
  let service: SCIMService;
  let prisma: PrismaService;

  const mockPrismaService = {
    user: {
      findUnique: jest.fn(),
      create: jest.fn(),
      update: jest.fn(),
    },
    workspaceMember: {
      findUnique: jest.fn(),
      create: jest.fn(),
      update: jest.fn(),
    },
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        SCIMService,
        { provide: PrismaService, useValue: mockPrismaService },
      ],
    }).compile();

    service = module.get<SCIMService>(SCIMService);
    prisma = module.get<PrismaService>(PrismaService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should provision user through SCIM and create workspace membership', async () => {
    mockPrismaService.user.findUnique.mockResolvedValue(null);
    mockPrismaService.user.create.mockResolvedValue({ id: 'user-1', email: 'scim@teamos.com' });
    mockPrismaService.workspaceMember.findUnique.mockResolvedValue(null);
    mockPrismaService.workspaceMember.create.mockResolvedValue({ id: 'member-1' });

    const result = await service.createSCIMUser('ws-1', 'scim@teamos.com', 'SCIM User');
    expect(result).toBeDefined();
    expect(mockPrismaService.user.create).toHaveBeenCalled();
    expect(mockPrismaService.workspaceMember.create).toHaveBeenCalled();
  });

  it('should disable SCIM user by suspending workspace member registry', async () => {
    mockPrismaService.workspaceMember.findUnique.mockResolvedValue({ id: 'member-1', status: 'ACTIVE' });
    mockPrismaService.workspaceMember.update.mockResolvedValue({ id: 'member-1', status: 'SUSPENDED' });

    const result = await service.disableSCIMUser('ws-1', 'user-1');
    expect(result).toBeDefined();
    expect(mockPrismaService.workspaceMember.update).toHaveBeenCalledWith(
      expect.objectContaining({
        data: { status: 'SUSPENDED' },
      }),
    );
  });
});
