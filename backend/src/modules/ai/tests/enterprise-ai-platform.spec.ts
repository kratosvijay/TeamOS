import { Test, TestingModule } from '@nestjs/testing';
import { KnowledgeService } from '../knowledge.service';
import { EmbeddingsService } from '../embeddings.service';
import { SemanticSearchService } from '../semantic-search.service';
import { KnowledgeCollectionService } from '../knowledge-collection.service';
import { AgentRuntimeService } from '../agent-runtime.service';
import { MemoryHierarchyService } from '../memory-hierarchy.service';
import { AgentLifecycleService } from '../agent-lifecycle.service';
import { AgentRegistryService } from '../agent-registry.service';
import { AgentTeamService } from '../agent-team.service';
import { AgentCommunicationService } from '../agent-communication.service';
import { CapabilityRegistryService } from '../capability-registry.service';
import { PlannerService } from '../planner.service';
import { OrchestratorService } from '../orchestrator.service';
import { ContextBuilderService } from '../context-builder.service';
import { ToolRegistryService } from '../tool-registry.service';
import { PromptRegistryService } from '../prompt-registry.service';
import { AIGovernanceService } from '../ai-governance.service';
import { AIPolicyService } from '../ai-policy.service';
import { WorkflowRecorderService } from '../workflow-recorder.service';
import { ModelRegistryService } from '../model-registry.service';
import { AICostService } from '../ai-cost.service';
import { DatasetService } from '../dataset.service';
import { ExperimentService } from '../experiment.service';
import { AIObservabilityService } from '../ai-observability.service';
import { AIControlPlaneService } from '../ai-control-plane.service';
import { PrismaService } from '../../prisma/prisma.service';
import { SearchService } from '../../search/search.service';
import { ForbiddenException } from '@nestjs/common';

const KnowledgeEntityType = {
  DOCUMENT: 'DOCUMENT',
  TASK: 'TASK',
  PROJECT: 'PROJECT',
} as any;

const KnowledgeRelationType = {
  USES: 'USES',
  OWNS: 'OWNS',
} as any;

const AgentState = {
  DRAFT: 'DRAFT',
  CONFIGURED: 'CONFIGURED',
  READY: 'READY',
  RUNNING: 'RUNNING',
  WAITING_APPROVAL: 'WAITING_APPROVAL',
  PAUSED: 'PAUSED',
  COMPLETED: 'COMPLETED',
  FAILED: 'FAILED',
  RETRYING: 'RETRYING',
  ARCHIVED: 'ARCHIVED',
} as any;

const AgentCapability = {
  PLANNING: 'PLANNING',
  SUMMARIZATION: 'SUMMARIZATION',
  OCR: 'OCR',
  FORECASTING: 'FORECASTING',
  TRANSLATION: 'TRANSLATION',
  CODE_REVIEW: 'CODE_REVIEW',
  DEPLOYMENT: 'DEPLOYMENT',
  THREAT_DETECTION: 'THREAT_DETECTION',
  SCHEDULING: 'SCHEDULING',
} as any;

const AgentMessageType = {
  TASK_ASSIGNMENT: 'TASK_ASSIGNMENT',
  CONTEXT_TRANSFER: 'CONTEXT_TRANSFER',
  PROGRESS_UPDATE: 'PROGRESS_UPDATE',
  APPROVAL_REQUEST: 'APPROVAL_REQUEST',
  FAILURE_NOTICE: 'FAILURE_NOTICE',
  ARTIFACT_PRODUCED: 'ARTIFACT_PRODUCED',
} as any;


describe('Enterprise AI Platform Services', () => {
  let moduleRef: TestingModule;
  let prisma: PrismaService;

  const mockPrisma = {
    knowledgeNode: {
      upsert: jest.fn(),
      findUnique: jest.fn(),
    },
    knowledgeEdge: {
      create: jest.fn(),
      findMany: jest.fn(),
    },
    knowledgeCollection: {
      create: jest.fn(),
    },
    knowledgeCollectionNode: {
      create: jest.fn(),
      findMany: jest.fn(),
    },
    embedding: {
      create: jest.fn(),
      findMany: jest.fn(),
    },
    agentMemory: {
      create: jest.fn(),
      findMany: jest.fn(),
    },
    aIMessage: {
      findMany: jest.fn(),
    },
    aIWorkspaceMemory: {
      findUnique: jest.fn(),
    },
    aIAgent: {
      create: jest.fn(),
      findUnique: jest.fn(),
      findMany: jest.fn(),
    },
    agentExecution: {
      create: jest.fn(),
      findUnique: jest.fn(),
      update: jest.fn(),
    },
    agentMessage: {
      create: jest.fn(),
      findMany: jest.fn(),
    },
    aIPromptTemplate: {
      findFirst: jest.fn(),
      create: jest.fn(),
      updateMany: jest.fn(),
    },
    aIBudget: {
      findUnique: jest.fn(),
    },
    aIUsageLog: {
      findMany: jest.fn(),
      create: jest.fn(),
    },
    aIPendingAction: {
      create: jest.fn(),
    },
    workspaceMember: {
      findUnique: jest.fn(),
    },
    aIReasoningLog: {
      findMany: jest.fn(),
      create: jest.fn(),
    },
  };

  const mockSearchService = {
    search: jest.fn(),
  };

  beforeAll(async () => {
    moduleRef = await Test.createTestingModule({
      providers: [
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
        { provide: PrismaService, useValue: mockPrisma },
        { provide: SearchService, useValue: mockSearchService },
      ],
    }).compile();

    prisma = moduleRef.get<PrismaService>(PrismaService);
  });

  afterAll(async () => {
    await moduleRef.close();
  });

  // Test 1: KnowledgeService graph traversals
  it('should create nodes, edges, and traverse the knowledge graph', async () => {
    const service = moduleRef.get<KnowledgeService>(KnowledgeService);

    mockPrisma.knowledgeNode.upsert.mockResolvedValue({ id: 'n-1', label: 'PR-100' });
    mockPrisma.knowledgeEdge.create.mockResolvedValue({ id: 'e-1', sourceNodeId: 'n-1', targetNodeId: 'n-2' });
    mockPrisma.knowledgeNode.findUnique.mockResolvedValue({ id: 'n-1', label: 'PR-100' });
    mockPrisma.knowledgeEdge.findMany.mockResolvedValue([{ targetNodeId: 'n-2' }]);

    const node = await service.createNode('w-1', KnowledgeEntityType.DOCUMENT, 'doc-1', 'Runbook');
    expect(node.id).toBe('n-1');

    const edge = await service.createEdge('w-1', 'n-1', 'n-2', KnowledgeRelationType.USES);
    expect(edge.id).toBe('e-1');

    const traversal = await service.traverseGraph('w-1', 'n-1');
    expect(traversal.nodes).toBeDefined();
    expect(traversal.edges).toBeDefined();
  });

  // Test 2: EmbeddingsService vector generation
  it('should generate fallback embeddings and save them', async () => {
    const service = moduleRef.get<EmbeddingsService>(EmbeddingsService);
    mockPrisma.embedding.create.mockResolvedValue({ id: 'emb-1', entityId: 'doc-1' });

    const vector = await service.generateEmbedding('hello word');
    expect(vector.length).toBe(1536);

    const saved = await service.saveEmbedding('w-1', 'DOCUMENT', 'doc-1', 'hello');
    expect(saved.id).toBe('emb-1');
  });

  // Test 3: SemanticSearchService hybrid search
  it('should perform hybrid search combining text and semantic hits', async () => {
    const service = moduleRef.get<SemanticSearchService>(SemanticSearchService);
    mockSearchService.search.mockResolvedValue([{ id: 'doc-text', type: 'DOCUMENT' }]);
    mockPrisma.embedding.findMany.mockResolvedValue([
      { entityId: 'doc-sem', entityType: 'DOCUMENT', embeddingVectorFallback: new Array(1536).fill(0.1) },
    ]);

    const hits = await service.hybridSearch('w-1', 'deploy');
    expect(hits.length).toBeGreaterThan(0);
    expect(hits[0].id).toBeDefined();
  });

  // Test 4: KnowledgeCollectionService collection management
  it('should manage knowledge collections and associate nodes', async () => {
    const service = moduleRef.get<KnowledgeCollectionService>(KnowledgeCollectionService);
    mockPrisma.knowledgeCollection.create.mockResolvedValue({ id: 'col-1', name: 'Engineering' });
    mockPrisma.knowledgeCollectionNode.create.mockResolvedValue({ id: 'j-1', collectionId: 'col-1', nodeId: 'n-1' });

    const collection = await service.createCollection('w-1', 'Engineering');
    expect(collection.id).toBe('col-1');

    const linked = await service.addNodeToCollection('col-1', 'n-1');
    expect(linked.id).toBe('j-1');
  });

  // Test 5: AgentRuntimeService VM sandboxed execution
  it('should execute scripts in sandboxed VM loop and enforce privileges', async () => {
    const service = moduleRef.get<AgentRuntimeService>(AgentRuntimeService);

    const run = await service.executeToolInSandbox('agent-1', 'invoiceOCR', { amount: 1500 }, 'DEVELOPER');
    expect(run.status).toBe('SUCCESS');
    expect(run.extractedData.vendor).toBe('Acme Corp');

    await expect(
      service.executeToolInSandbox('agent-1', 'deploymentTrigger', {}, 'GUEST'),
    ).rejects.toThrow(ForbiddenException);
  });

  // Test 6: MemoryHierarchyService localized memory pipeline
  it('should retrieve hierarchical memory context including localized department memory', async () => {
    const service = moduleRef.get<MemoryHierarchyService>(MemoryHierarchyService);
    mockPrisma.aIMessage.findMany.mockResolvedValue([{ role: 'user', content: 'hello' }]);
    mockPrisma.agentMemory.findMany.mockResolvedValue([{ content: 'Finance limits are active.' }]);
    mockPrisma.aIWorkspaceMemory.findUnique.mockResolvedValue({ summary: 'Workspace active summary.' });

    const pipeline = await service.retrieveContextPipeline('w-1', 'u-1', 'c-1', 'query text', 'Finance');
    expect(pipeline.conversation).toBeDefined();
    expect(pipeline.department).toBeDefined();
    expect(pipeline.workspace).toBeDefined();
  });

  // Test 7: AgentLifecycleService state transitions
  it('should transition agent lifecycle states in the state machine', async () => {
    const service = moduleRef.get<AgentLifecycleService>(AgentLifecycleService);
    mockPrisma.agentExecution.findUnique.mockResolvedValue({ id: 'ex-1', status: AgentState.READY });
    mockPrisma.agentExecution.update.mockResolvedValue({ status: AgentState.RUNNING });

    const nextState = await service.transitionState('ex-1', AgentState.RUNNING);
    expect(nextState).toBe(AgentState.RUNNING);

    mockPrisma.agentExecution.findUnique.mockResolvedValue({ id: 'ex-1', status: AgentState.ARCHIVED });
    await expect(
      service.transitionState('ex-1', AgentState.RUNNING),
    ).rejects.toThrow();
  });

  // Test 8: AgentRegistryService metadata & health tracking
  it('should track agent registry metadata, health status, and counts', async () => {
    const service = moduleRef.get<AgentRegistryService>(AgentRegistryService);
    
    const registered = await service.registerAgent('agent-1', {
      ownerId: 'u-1',
      department: 'HR',
      version: '1.2.0',
      permissions: ['read_docs'],
      dependencies: [],
      approvalRules: {},
    });

    expect(registered.health).toBe('HEALTHY');
    expect(registered.version).toBe('1.2.0');

    await service.incrementUsage('agent-1');
    await service.updateHealth('agent-1', 'DEGRADED');

    const details = await service.getAgentDetails('agent-1');
    expect(details.health).toBe('DEGRADED');
    expect(details.usageCount).toBe(1);
  });

  // Test 9: AgentTeamService collaboration pipelines
  it('should run multi-agent collaboration paths (Coordinator -> Workers -> Reviewer -> Approver)', async () => {
    const service = moduleRef.get<AgentTeamService>(AgentTeamService);
    await service.createTeam('team-1', [
      { agentId: 'a-coord', role: 'COORDINATOR' },
      { agentId: 'a-worker', role: 'WORKER' },
      { agentId: 'a-reviewer', role: 'REVIEWER' },
      { agentId: 'a-approver', role: 'APPROVER' },
    ]);

    const result = await service.runTeamCollaboration('team-1', 'Process invoice', async (agentId, input) => {
      return `${input} -> Checked by ${agentId}`;
    });

    expect(result.finalOutput).toContain('a-approver');
    expect(result.collaborationPath.length).toBe(4);
  });

  // Test 10: AIControlPlaneService unified coordination requests
  it('should coordinate execution policy, routing, budgets, and HITL gates in the Control Plane', async () => {
    const service = moduleRef.get<AIControlPlaneService>(AIControlPlaneService);
    mockPrisma.workspaceMember.findUnique.mockResolvedValue({ role: 'OWNER' });
    mockPrisma.aIBudget.findUnique.mockResolvedValue({ monthlyLimit: 500, warningThreshold: 400 });
    mockPrisma.aIUsageLog.findMany.mockResolvedValue([]);
    mockPrisma.agentExecution.create.mockResolvedValue({ id: 'ex-ctrl' });
    mockPrisma.agentExecution.findUnique.mockResolvedValue({ id: 'ex-ctrl', status: AgentState.READY });

    // Ordinary request
    const response = await service.coordinateExecutionRequest('w-1', 'u-1', 'agent-1', 'Execute report', 'EXECUTE');
    expect(response.status).toBe('READY');
    expect(response.executionId).toBe('ex-ctrl');

    // High-risk trigger (e.g. rollback request) triggering approval gate
    mockPrisma.aIPendingAction.create.mockResolvedValue({ id: 'gate-101' });
    const responseHigh = await service.coordinateExecutionRequest('w-1', 'u-1', 'agent-1', 'Rollback K8s deployments', 'DEPLOY');
    expect(responseHigh.status).toBe('WAITING_APPROVAL');
    expect(responseHigh.approvalId).toBe('gate-101');
  });
});
