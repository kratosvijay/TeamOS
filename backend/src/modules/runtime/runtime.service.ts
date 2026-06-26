import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class RuntimeService {
  constructor(private prisma: PrismaService) {}

  async executeBusinessObjectAction(workspaceId: string, businessObjectId: string, actionName: string, payload: any) {
    const action = await this.prisma.businessObjectAction.findFirst({
      where: { workspaceId, businessObjectId, name: actionName },
    });
    if (!action) throw new Error(`Action ${actionName} not found for Business Object ${businessObjectId}`);

    // Mock policy/permissions check
    const policies = await this.prisma.businessObjectPolicy.findMany({
      where: { workspaceId, businessObjectId },
    });

    // Execute state transition if lifecycle is configured
    const lifecycle = await this.prisma.businessObjectLifecycle.findFirst({
      where: { workspaceId, businessObjectId },
    });

    let nextState = lifecycle ? lifecycle.currentState : 'SUCCESS';
    if (lifecycle) {
      const states = JSON.parse(lifecycle.statesJson);
      if (states.transitions && states.transitions[actionName]) {
        nextState = states.transitions[actionName];
        await this.prisma.businessObjectLifecycle.update({
          where: { id: lifecycle.id },
          data: { currentState: nextState },
        });
      }
    }

    return {
      status: 'EXECUTED',
      action: actionName,
      payload,
      state: nextState,
      timestamp: new Date().toISOString(),
    };
  }

  async fetchBusinessObjectData(workspaceId: string, businessObjectId: string, queryParams: any) {
    const bo = await this.prisma.businessObject.findUnique({ where: { id: businessObjectId } });
    if (!bo) throw new Error('Business Object not found');

    // Simulate query execution
    return {
      businessObject: bo.name,
      records: [
        { id: 'rec-1', name: 'Acme Corporation', balance: 50000 },
        { id: 'rec-2', name: 'Stark Industries', balance: 250000 },
      ],
    };
  }
}
