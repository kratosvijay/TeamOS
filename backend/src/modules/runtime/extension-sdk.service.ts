import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class ExtensionSdkService {
  constructor(private prisma: PrismaService) {}

  async registerExtension(workspaceId: string, name: string, version: string, publisher: string, configSchema = '{}') {
    return this.prisma.partnerExtensionManifest.create({
      data: { workspaceId, name, version, publisher, configSchema },
    });
  }

  async installExtension(workspaceId: string, extensionId: string) {
    return this.prisma.partnerExtensionLifecycle.create({
      data: { workspaceId, extensionId, status: 'INSTALLED' },
    });
  }

  async configureExtensionBridge(workspaceId: string, extensionId: string, channelName: string, bridgeConfig = '{}') {
    return this.prisma.partnerExtensionBridge.create({
      data: { workspaceId, extensionId, channelName, bridgeConfig },
    });
  }

  async grantExtensionPermission(workspaceId: string, extensionId: string, scope: string) {
    return this.prisma.partnerExtensionPermission.create({
      data: { workspaceId, extensionId, scope, isGranted: true },
    });
  }

  async registerExtensionAPI(workspaceId: string, extensionId: string, endpointPath: string, method: string, configJson = '{}') {
    return this.prisma.partnerExtensionAPI.create({
      data: { workspaceId, extensionId, endpointPath, method, configJson },
    });
  }

  async connectRegistry(workspaceId: string, name: string, registryUrl: string, authConfig = '{}') {
    return this.prisma.partnerExtensionRegistry.create({
      data: { workspaceId, name, registryUrl, authConfig },
    });
  }
}
