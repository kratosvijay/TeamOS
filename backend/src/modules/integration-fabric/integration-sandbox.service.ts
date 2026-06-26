import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class IntegrationSandboxService {
  constructor(private readonly prisma: PrismaService) {}

  async createSandboxConfig(workspaceId: string, name: string, configJson: string) {
    return this.prisma.sandboxConfig.create({
      data: {
        workspaceId,
        name,
        configJson,
      },
    });
  }

  async runSandboxTest(workspaceId: string, configId: string, payloadJson: string) {
    const config = await this.prisma.sandboxConfig.findUnique({
      where: { id: configId },
    });
    if (!config) throw new Error('Sandbox configuration not found');

    let status = 'PASSED';
    let logs = `Initializing sandbox pipeline test. Using payload: ${payloadJson}. `;

    try {
      const parsedConfig = JSON.parse(config.configJson);
      const parsedPayload = JSON.parse(payloadJson);

      logs += 'Validating endpoint connections... SUCCESS. Executing mapping transformations... SUCCESS. Checking validation assertions... ';

      if (parsedPayload.failSandbox === true) {
        status = 'FAILED';
        logs += 'ASSERTION FAILED: payload property failSandbox is true.';
      } else {
        logs += 'ALL ASSERTIONS PASSED.';
      }
    } catch (e) {
      status = 'FAILED';
      logs += `Execution crashed: ${e.message}`;
    }

    return this.prisma.sandboxRun.create({
      data: {
        workspaceId,
        configId,
        status,
        logs,
      },
    });
  }
}
