import { Test, TestingModule } from '@nestjs/testing';
import { IntegrationController } from '../integration.controller';
import { IntegrationService } from '../integration.service';
import { PrismaService } from '../../prisma/prisma.service';
import { JwtStrategy } from '../../auth/jwt.strategy';

describe('IntegrationController', () => {
  let controller: IntegrationController;
  let service: IntegrationService;

  const mockIntegrationService = {
    getIntegrations: jest.fn(),
    getIntegrationById: jest.fn(),
    installIntegration: jest.fn(),
    uninstallIntegration: jest.fn(),
  };

  const mockPrisma = {
    workspaceMember: {
      findUnique: jest.fn(),
    },
  };

  const mockJwtStrategy = {
    validateToken: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [IntegrationController],
      providers: [
        { provide: IntegrationService, useValue: mockIntegrationService },
        { provide: PrismaService, useValue: mockPrisma },
        { provide: JwtStrategy, useValue: mockJwtStrategy },
      ],
    }).compile();

    controller = module.get<IntegrationController>(IntegrationController);
    service = module.get<IntegrationService>(IntegrationService);
  });

  it('should list integrations', async () => {
    mockIntegrationService.getIntegrations.mockResolvedValue([]);
    const res = await controller.getIntegrations('workspace-1');
    expect(res).toEqual([]);
  });

  it('should install an integration', async () => {
    mockIntegrationService.installIntegration.mockResolvedValue({ id: 'install-1' });
    const req = { user: { id: 'user-1' } };

    const res = await controller.installIntegration('workspace-1', req, {
      provider: 'GITHUB',
      name: 'GitHub',
    });
    expect(res.id).toBe('install-1');
  });
});
