import { Test, TestingModule } from '@nestjs/testing';
import { DeveloperService } from '../developer.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('DeveloperService', () => {
  let service: DeveloperService;
  let prisma: PrismaService;

  const mockPrisma = {
    developerApp: {
      findMany: jest.fn().mockResolvedValue([{ id: '1', name: 'App A' }]),
      create: jest.fn().mockResolvedValue({ id: '2', name: 'App B' }),
      update: jest.fn().mockResolvedValue({ id: '1', name: 'Updated App A' }),
      delete: jest.fn().mockResolvedValue({ id: '1' }),
    },
    extensionAnalytics: {
      findFirst: jest.fn(),
    },
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        DeveloperService,
        { provide: PrismaService, useValue: mockPrisma },
      ],
    }).compile();

    service = module.get<DeveloperService>(DeveloperService);
    prisma = module.get<PrismaService>(PrismaService);
  });

  it('should list developer apps', async () => {
    const apps = await service.getApps();
    expect(apps).toHaveLength(1);
    expect(apps[0].name).toBe('App A');
  });

  it('should create a developer app', async () => {
    const app = await service.createApp({
      name: 'App B',
      slug: 'app-b',
      description: 'Desc',
      version: '1.0.0',
      author: 'Author',
      category: 'Utilities',
    });
    expect(app.name).toBe('App B');
  });

  it('should update a developer app', async () => {
    const app = await service.updateApp('1', { name: 'Updated App A' });
    expect(app.name).toBe('Updated App A');
  });

  it('should delete a developer app', async () => {
    const res = await service.deleteApp('1');
    expect(res.id).toBe('1');
  });

  it('should get developer analytics', async () => {
    mockPrisma.extensionAnalytics.findFirst.mockResolvedValue({
      installs: 15,
      activeUsers: 12,
      crashes: 0,
      averageExecutionTime: 8.5,
      errors: 0,
    });
    const analytics = await service.getAnalytics('1');
    expect(analytics.installs).toBe(15);
  });
});
