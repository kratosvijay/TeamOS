import { Injectable, UnauthorizedException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import * as jwt from 'jsonwebtoken';

@Injectable()
export class JwtStrategy {
  private jwtSecret = process.env.JWT_SECRET || 'jwt-access-secret-key';

  constructor(private prisma: PrismaService) {}

  async validateToken(authHeader?: string) {
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      throw new UnauthorizedException('Missing token');
    }
    const token = authHeader.split(' ')[1];
    try {
      const decoded = jwt.verify(token, this.jwtSecret) as any;
      const user = await this.prisma.user.findUnique({
        where: { id: decoded.sub },
        select: { id: true, email: true, fullName: true },
      });
      if (!user) {
        throw new UnauthorizedException('User not found');
      }
      return user;
    } catch (e) {
      throw new UnauthorizedException('Invalid token signature');
    }
  }
}
