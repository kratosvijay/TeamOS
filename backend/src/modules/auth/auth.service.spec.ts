import { Test, TestingModule } from '@nestjs/testing';
import { AuthService } from './auth.service';
import { PrismaService } from '../prisma/prisma.service';
import { UnauthorizedException } from '@nestjs/common';

describe('AuthService', () => {
  let service: AuthService;
  let prisma: PrismaService;

  const mockPrismaService = {
    user: {
      findUnique: jest.fn(),
      create: jest.fn(),
    },
    loginAuditLog: {
      create: jest.fn(),
    },
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AuthService,
        { provide: PrismaService, useValue: mockPrismaService },
      ],
    }).compile();

    service = module.get<AuthService>(AuthService);
    prisma = module.get<PrismaService>(PrismaService);
  });

  it('should hash and verify passwords successfully', async () => {
    const plain = 'MySecurePassword123';
    const hash = await service.hashPassword(plain);
    expect(hash).not.toBe(plain);
    
    const isMatch = await service.comparePasswords(plain, hash);
    expect(isMatch).toBe(true);
  });

  it('should throw UnauthorizedException on invalid login credentials', async () => {
    mockPrismaService.user.findUnique.mockResolvedValue(null); // No user found
    
    await expect(
      service.login('fake@teamos.com', 'wrongpassword'),
    ).rejects.toThrow(UnauthorizedException);
  });
});
