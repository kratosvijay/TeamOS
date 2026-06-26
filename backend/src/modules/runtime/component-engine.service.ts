import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class ComponentEngineService {
  constructor(private prisma: PrismaService) {}

  async resolveWidget(workspaceId: string, componentId: string, contextData: any) {
    const comp = await this.prisma.applicationComponent.findUnique({ where: { id: componentId } });
    if (!comp) throw new Error('Component not found');

    const params = JSON.parse(comp.paramsJson);

    // Dynamic bindings interpolation
    const resolvedParams = {} as any;
    for (const key of Object.keys(params)) {
      const val = params[key];
      if (typeof val === 'string' && val.startsWith('{{') && val.endsWith('}}')) {
        const path = val.slice(2, -2).trim();
        resolvedParams[key] = contextData[path] || val;
      } else {
        resolvedParams[key] = val;
      }
    }

    return {
      id: comp.id,
      name: comp.name,
      type: comp.type,
      resolvedParams,
    };
  }
}
