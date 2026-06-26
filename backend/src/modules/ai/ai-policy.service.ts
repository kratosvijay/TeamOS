import { Injectable, ForbiddenException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class AIPolicyService {
  constructor(private readonly prisma: PrismaService) {}

  async checkPermission(
    workspaceId: string,
    userId: string,
    targetAgentId: string,
    action: string,
  ): Promise<boolean> {
    // 1. Get member details
    const member = await this.prisma.workspaceMember.findUnique({
      where: {
        workspaceId_userId: { workspaceId, userId },
      },
    });

    if (!member) {
      throw new ForbiddenException('User is not a member of this workspace.');
    }

    // 2. Simple Role hierarchy evaluation: OWNER/ADMIN can do anything; GUEST is highly restricted
    const roleOrder = ['GUEST', 'QA', 'DEVELOPER', 'TEAM_LEAD', 'MANAGER', 'ADMIN', 'OWNER'];
    const userRoleIndex = roleOrder.indexOf(member.role);

    if (action === 'DEPLOY' && userRoleIndex < roleOrder.indexOf('ADMIN')) {
      throw new ForbiddenException('Only administrators and owners can deploy agents.');
    }

    if (action === 'EXECUTE_HIGH_RISK' && userRoleIndex < roleOrder.indexOf('DEVELOPER')) {
      throw new ForbiddenException('Insufficient privilege level to execute high-risk agent operations.');
    }

    return true;
  }
}
