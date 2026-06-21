import { Injectable, CanActivate, ExecutionContext, UnauthorizedException, ForbiddenException } from '@nestjs/common';
import { JwtStrategy } from '../../modules/auth/jwt.strategy';
import { PrismaService } from '../../modules/prisma/prisma.service';

@Injectable()
export class WorkspaceAuthGuard implements CanActivate {
  constructor(
    private jwtStrategy: JwtStrategy,
    private prisma: PrismaService,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest();
    const authHeader = request.headers['authorization'];
    
    // Validate user authentication
    const user = await this.jwtStrategy.validateToken(authHeader);
    request.user = user;

    // Resolve Workspace ID from headers or query parameters
    const workspaceId = request.headers['x-workspace-id'] as string || request.query['workspaceId'] as string || request.params['workspaceId'] as string;
    
    if (!workspaceId) {
      throw new BadRequestException('Missing x-workspace-id header or workspaceId parameter');
    }

    // Verify Workspace Membership
    const member = await this.prisma.workspaceMember.findUnique({
      where: {
        workspaceId_userId: {
          workspaceId: workspaceId,
          userId: user.id,
        },
      },
    });

    if (!member || member.status !== 'ACTIVE') {
      throw new ForbiddenException('You are not an active member of this workspace');
    }

    // Attach membership context
    request.workspaceMember = member;
    return true;
  }
}

// Inline helper because BadRequestException needs to be imported or used cleanly
class BadRequestException extends UnauthorizedException {
  constructor(msg: string) {
    super(msg);
  }
}
