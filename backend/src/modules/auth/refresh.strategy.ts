import { Injectable, UnauthorizedException } from '@nestjs/common';
import * as jwt from 'jsonwebtoken';

@Injectable()
export class RefreshStrategy {
  private refreshSecret = process.env.JWT_REFRESH_SECRET || 'jwt-refresh-secret-key';

  validateToken(token: string) {
    try {
      const decoded = jwt.verify(token, this.refreshSecret) as any;
      return { userId: decoded.sub, email: decoded.email };
    } catch (e) {
      throw new UnauthorizedException('Invalid or expired refresh token');
    }
  }
}
