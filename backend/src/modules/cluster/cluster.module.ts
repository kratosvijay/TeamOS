import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma/prisma.module';
import { ClusterService } from './cluster.service';
import { DistributedSchedulerService } from './scheduler.service';
import { AdrService } from './adr.service';
import { DigitalTwinService } from './digital-twin.service';
import { ServiceCatalogService } from './service-catalog.service';
import { OperationsAuditService } from './operations-audit.service';
import { MaintenanceService } from './maintenance.service';
import { DependencyGraphService } from './dependency-graph.service';
import { IncidentService } from './incident.service';
import { AlertRoutingService } from './alert-routing.service';
import { CapacityPlannerService } from './capacity-planner.service';
import { ApiCompatibilityService } from './api-compatibility.service';
import { ReleaseRiskService } from './release-risk.service';
import { ExecutiveOperationsService } from './executive-operations.service';
import { TenantOperationsService } from './tenant-operations.service';
import { DeploymentService } from './deployment.service';
import { RateLimitService } from './rate-limit.service';
import { CostMonitorService } from './cost-monitor.service';
import { RuntimeConfigService } from './runtime-config.service';

import { FinOpsModule } from './finops.module';
import { PolicyModule } from './policy.module';
import { PlatformLifecycleModule } from './platform-lifecycle.module';
import { PlatformReadinessModule } from './platform-readiness.module';
import { RunbookModule } from './runbook.module';

@Module({
  imports: [
    PrismaModule,
    FinOpsModule,
    PolicyModule,
    PlatformLifecycleModule,
    PlatformReadinessModule,
    RunbookModule,
  ],
  providers: [
    ClusterService,
    DistributedSchedulerService,
    AdrService,
    DigitalTwinService,
    ServiceCatalogService,
    OperationsAuditService,
    MaintenanceService,
    DependencyGraphService,
    IncidentService,
    AlertRoutingService,
    CapacityPlannerService,
    ApiCompatibilityService,
    ReleaseRiskService,
    ExecutiveOperationsService,
    TenantOperationsService,
    DeploymentService,
    RateLimitService,
    CostMonitorService,
    RuntimeConfigService,
  ],
  exports: [
    FinOpsModule,
    PolicyModule,
    PlatformLifecycleModule,
    PlatformReadinessModule,
    RunbookModule,
    
    ClusterService,
    DistributedSchedulerService,
    AdrService,
    DigitalTwinService,
    ServiceCatalogService,
    OperationsAuditService,
    MaintenanceService,
    DependencyGraphService,
    IncidentService,
    AlertRoutingService,
    CapacityPlannerService,
    ApiCompatibilityService,
    ReleaseRiskService,
    ExecutiveOperationsService,
    TenantOperationsService,
    DeploymentService,
    RateLimitService,
    CostMonitorService,
    RuntimeConfigService,
  ],
})
export class ClusterModule {}
