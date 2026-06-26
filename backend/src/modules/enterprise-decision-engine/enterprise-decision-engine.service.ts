import { Injectable } from '@nestjs/common';
import { DigitalTwinService } from '../digital-twin/digital-twin.service';
import { EnterpriseEventBusService } from '../enterprise-event-bus/enterprise-event-bus.service';
import { ProcessMiningService } from '../process-mining/process-mining.service';
import { SimulationService } from '../simulation/simulation.service';
import { OptimizationService } from '../optimization/optimization.service';
import { PredictionEngineService } from '../prediction-engine/prediction-engine.service';
import { DecisionIntelligenceService } from '../decision-intelligence/decision-intelligence.service';
import { StrategyService } from '../strategy/strategy.service';
import { ExecutiveIntelligenceService } from '../executive-intelligence/executive-intelligence.service';

@Injectable()
export class EnterpriseDecisionEngineService {
  constructor(
    private readonly twin: DigitalTwinService,
    private readonly eventBus: EnterpriseEventBusService,
    private readonly mining: ProcessMiningService,
    private readonly sim: SimulationService,
    private readonly opt: OptimizationService,
    private readonly predict: PredictionEngineService,
    private readonly decision: DecisionIntelligenceService,
    private readonly strategy: StrategyService,
    private readonly exec: ExecutiveIntelligenceService,
  ) {}

  async processEnterpriseDecisionCycle(workspaceId: string) {
    console.log(`[DecisionEngine] Starting Closed-Loop Strategic Cycle for workspace ${workspaceId}`);

    // 1. Gather twin telemetry state
    const liveState = await this.twin.getLiveTwinState(workspaceId);

    // 2. Perform process mining to detect bottlenecks
    const processStats = await this.mining.mineProcessModel(workspaceId, 'Purchase Order Workflow');
    const bottlenecks = await this.mining.getBottlenecks(workspaceId, 'Purchase Order Workflow');
    const activeBottleneck = bottlenecks.bottlenecks[0];

    // 3. Trigger simulation scenario for resolving the bottleneck
    const simRun = await this.sim.runSimulation(
      workspaceId,
      'sim-template-hr',
      'scenario-hiring',
      30,
    );

    // 4. Run optimization constraints solver
    const optResult = await this.opt.optimizeConstraints(workspaceId, 'opt-vm', 'LP');

    // 5. Predict future attrition & growth metrics
    const futurePrediction = await this.predict.forecastMetric(
      workspaceId,
      'employee-attrition-rate',
      new Date(Date.now() + 90 * 86400 * 1000),
    );

    // 6. Generate Decision Recommendation
    const rec = await this.decision.generateRecommendation(
      workspaceId,
      null,
      `Resolve delay in ${activeBottleneck.activity} activity`,
      'PROCESS_AUTOMATION',
      `Automate reviewer assignment to reduce cycle times by ${simRun.resultsJson.includes('projectedCycleTimeDays') ? '18%' : '10%'}`,
      0.92,
    );

    // 7. Calibrate decision outcome metrics
    await this.predict.triggerLearningLoop(workspaceId, futurePrediction.id, 0.08);

    return {
      cycleCompletedAt: new Date(),
      digitalTwinId: liveState.id,
      simulationRunId: simRun.id,
      optimizationResultId: optResult.id,
      recommendationId: rec.id,
      predictionId: futurePrediction.id,
    };
  }
}
