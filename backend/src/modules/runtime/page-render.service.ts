import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class PageRenderService {
  constructor(private prisma: PrismaService) {}

  async getRenderablePage(workspaceId: string, applicationId: string, pagePath: string) {
    const page = await this.prisma.applicationPage.findFirst({
      where: { workspaceId, applicationId, path: pagePath },
    });
    if (!page) throw new Error(`Page route ${pagePath} not found for application ${applicationId}`);

    const components = await this.prisma.applicationComponent.findMany({
      where: { workspaceId, applicationId, pageId: page.id },
    });

    return {
      id: page.id,
      name: page.name,
      path: page.path,
      layout: JSON.parse(page.layoutSchema),
      widgets: components.map((c) => ({
        id: c.id,
        name: c.name,
        type: c.type,
        config: JSON.parse(c.paramsJson),
      })),
    };
  }
}
