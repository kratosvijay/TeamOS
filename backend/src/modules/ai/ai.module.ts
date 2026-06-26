import { Module } from '@nestjs/common';
import { AIService } from './ai.service';
import { AIController } from './ai.controller';
import { AIGateway } from './ai.gateway';
import { AIProcessor } from './ai.processor';
import { PrismaModule } from '../prisma/prisma.module';
import { SearchModule } from '../search/search.module';
import { MCPModule } from '../mcp/mcp.module';
import { AuthModule } from '../auth/auth.module';

// Phase 22 - Enterprise AI Platform Services
import { KnowledgeService } from './knowledge.service';
import { EmbeddingsService } from './embeddings.service';
import { SemanticSearchService } from './semantic-search.service';
import { KnowledgeCollectionService } from './knowledge-collection.service';
import { AgentRuntimeService } from './agent-runtime.service';
import { MemoryHierarchyService } from './memory-hierarchy.service';
import { AgentLifecycleService } from './agent-lifecycle.service';
import { AgentRegistryService } from './agent-registry.service';
import { AgentTeamService } from './agent-team.service';
import { AgentCommunicationService } from './agent-communication.service';
import { CapabilityRegistryService } from './capability-registry.service';
import { PlannerService } from './planner.service';
import { OrchestratorService } from './orchestrator.service';
import { ContextBuilderService } from './context-builder.service';
import { ToolRegistryService } from './tool-registry.service';
import { PromptRegistryService } from './prompt-registry.service';
import { AIGovernanceService } from './ai-governance.service';
import { AIPolicyService } from './ai-policy.service';
import { WorkflowRecorderService } from './workflow-recorder.service';
import { ModelRegistryService } from './model-registry.service';
import { AICostService } from './ai-cost.service';
import { DatasetService } from './dataset.service';
import { ExperimentService } from './experiment.service';
import { AIObservabilityService } from './ai-observability.service';
import { AIControlPlaneService } from './ai-control-plane.service';

@Module({
  imports: [
    PrismaModule,
    SearchModule,
    MCPModule,
    AuthModule,
  ],
  controllers: [AIController],
  providers: [
    AIService,
    AIGateway,
    AIProcessor,
    KnowledgeService,
    EmbeddingsService,
    SemanticSearchService,
    KnowledgeCollectionService,
    AgentRuntimeService,
    MemoryHierarchyService,
    AgentLifecycleService,
    AgentRegistryService,
    AgentTeamService,
    AgentCommunicationService,
    CapabilityRegistryService,
    PlannerService,
    OrchestratorService,
    ContextBuilderService,
    ToolRegistryService,
    PromptRegistryService,
    AIGovernanceService,
    AIPolicyService,
    WorkflowRecorderService,
    ModelRegistryService,
    AICostService,
    DatasetService,
    ExperimentService,
    AIObservabilityService,
    AIControlPlaneService,
  ],
  exports: [
    AIService,
    KnowledgeService,
    EmbeddingsService,
    SemanticSearchService,
    KnowledgeCollectionService,
    AgentRuntimeService,
    MemoryHierarchyService,
    AgentLifecycleService,
    AgentRegistryService,
    AgentTeamService,
    AgentCommunicationService,
    CapabilityRegistryService,
    PlannerService,
    OrchestratorService,
    ContextBuilderService,
    ToolRegistryService,
    PromptRegistryService,
    AIGovernanceService,
    AIPolicyService,
    WorkflowRecorderService,
    ModelRegistryService,
    AICostService,
    DatasetService,
    ExperimentService,
    AIObservabilityService,
    AIControlPlaneService,
  ],
})
export class AIModule {}
