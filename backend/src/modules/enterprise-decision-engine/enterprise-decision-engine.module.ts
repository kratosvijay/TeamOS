import { Module } from '@nestjs/common';
import { EnterpriseDecisionEngineService } from './enterprise-decision-engine.service';
import { DigitalTwinModule } from '../digital-twin/digital-twin.module';
import { EnterpriseEventBusModule } from '../enterprise-event-bus/enterprise-event-bus.module';
import { ProcessMiningModule } from '../process-mining/process-mining.module';
import { SimulationModule } from '../simulation/simulation.module';
import { OptimizationModule } from '../optimization/optimization.module';
import { PredictionEngineModule } from '../prediction-engine/prediction-engine.module';
import { DecisionIntelligenceModule } from '../decision-intelligence/decision-intelligence.module';
import { StrategyModule } from '../strategy/strategy.module';
import { ExecutiveIntelligenceModule } from '../executive-intelligence/executive-intelligence.module';

@Module({
  imports: [
    DigitalTwinModule,
    EnterpriseEventBusModule,
    ProcessMiningModule,
    SimulationModule,
    OptimizationModule,
    PredictionEngineModule,
    DecisionIntelligenceModule,
    StrategyModule,
    ExecutiveIntelligenceModule,
  ],
  providers: [EnterpriseDecisionEngineService],
  exports: [EnterpriseDecisionEngineService],
})
export class EnterpriseDecisionEngineModule {}
