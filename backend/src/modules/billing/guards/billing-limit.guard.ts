import { Injectable, CanActivate, ExecutionContext, HttpException, HttpStatus } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { PrismaService } from '../../prisma/prisma.service';
import { BillingGraceService } from '../billing-grace.service';

export const LIMIT_METADATA_KEY = 'billing_limit_key';
export const CheckLimit = (limit: string) => (target: any, key?: string, descriptor?: any) => {
  Reflector.createDecorator<string>({ key: LIMIT_METADATA_KEY });
  Reflect.defineMetadata(LIMIT_METADATA_KEY, limit, descriptor ? descriptor.value : target);
};

@Injectable()
export class BillingLimitGuard implements CanActivate {
  constructor(
    private readonly reflector: Reflector,
    private readonly prisma: PrismaService,
    private readonly graceService: BillingGraceService,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest();
    const workspaceId =
      request.headers['x-workspace-id'] as string ||
      request.query['workspaceId'] as string ||
      request.params['workspaceId'] as string ||
      request.body?.workspaceId as string;

    if (!workspaceId) {
      return true; // Bypassed if no workspace scope
    }

    const workspace = await this.prisma.workspace.findUnique({
      where: { id: workspaceId },
      select: {
        plan: true,
        subscriptionStatus: true,
        aiTokensUsed: true,
        storageBytesUsed: true,
      },
    });

    if (!workspace) {
      return true;
    }

    // Grace Period Checks: PAST_DUE check
    if (workspace.subscriptionStatus === 'PAST_DUE') {
      const grace = await this.graceService.checkGracePeriod(workspaceId);
      if (!grace.allowed) {
        throw new HttpException(
          { code: 'SUBSCRIPTION_PAST_DUE', message: 'Grace period has expired. Mutations are blocked.' },
          HttpStatus.PAYMENT_REQUIRED,
        );
      }
    } else if (workspace.subscriptionStatus === 'CANCELED' || workspace.subscriptionStatus === 'PAUSED') {
      throw new HttpException(
        { code: 'SUBSCRIPTION_INACTIVE', message: 'Subscription is inactive. Mutations are blocked.' },
        HttpStatus.PAYMENT_REQUIRED,
      );
    }

    // Determine the required limit check
    const limitType = this.reflector.get<string>(LIMIT_METADATA_KEY, context.getHandler());
    if (!limitType) {
      return true;
    }

    // Enterprise plan bypasses all limits
    if (workspace.plan === 'ENTERPRISE') {
      return true;
    }

    // Enforce limits
    let allowed = 0;
    let current = 0;

    switch (limitType) {
      case 'USERS': {
        allowed = workspace.plan === 'FREE' ? 5 : workspace.plan === 'STARTUP' ? 15 : 100;
        current = await this.prisma.workspaceSeat.count({
          where: { workspaceId, status: 'ASSIGNED' },
        });
        break;
      }
      case 'PROJECTS': {
        allowed = workspace.plan === 'FREE' ? 5 : workspace.plan === 'STARTUP' ? 50 : 500;
        current = await this.prisma.project.count({
          where: { workspaceId },
        });
        break;
      }
      case 'STORAGE': {
        // Free: 1GB, Startup: 10GB, Business: 100GB
        const limitGb = workspace.plan === 'FREE' ? 1 : workspace.plan === 'STARTUP' ? 10 : 100;
        allowed = limitGb * 1024 * 1024 * 1024;
        current = Number(workspace.storageBytesUsed);
        break;
      }
      case 'AI_TOKENS': {
        allowed = workspace.plan === 'FREE' ? 5000 : workspace.plan === 'STARTUP' ? 50000 : 500000;
        current = workspace.aiTokensUsed;
        break;
      }
      case 'RECORDINGS': {
        if (workspace.plan === 'FREE') {
          throw new HttpException(
            {
              code: 'PLAN_LIMIT_REACHED',
              limit: 'RECORDINGS',
              current: 1,
              allowed: 0,
            },
            HttpStatus.PAYMENT_REQUIRED,
          );
        }
        return true;
      }
      case 'INTEGRATIONS': {
        if (workspace.plan === 'FREE') {
          throw new HttpException(
            {
              code: 'PLAN_LIMIT_REACHED',
              limit: 'INTEGRATIONS',
              current: 1,
              allowed: 0,
            },
            HttpStatus.PAYMENT_REQUIRED,
          );
        }
        return true;
      }
      default:
        return true;
    }

    if (current >= allowed) {
      throw new HttpException(
        {
          code: 'PLAN_LIMIT_REACHED',
          limit: limitType,
          current: current + 1,
          allowed,
        },
        HttpStatus.PAYMENT_REQUIRED,
      );
    }

    return true;
  }
}
