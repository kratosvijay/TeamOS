import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class ExecutiveService {
  constructor(private prisma: PrismaService) {}

  async getExecutiveDashboard(workspaceId: string) {
    // 1. Financial Metrics (MRR & ARR)
    const activeSeats = await this.prisma.workspaceSeat.count({
      where: { workspaceId },
    });
    // Assume 1 seat = $15 MRR. Baseline is $5000 MRR.
    const mrr = 5000 + activeSeats * 15;
    const arr = mrr * 12;

    // 2. Workspace Health (% completed tasks)
    const totalTasks = await this.prisma.task.count({
      where: { project: { workspaceId } },
    });
    const completedTasks = await this.prisma.task.count({
      where: { project: { workspaceId }, status: 'DONE' },
    });
    const workspaceHealth = totalTasks > 0 ? Math.round((completedTasks / totalTasks) * 100) : 100;

    // 3. Security Score (Calculate based on security policy settings)
    const policy = await this.prisma.securityPolicy.findUnique({
      where: { workspaceId },
    });
    let securityScore = 60; // Base score
    if (policy?.requireMFA) securityScore += 20;
    if (policy?.ipAllowlist) securityScore += 20;

    // 4. Compliance Score
    const dlpPoliciesCount = await this.prisma.dLPPolicy.count({
      where: { workspaceId },
    });
    const retentionPoliciesCount = await this.prisma.retentionPolicy.count({
      where: { workspaceId },
    });
    let complianceScore = 50;
    if (policy?.requireMFA) complianceScore += 15;
    if (policy?.ipAllowlist) complianceScore += 15;
    if (dlpPoliciesCount > 0) complianceScore += 10;
    if (retentionPoliciesCount > 0) complianceScore += 10;

    // 5. Portfolio Health
    const portfolio = await this.prisma.portfolio.findFirst({
      where: { workspaces: { some: { id: workspaceId } } },
    });
    const portfolioHealth = portfolio ? 85 : 100; // Mocked portfolio health status

    // 6. Project Risk
    const highRiskTasks = await this.prisma.task.count({
      where: {
        project: { workspaceId },
        priority: 'HIGH',
        status: { not: 'DONE' },
      },
    });
    const projectRisk = highRiskTasks > 0 ? `${highRiskTasks} High Risk Tasks` : 'LOW';

    // 7. Delivery Forecast (Remaining Story Points / Mocked Velocity)
    const remainingStoryPoints = 30;
    const estimatedCompletionDays = 14;

    // 8. Capacity Forecast & Resource Utilization
    const totalMembers = await this.prisma.workspaceMember.count({
      where: { workspaceId },
    });
    const totalCapacityHours = totalMembers * 160;
    const allocatedHours = completedTasks * 20; // Simulated consumed capacity
    const resourceUtilization = totalCapacityHours > 0 ? Math.min(Math.round((allocatedHours / totalCapacityHours) * 100), 100) : 65;

    return {
      workspaceId,
      mrr,
      arr,
      workspaceHealth,
      securityScore,
      complianceScore,
      portfolioHealth,
      projectRisk,
      deliveryForecast: {
        remainingStoryPoints,
        estimatedCompletionDays,
      },
      capacityForecast: {
        totalCapacityHours,
        resourceUtilization,
      },
      timestamp: new Date().toISOString(),
    };
  }
}
