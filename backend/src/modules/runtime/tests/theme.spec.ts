import { Test, TestingModule } from '@nestjs/testing';
import { ThemeService } from '../theme.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('ThemeService', () => {
  let service: ThemeService;

  const mockPrisma = {
    applicationEntity: { create: jest.fn() },
    applicationField: { create: jest.fn() },
    applicationRelationship: { create: jest.fn() },
    applicationValidationRule: { create: jest.fn(), findMany: jest.fn() },
    formDefinition: { create: jest.fn(), findMany: jest.fn() },
    dashboardDefinition: { create: jest.fn(), findMany: jest.fn() },
    visualQueryDefinition: { create: jest.fn(), findMany: jest.fn() },
    application: { create: jest.fn(), findUnique: jest.fn(), update: jest.fn() },
    applicationVersion: { create: jest.fn(), findUnique: jest.fn(), update: jest.fn(), findFirst: jest.fn() },
    applicationPackage: { create: jest.fn() },
    marketplaceApplication: { create: jest.fn(), update: jest.fn(), findUnique: jest.fn(), findMany: jest.fn() },
    marketplacePurchase: { create: jest.fn() },
    metadataCommit: { create: jest.fn(), findUnique: jest.fn() },
    metadataBranch: { create: jest.fn(), findUnique: jest.fn(), update: jest.fn() },
    metadataMergeConflict: { create: jest.fn() },
    applicationTheme: { findFirst: jest.fn() },
    designToken: { findMany: jest.fn(), findFirst: jest.fn(), update: jest.fn(), create: jest.fn() },
    applicationComponent: { findMany: jest.fn(), findUnique: jest.fn() },
    applicationPage: { findFirst: jest.fn() },
    applicationNavigation: { findFirst: jest.fn(), update: jest.fn(), create: jest.fn() },
    applicationDatasource: { create: jest.fn() },
    applicationAnalytics: { create: jest.fn(), findMany: jest.fn() },
    applicationAudit: { create: jest.fn() },
    businessObject: { findUnique: jest.fn() },
    businessObjectAction: { findFirst: jest.fn() },
    businessObjectPolicy: { findMany: jest.fn() },
    businessObjectLifecycle: { findFirst: jest.fn(), update: jest.fn() },
    partnerExtensionManifest: { create: jest.fn() },
    partnerExtensionLifecycle: { create: jest.fn() },
    partnerExtensionBridge: { create: jest.fn() },
    partnerExtensionPermission: { create: jest.fn() },
    partnerExtensionAPI: { create: jest.fn() },
    partnerExtensionRegistry: { create: jest.fn() }
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ThemeService,
        { provide: PrismaService, useValue: mockPrisma },
      ],
    }).compile();

    service = module.get<ThemeService>(ThemeService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
