import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class OptimizationService {
  constructor(private readonly prisma: PrismaService) {}

  async registerSolver(workspaceId: string, name: string, type: string, configJson: string) {
    return this.prisma.optimizationSolver.create({
      data: {
        workspaceId,
        name,
        type,
        configJson,
        isActive: true,
      },
    });
  }

  async getSolvers(workspaceId: string) {
    const solvers = await this.prisma.optimizationSolver.findMany({
      where: { workspaceId },
    });

    if (solvers.length === 0) {
      return [
        await this.prisma.optimizationSolver.create({
          data: {
            workspaceId,
            name: 'High Performance Simplex Solver',
            type: 'LP',
            configJson: JSON.stringify({ algorithm: 'SIMPLEX' }),
            isActive: true,
          },
        }),
        await this.prisma.optimizationSolver.create({
          data: {
            workspaceId,
            name: 'AI Evolutionary Heuristic Solver',
            type: 'GENETIC',
            configJson: JSON.stringify({ iterations: 1000 }),
            isActive: true,
          },
        }),
      ];
    }
    return solvers;
  }

  async optimizeConstraints(workspaceId: string, modelId: string, solverType: string) {
    let model = await this.prisma.optimizationModel.findFirst({
      where: { id: modelId },
    });

    if (!model) {
      model = await this.prisma.optimizationModel.create({
        data: {
          workspaceId,
          name: 'Cloud VM Allocation Model',
          objective: 'MINIMIZE vm_cost_usd',
          variablesJson: JSON.stringify({ vm_count: 'integer', demand: 'float' }),
        },
      });
    }

    // Solve using simulated linear solver
    const mockSolvedValues = {
      vm_count: 8,
      demand_allocated: 450,
      optimizedCostUSD: 1200,
    };

    return this.prisma.optimizationResult.create({
      data: {
        modelId: model.id,
        workspaceId,
        solvedValuesJson: JSON.stringify(mockSolvedValues),
        objectiveValue: 1200,
        status: 'FEASIBLE',
      },
    });
  }
}
