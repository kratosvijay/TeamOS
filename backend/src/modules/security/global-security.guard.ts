import { Injectable, CanActivate, ExecutionContext, UnauthorizedException, ForbiddenException } from '@nestjs/common';
import { JwtStrategy } from '../auth/jwt.strategy';
import { SecurityService } from './security.service';

@Injectable()
export class GlobalSecurityGuard implements CanActivate {
  constructor(
    private jwtStrategy: JwtStrategy,
    private securityService: SecurityService,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest();
    const path = request.path;

    // Check exceptions list
    const exceptions = [
      '/auth/login',
      '/auth/refresh',
      '/sso/login',
      '/sso/callback',
      '/billing/webhook',
      '/github/webhook',
      '/gitlab/webhook',
      '/slack/webhook',
    ];

    if (exceptions.some((exc) => path.startsWith(exc))) {
      return true;
    }

    // Verify JWT authentication (if header is provided)
    const authHeader = request.headers['authorization'];
    let user: any = null;
    if (authHeader) {
      try {
        user = await this.jwtStrategy.validateToken(authHeader);
        request.user = user;
      } catch (err) {
        // Continue if path is not guarded by auth (some public routes), or throw if required
      }
    }

    // Resolve Workspace ID from headers, query, params, or body
    const workspaceId =
      request.headers['x-workspace-id'] ||
      request.query['workspaceId'] ||
      request.params['workspaceId'] ||
      (request.body && request.body.workspaceId);

    if (workspaceId) {
      // Resolve requester IP address
      const ipAddress =
        request.headers['x-forwarded-for'] ||
        request.socket.remoteAddress ||
        '127.0.0.1';
      
      const parsedIp = typeof ipAddress === 'string' ? ipAddress.split(',')[0].trim() : '127.0.0.1';

      // Perform IP Allowlist validation
      const isAllowed = await this.securityService.validateIP(workspaceId, parsedIp);
      if (!isAllowed) {
        throw new ForbiddenException(`Access denied: IP address ${parsedIp} is not allowed by security policy`);
      }
    }

    return true;
  }
}
