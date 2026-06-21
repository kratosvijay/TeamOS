import { Injectable, UnauthorizedException, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import * as bcrypt from 'bcrypt';
import * as jwt from 'jsonwebtoken';

@Injectable()
export class AuthService {
  private jwtSecret = process.env.JWT_SECRET || 'jwt-access-secret-key';
  private refreshSecret = process.env.JWT_REFRESH_SECRET || 'jwt-refresh-secret-key';

  constructor(private prisma: PrismaService) {}

  async hashPassword(password: string): Promise<string> {
    return bcrypt.hash(password, 10);
  }

  async comparePasswords(password: string, hash: string): Promise<boolean> {
    return bcrypt.compare(password, hash);
  }

  async generateTokenPair(userId: string, email: string) {
    const payload = { sub: userId, email };
    
    const accessToken = jwt.sign(payload, this.jwtSecret, { expiresIn: '15m' });
    const refreshToken = jwt.sign(payload, this.refreshSecret, { expiresIn: '7d' });

    return { accessToken, refreshToken };
  }

  async register(email: string, passwordHash: string, fullName: string) {
    const existingUser = await this.prisma.user.findUnique({ where: { email } });
    if (existingUser) {
      throw new BadRequestException('User with this email already exists');
    }

    return this.prisma.user.create({
      data: {
        email,
        passwordHash,
        fullName,
      },
    });
  }

  async login(email: string, passwordPlain: string, ip?: string, userAgent?: string) {
    const user = await this.prisma.user.findUnique({ where: { email } });
    if (!user || !user.passwordHash) {
      throw new UnauthorizedException('Invalid credentials');
    }

    const isMatch = await this.comparePasswords(passwordPlain, user.passwordHash);
    if (!isMatch) {
      // Log failed audit log
      await this.prisma.loginAuditLog.create({
        data: { userId: user.id, status: 'FAILED', ipAddress: ip, userAgent: userAgent },
      });
      throw new UnauthorizedException('Invalid credentials');
    }

    // Log success audit log
    await this.prisma.loginAuditLog.create({
      data: { userId: user.id, status: 'SUCCESS', ipAddress: ip, userAgent: userAgent },
    });

    return this.generateTokenPair(user.id, user.email);
  }

  async refreshTokens(token: string) {
    try {
      const decoded = jwt.verify(token, this.refreshSecret) as any;
      const user = await this.prisma.user.findUnique({ where: { id: decoded.sub } });
      if (!user) {
        throw new UnauthorizedException('User not found');
      }

      // Rotate tokens
      return this.generateTokenPair(user.id, user.email);
    } catch (e) {
      throw new UnauthorizedException('Invalid refresh token');
    }
  }

  async verifyOAuthCode(provider: 'google' | 'microsoft', code: string, ip?: string, userAgent?: string) {
    // In production, exchange authorization code for access credentials via HTTP client:
    // Google: POST https://oauth2.googleapis.com/token
    // Microsoft: POST https://login.microsoftonline.com/common/oauth2/v2.0/token
    // Here we resolve a mocked user email/name from the code validation
    
    const resolvedEmail = `${provider}-user-${code.substring(0, 5)}@teamos.com`;
    const resolvedName = `${provider.toUpperCase()} Enterprise User`;

    let user = await this.prisma.user.findUnique({ where: { email: resolvedEmail } });
    if (!user) {
      user = await this.prisma.user.create({
        data: {
          email: resolvedEmail,
          fullName: resolvedName,
          googleId: provider === 'google' ? `g-${code}` : undefined,
          microsoftId: provider === 'microsoft' ? `ms-${code}` : undefined,
        },
      });
    }

    await this.prisma.loginAuditLog.create({
      data: { userId: user.id, status: 'SUCCESS', ipAddress: ip, userAgent: userAgent },
    });

    return this.generateTokenPair(user.id, user.email);
  }
}
