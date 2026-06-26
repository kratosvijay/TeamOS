import { Injectable, HttpException, HttpStatus } from '@nestjs/common';
import * as vm from 'vm';
import { SdkService } from '../sdk/sdk.service';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class ExtensionRuntimeService {
  constructor(
    private readonly sdkService: SdkService,
    private readonly prisma: PrismaService,
  ) {}

  async runExtension(extensionId: string, workspaceId: string, code: string, eventName: string, eventData: any) {
    const permissions = await this.prisma.extensionPermission.findMany({
      where: { extensionId },
    });
    const permissionNames = permissions.map((p) => p.permission);

    const customSdk = {
      getTasks: async () => {
        if (!permissionNames.includes('READ_TASKS')) {
          throw new Error('Permission denied: READ_TASKS required');
        }
        return this.sdkService.getTasks(workspaceId);
      },
      getDocuments: async () => {
        if (!permissionNames.includes('READ_DOCUMENTS')) {
          throw new Error('Permission denied: READ_DOCUMENTS required');
        }
        return this.sdkService.getDocuments(workspaceId);
      },
      getMeetings: async () => {
        if (!permissionNames.includes('READ_MEETINGS')) {
          throw new Error('Permission denied: READ_MEETINGS required');
        }
        return this.sdkService.getMeetings(workspaceId);
      },
      executeAi: async (prompt: string) => {
        if (!permissionNames.includes('AI_EXECUTE')) {
          throw new Error('Permission denied: AI_EXECUTE required');
        }
        return this.sdkService.executeAiCompletion(prompt);
      },
    };

    const sandbox = {
      sdk: customSdk,
      event: { name: eventName, data: eventData },
      console: {
        log: (...args: any[]) => console.log(`[Plugin Sandbox ${extensionId}]:`, ...args),
        error: (...args: any[]) => console.error(`[Plugin Sandbox Error ${extensionId}]:`, ...args),
      },
      result: null,
    };

    vm.createContext(sandbox);

    const start = Date.now();
    try {
      const script = new vm.Script(code);
      script.runInContext(sandbox, { timeout: 1000 });
      const duration = Date.now() - start;

      await this.logExecutionMetrics(extensionId, duration, false);
      return sandbox.result;
    } catch (err) {
      const duration = Date.now() - start;
      await this.logExecutionMetrics(extensionId, duration, true);
      throw new HttpException(`Plugin execution error: ${err.message}`, HttpStatus.BAD_REQUEST);
    }
  }

  async logExecutionMetrics(extensionId: string, duration: number, isError: boolean) {
    try {
      await this.prisma.extensionAnalytics.create({
        data: {
          extensionId,
          installs: 0,
          activeUsers: 1,
          crashes: isError ? 1 : 0,
          averageExecutionTime: duration,
          errors: isError ? 1 : 0,
        },
      });
    } catch {
      // Swallowed if table not seeded
    }
  }

  async install(extensionId: string) {
    return { status: 'INSTALLED', extensionId };
  }

  async initialize(extensionId: string) {
    return { status: 'INITIALIZED', extensionId };
  }

  async enable(extensionId: string) {
    return { status: 'ENABLED', extensionId };
  }

  async disable(extensionId: string) {
    return { status: 'DISABLED', extensionId };
  }

  async upgrade(extensionId: string) {
    return { status: 'UPGRADED', extensionId };
  }

  async uninstall(extensionId: string) {
    return { status: 'UNINSTALLED', extensionId };
  }
}
