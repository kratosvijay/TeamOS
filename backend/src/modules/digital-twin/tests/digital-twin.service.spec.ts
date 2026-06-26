import { Test, TestingModule } from '@nestjs/testing';
import { PrismaService } from '../../prisma/prisma.service';

// Services
import { DigitalTwinService } from '../digital-twin.service';
import { EnterpriseEventBusService } from '../../enterprise-event-bus/enterprise-event-bus.service';
import { ProcessMiningService } from '../../process-mining/process-mining.service';
import { RootCauseAnalysisService } from '../../root-cause-analysis/root-cause-analysis.service';
import { SimulationService } from '../../simulation/simulation.service';
import { OptimizationService } from '../../optimization/optimization.service';
import { PredictionEngineService } from '../../prediction-engine/prediction-engine.service';
import { DecisionIntelligenceService } from '../../decision-intelligence/decision-intelligence.service';
import { StrategyService } from '../../strategy/strategy.service';
import { ExecutiveIntelligenceService } from '../../executive-intelligence/executive-intelligence.service';
import { EnterpriseDecisionEngineService } from '../../enterprise-decision-engine/enterprise-decision-engine.service';

describe('Phase 23 Enterprise Twin & Decision Intelligence Service Suite', () => {
  let twinService: DigitalTwinService;
  let eventBusService: EnterpriseEventBusService;
  let processMiningService: ProcessMiningService;
  let rcaService: RootCauseAnalysisService;
  let simulationService: SimulationService;
  let optimizationService: OptimizationService;
  let predictionService: PredictionEngineService;
  let decisionService: DecisionIntelligenceService;
  let strategyService: StrategyService;
  let execService: ExecutiveIntelligenceService;
  let decisionEngine: EnterpriseDecisionEngineService;

  const mockPrisma = {
    digitalTwin: {
      findFirst: jest.fn(),
      create: jest.fn(),
    },
    digitalTwinSnapshot: {
      create: jest.fn(),
      findMany: jest.fn(),
    },
    enterpriseEventSchema: {
      create: jest.fn(),
      findFirst: jest.fn(),
    },
    enterpriseEvent: {
      create: jest.fn(),
      findMany: jest.fn(),
      count: jest.fn(),
    },
    eventLineage: {
      create: jest.fn(),
      findMany: jest.fn(),
      findFirst: jest.fn(),
    },
    enterpriseEventConsumer: {
      create: jest.fn(),
      findMany: jest.fn(),
    },
    eventRetentionPolicy: {
      create: jest.fn(),
      findMany: jest.fn(),
    },
    processModel: {
      findFirst: jest.fn(),
      create: jest.fn(),
    },
    processExecution: {
      count: jest.fn(),
      createMany: jest.fn(),
    },
    processVariant: {
      findMany: jest.fn(),
      create: jest.fn(),
    },
    decisionScenario: {
      findFirst: jest.fn(),
      create: jest.fn(),
    },
    scenarioVersion: {
      count: jest.fn(),
      create: jest.fn(),
    },
    simulation: {
      create: jest.fn(),
    },
    simulationRun: {
      create: jest.fn(),
      count: jest.fn(),
    },
    simulationTemplate: {
      findMany: jest.fn(),
      create: jest.fn(),
    },
    optimizationSolver: {
      create: jest.fn(),
      findMany: jest.fn(),
    },
    optimizationModel: {
      findFirst: jest.fn(),
      create: jest.fn(),
    },
    optimizationResult: {
      create: jest.fn(),
    },
    predictionModel: {
      findFirst: jest.fn(),
      create: jest.fn(),
    },
    predictionResult: {
      create: jest.fn(),
      findUnique: jest.fn(),
    },
    learningLoopLog: {
      create: jest.fn(),
    },
    decisionRecommendation: {
      create: jest.fn(),
      findUnique: jest.fn(),
    },
    recommendationApproval: {
      create: jest.fn(),
      findFirst: jest.fn(),
      update: jest.fn(),
    },
    recommendationExplanation: {
      create: jest.fn(),
      findFirst: jest.fn(),
    },
    recommendationCalibration: {
      findFirst: jest.fn(),
    },
    strategicInitiative: {
      findMany: jest.fn(),
      create: jest.fn(),
    },
    enterpriseScorecard: {
      findFirst: jest.fn(),
      create: jest.fn(),
    },
    kPIDependency: {
      findMany: jest.fn(),
      create: jest.fn(),
    },
    replaySession: {
      create: jest.fn(),
    },
    decisionHistory: {
      create: jest.fn(),
    },
    enterpriseMaturity: {
      findFirst: jest.fn(),
    },
    enterpriseMetric: {
      count: jest.fn(),
    },
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        DigitalTwinService,
        EnterpriseEventBusService,
        ProcessMiningService,
        RootCauseAnalysisService,
        SimulationService,
        OptimizationService,
        PredictionEngineService,
        DecisionIntelligenceService,
        StrategyService,
        ExecutiveIntelligenceService,
        EnterpriseDecisionEngineService,
        { provide: PrismaService, useValue: mockPrisma },
      ],
    }).compile();

    twinService = module.get<DigitalTwinService>(DigitalTwinService);
    eventBusService = module.get<EnterpriseEventBusService>(EnterpriseEventBusService);
    processMiningService = module.get<ProcessMiningService>(ProcessMiningService);
    rcaService = module.get<RootCauseAnalysisService>(RootCauseAnalysisService);
    simulationService = module.get<SimulationService>(SimulationService);
    optimizationService = module.get<OptimizationService>(OptimizationService);
    predictionService = module.get<PredictionEngineService>(PredictionEngineService);
    decisionService = module.get<DecisionIntelligenceService>(DecisionIntelligenceService);
    strategyService = module.get<StrategyService>(StrategyService);
    execService = module.get<ExecutiveIntelligenceService>(ExecutiveIntelligenceService);
    decisionEngine = module.get<EnterpriseDecisionEngineService>(EnterpriseDecisionEngineService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('DigitalTwinService', () => {
    it('should generate snaphot data with mock system metrics', async () => {
      mockPrisma.digitalTwin.findFirst.mockResolvedValue({ id: 'twin-1', name: 'Twin' });
      mockPrisma.digitalTwinSnapshot.create.mockResolvedValue({ id: 'snap-1' });

      const snap = await twinService.createSnapshot('ws-1');
      expect(snap.id).toBe('snap-1');
      expect(mockPrisma.digitalTwinSnapshot.create).toHaveBeenCalled();
    });
  });

  describe('EnterpriseEventBusService', () => {
    it('should ingest actions and trace causal lineage', async () => {
      mockPrisma.enterpriseEventSchema.findFirst.mockResolvedValue(null);
      mockPrisma.enterpriseEvent.create.mockResolvedValue({ id: 'ev-2', name: 'TaskCompleted' });
      mockPrisma.eventLineage.create.mockResolvedValue({ id: 'lin-2' });
      mockPrisma.enterpriseEventConsumer.findMany.mockResolvedValue([]);

      const event = await eventBusService.publish('ws-1', 'TaskCompleted', { taskId: 't2' }, 'u1', 'ev-1');
      expect(event.name).toBe('TaskCompleted');
      expect(mockPrisma.eventLineage.create).toHaveBeenCalled();
    });
  });

  describe('ProcessMiningService & RCA', () => {
    it('should mine models and diagnose root bottlenecks', async () => {
      mockPrisma.processModel.findFirst.mockResolvedValue({ id: 'pmodel-1', name: 'Purchase Orders' });
      mockPrisma.processExecution.count.mockResolvedValue(10);

      const stats = await processMiningService.mineProcessModel('ws-1', 'Purchase Orders');
      expect(stats.metrics.totalExecutions).toBe(10);

      const rca = await rcaService.performRCA('ws-1', 'pmodel-1', 'bottleneck-review');
      expect(rca.detectedCauses).toHaveLength(2);
      expect(rca.detectedCauses[0].probability).toBe(0.85);
    });
  });

  describe('Simulation & Optimization', () => {
    it('should trigger DES simulations and solve linear cost matrices', async () => {
      mockPrisma.decisionScenario.findFirst.mockResolvedValue({ id: 'scen-1', name: 'Simulate scale' });
      mockPrisma.scenarioVersion.count.mockResolvedValue(1);
      mockPrisma.scenarioVersion.create.mockResolvedValue({});
      mockPrisma.simulation.create.mockResolvedValue({ id: 'sim-1' });
      mockPrisma.simulationRun.create.mockResolvedValue({ id: 'run-1', duration: 30 });
      mockPrisma.optimizationModel.findFirst.mockResolvedValue({ id: 'opt-1' });
      mockPrisma.optimizationResult.create.mockResolvedValue({ id: 'optres-1', objectiveValue: 1200 });

      const run = await simulationService.runSimulation('ws-1', 'temp-1', 'scen-1', 30);
      expect(run.id).toBe('run-1');

      const opt = await optimizationService.optimizeConstraints('ws-1', 'opt-1', 'LP');
      expect(opt.objectiveValue).toBe(1200);
    });
  });

  describe('PredictionEngine, Calibration, and learning loop', () => {
    it('should trigger forecasting predictions and update calibration loops', async () => {
      mockPrisma.predictionModel.findFirst.mockResolvedValue({ id: 'pred-1' });
      mockPrisma.predictionResult.create.mockResolvedValue({ id: 'res-1', predictedValue: 15.5 });
      mockPrisma.predictionResult.findUnique.mockResolvedValue({ id: 'res-1', predictedValue: 15.5 });
      mockPrisma.learningLoopLog.create.mockResolvedValue({ id: 'log-1' });

      const forecast = await predictionService.forecastMetric('ws-1', 'attrition', new Date());
      expect(forecast.predictedValue).toBe(15.5);

      const loop = await predictionService.triggerLearningLoop('ws-1', 'res-1', 15.0);
      expect(loop.id).toBe('log-1');
    });
  });

  describe('Strategy & Executive Intelligence scorecards', () => {
    it('should calculate balanced scorecards and trace initiative blockers', async () => {
      mockPrisma.enterpriseScorecard.findFirst.mockResolvedValue({ id: 'card-1', financialScore: 84.5 });
      mockPrisma.enterpriseMaturity.findFirst.mockResolvedValue({ aiMaturity: 4.5 });
      mockPrisma.strategicInitiative.findMany.mockResolvedValue([
        { id: 'init-1', name: 'Initiative 1' }
      ]);
      mockPrisma.simulationRun.count.mockResolvedValue(4);
      mockPrisma.enterpriseMetric.count.mockResolvedValue(45);

      const card = await strategyService.getBalancedScorecard('ws-1', 'Q3_2026');
      expect(card.financialScore).toBe(84.5);

      const brief = await execService.generateNarrativeBrief('ws-1');
      expect(brief.briefMarkdown).toContain('AI Maturity');
    });
  });

  describe('Enterprise Decision Engine Closed-Loop Cycle', () => {
    it('should execute complete observ-decide-learn loops', async () => {
      mockPrisma.digitalTwin.findFirst.mockResolvedValue({ id: 'twin-1', name: 'Twin' });
      mockPrisma.processModel.findFirst.mockResolvedValue({ id: 'pmodel-1' });
      mockPrisma.processExecution.count.mockResolvedValue(12);
      mockPrisma.processVariant.findMany.mockResolvedValue([]);
      mockPrisma.decisionScenario.findFirst.mockResolvedValue({ id: 'scen-1' });
      mockPrisma.scenarioVersion.count.mockResolvedValue(1);
      mockPrisma.scenarioVersion.create.mockResolvedValue({});
      mockPrisma.simulation.create.mockResolvedValue({ id: 'sim-1' });
      mockPrisma.simulationRun.create.mockResolvedValue({ id: 'run-1', resultsJson: '{}' });
      mockPrisma.optimizationModel.findFirst.mockResolvedValue({ id: 'opt-1' });
      mockPrisma.optimizationResult.create.mockResolvedValue({ id: 'optres-1' });
      mockPrisma.predictionModel.findFirst.mockResolvedValue({ id: 'pred-1' });
      mockPrisma.predictionResult.create.mockResolvedValue({ id: 'res-1', predictedValue: 10.0 });
      mockPrisma.predictionResult.findUnique.mockResolvedValue({ id: 'res-1', predictedValue: 10.0 });
      mockPrisma.learningLoopLog.create.mockResolvedValue({ id: 'log-1' });
      mockPrisma.decisionRecommendation.create.mockResolvedValue({ id: 'rec-1' });
      mockPrisma.recommendationApproval.create.mockResolvedValue({ id: 'appr-1' });
      mockPrisma.recommendationExplanation.create.mockResolvedValue({ id: 'exp-1' });

      const result = await decisionEngine.processEnterpriseDecisionCycle('ws-1');
      expect(result.cycleCompletedAt).toBeDefined();
      expect(result.recommendationId).toBe('rec-1');
    });
  });
});
