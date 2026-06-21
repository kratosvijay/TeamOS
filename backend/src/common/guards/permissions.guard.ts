import { Injectable, CanActivate, ExecutionContext } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { PERMISSIONS_KEY } from '../decorators/permissions.decorator';
import { WorkspaceRole } from '@prisma/client';

const RolePermissions: Record<WorkspaceRole, string[]> = {
  OWNER: ['*'],
  ADMIN: ['*'],
  MANAGER: [
    'can_manage_workspace',
    'can_manage_users',
    'can_create_projects',
    'can_manage_sprints',
    'can_manage_tasks',
    'can_manage_documents',
    'can_manage_meetings',
  ],
  TEAM_LEAD: [
    'can_create_projects',
    'can_manage_sprints',
    'can_manage_tasks',
    'can_manage_documents',
    'can_manage_meetings',
  ],
  DEVELOPER: [
    'can_manage_tasks',
    'can_manage_documents',
    'can_manage_meetings',
  ],
  QA: [
    'can_manage_tasks',
    'can_manage_documents',
  ],
  GUEST: [],
};

@Injectable()
export class PermissionsGuard implements CanActivate {
  constructor(private reflector: Reflector) {}

  canActivate(context: ExecutionContext): boolean {
    const requiredPermissions = this.reflector.getAllAndOverride<string[]>(PERMISSIONS_KEY, [
      context.getHandler(),
      context.getClass(),
    ]);
    if (!requiredPermissions) {
      return true;
    }
    const request = context.switchToHttp().getRequest();
    const member = request.workspaceMember;
    if (!member) {
      return false;
    }

    const permissions = RolePermissions[member.role] || [];
    if (permissions.includes('*')) {
      return true;
    }

    return requiredPermissions.every((perm) => permissions.includes(perm));
  }
}
