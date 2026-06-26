import { Test, TestingModule } from '@nestjs/testing';
import { ApiGatewayService } from '../api-gateway.service';
import { PrismaService } from '../../prisma/prisma.service';
import { HttpException } from '@nestjs/common';

describe('ApiGatewayService', () => {
  let service: ApiGatewayService;
  let prisma: PrismaService;

  const mockPrisma = {
    aPIKey: { findUnique: jest.fn(), update: jest.fn() },
    extensionAnalytics: { create: jest.fn() },
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ApiGatewayService,
        { provide: PrismaService, useValue: mockPrisma },
      ],
    }).compile();

    service = module.get<ApiGatewayService>(ApiGatewayService);
    prisma = module.get<PrismaService>(PrismaService);
  });

  it('should validate API keys', async () => {
    const hashed = service.hashKey('test-key');
    mockPrisma.aPIKey.findUnique.mockResolvedValue({
      id: 'key-123',
      keyHash: hashed,
      expiresAt: null,
      workspaceId: 'ws-123',
    });
    mockPrisma.aPIKey.update.mockResolvedValue({});

    const result = await service.validateApiKey('test-key');
    expect(result.id).toBe('key-123');
  });

  it('should throw UNAUTHORIZED on invalid API key', async () => {
    mockPrisma.aPIKey.findUnique.mockResolvedValue(null);
    await expect(service.validateApiKey('invalid-key')).rejects.toThrow(HttpException);
  });

  it('should throw TOO_MANY_REQUESTS on rate limit breach', () => {
    const identifier = 'test-client';
    for (let i = 0; i < 5; i++) {
      service.checkRateLimit(identifier, 5);
    }
    expect(() => service.checkRateLimit(identifier, 5)).toThrow(HttpException);
  });
});
