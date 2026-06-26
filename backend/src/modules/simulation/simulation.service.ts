import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class SimulationService {
  constructor(private readonly prisma: PrismaService) {}

  async runSimulation(
    workspaceId: string,
    templateId: string,
    scenarioId: string,
    durationDays: number,
    branchScenarioId?: string,
  ) {
    let scenario = await this.prisma.decisionScenario.findFirst({
      where: { id: scenarioId },
    });

    if (!scenario) {
      scenario = await this.prisma.decisionScenario.create({
        data: {
          workspaceId,
          name: 'Hiring Expansion Scenario',
          description: 'Simulating the impact of adding 5 junior developers',
          status: 'DRAFT',
          parentScenarioId: branchScenarioId,
        },
      });
    }

    // Save scenario version
    const versionCount = await this.prisma.scenarioVersion.count({
      where: { scenarioId: scenario.id },
    });

    await this.prisma.scenarioVersion.create({
      data: {
        scenarioId: scenario.id,
        versionNumber: versionCount + 1,
        configJson: JSON.stringify({ durationDays, templateId }),
        notes: `Simulated run on template ${templateId}`,
      },
    });

    // Run details
    const sim = await this.prisma.simulation.create({
      data: {
        workspaceId,
        name: `DES Run - ${scenario.name}`,
        configJson: JSON.stringify({ durationDays, templateId }),
      },
    });

    const mockRun = await this.prisma.simulationRun.create({
      data: {
        simulationId: sim.id,
        workspaceId,
        status: 'COMPLETED',
        duration: durationDays,
        resultsJson: JSON.stringify({
          projectedCycleTimeDays: 4.2,
          projectedReworkRate: 0.12,
          projectedCostSavingsUSD: 14000,
          resourceUtilization: {
            developers: 0.85,
            reviewers: 0.60,
          },
        }),
        startedAt: new Date(Date.now() - 30000),
        endedAt: new Date(),
      },
    });

    return mockRun;
  }

  async getTemplates(workspaceId: string) {
    const templates = await this.prisma.simulationTemplate.findMany({
      where: { workspaceId },
    });

    if (templates.length === 0) {
      return [
        await this.prisma.simulationTemplate.create({
          data: {
            workspaceId,
            name: 'Hiring Expansion Template',
            description: 'Evaluate impact of hiring more developers on project lead times.',
            configJson: JSON.stringify({ roles: ['DEVELOPER'], counts: [5] }),
            category: 'HR',
          },
        }),
        await this.prisma.simulationTemplate.create({
          data: {
            workspaceId,
            name: 'Budget Cut Template',
            description: 'Simulate infrastructure capacity scaling under 20% budget reductions.',
            configJson: JSON.stringify({ reductionPercent: 20 }),
            category: 'FINANCE',
          },
        }),
      ];
    }
    return templates;
  }
}
