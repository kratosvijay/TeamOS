import { Test, TestingModule } from '@nestjs/testing';
import { SloService } from '../../observability/slo.service';
import { ResilienceService } from '../../observability/resilience.service';
import { PolicyService } from '../policy.service';
import { AdrService } from '../adr.service';
import { FinOpsService } from '../finops.service';
import { PlatformReadinessService } from '../platform-readiness.service';
import { CompatibilityService } from '../compatibility.service';

describe('TeamOS Platform Operations Services Unit Tests', () => {
  let sloService: SloService;
  let resilienceService: ResilienceService;
  let policyService: PolicyService;
  let adrService: AdrService;
  let finOpsService: FinOpsService;
  let platformReadinessService: PlatformReadinessService;
  let compatibilityService: CompatibilityService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        SloService,
        ResilienceService,
        PolicyService,
        AdrService,
        FinOpsService,
        PlatformReadinessService,
        CompatibilityService,
      ],
    }).compile();

    sloService = module.get<SloService>(SloService);
    resilienceService = module.get<ResilienceService>(ResilienceService);
    policyService = module.get<PolicyService>(PolicyService);
    adrService = module.get<AdrService>(AdrService);
    finOpsService = module.get<FinOpsService>(FinOpsService);
    platformReadinessService = module.get<PlatformReadinessService>(PlatformReadinessService);
    compatibilityService = module.get<CompatibilityService>(CompatibilityService);
  });

  // --- SLO Service Tests ---
  describe('SloService', () => {
    it('1. should record requests and return a valid report', () => {
      sloService.recordRequest('ws-test', 50, false);
      sloService.recordRequest('ws-test', 150, false);
      const report = sloService.getSloReport('ws-test');
      expect(report.workspaceId).toBe('ws-test');
      expect(report.availabilitySli).toBe(1.0);
      expect(report.latencySliMs).toBe(100);
    });

    it('2. should handle errors and reduce the availability SLI', () => {
      sloService.recordRequest('ws-test-error', 100, false);
      sloService.recordRequest('ws-test-error', 100, true);
      const report = sloService.getSloReport('ws-test-error');
      expect(report.availabilitySli).toBe(0.5);
      expect(report.errorBudgetRemaining).toBeLessThan(100);
    });
  });

  // --- Resilience Service Tests ---
  describe('ResilienceService', () => {
    it('3. should execute action successfully under closed state', async () => {
      const action = jest.fn().mockResolvedValue('success');
      const fallback = jest.fn().mockResolvedValue('fallback');
      const result = await resilienceService.executeWithResilience('test-service', action, fallback, 2);
      expect(result).toBe('success');
      expect(action).toHaveBeenCalledTimes(1);
      expect(fallback).not.toHaveBeenCalled();
    });

    it('4. should invoke fallback and trip circuit after failures limit', async () => {
      const action = jest.fn().mockRejectedValue(new Error('API Down'));
      const fallback = jest.fn().mockResolvedValue('fallback-value');
      
      const result = await resilienceService.executeWithResilience('flaky-service', action, fallback, 3);
      expect(result).toBe('fallback-value');
      
      // Let's verify it trips to OPEN state after 3 failures
      // We trigger execution 3 times to exceed circuit thresholds
      await resilienceService.executeWithResilience('flaky-service', action, fallback, 3);
      await resilienceService.executeWithResilience('flaky-service', action, fallback, 3);
      
      const status = resilienceService.getCircuitStatus('flaky-service');
      expect(status.status).toBe('OPEN');
    });
  });

  // --- Policy Service Tests ---
  describe('PolicyService', () => {
    it('5. should pass validation when all security/compliance rules are met', async () => {
      const result = await policyService.validateDeploymentPolicy({
        tlsVersion: '1.3',
        imageUrl: 'teamos.gcr.io/backend:v1',
        runAsNonRoot: true,
      });
      expect(result.isValid).toBe(true);
      expect(result.failures).toHaveLength(0);
    });

    it('6. should identify failures when tls version or root execution limits are breached', async () => {
      const result = await policyService.validateDeploymentPolicy({
        tlsVersion: '1.2',
        imageUrl: 'public-docker/backend:v1',
        runAsNonRoot: false,
      });
      expect(result.isValid).toBe(false);
      expect(result.failures.length).toBe(3); // TLS 1.3, Authorized Registry, and root user checks fail
    });
  });

  // --- ADR Service Tests ---
  describe('AdrService', () => {
    it('7. should retrieve pre-populated architecture decisions list', async () => {
      const adrs = await adrService.getAdrs();
      expect(adrs.length).toBeGreaterThanOrEqual(2);
      expect(adrs[0].id).toBe('ADR-001');
    });

    it('8. should successfully append and track new records', async () => {
      const newRecord = await adrService.createAdr(
        'ADR-003: Redis Sentinel Clustering',
        'ACCEPTED',
        'Cache Team',
        ['v1.21.0'],
        'High cache read availability needed',
        'Deploy 3-node Redis Sentinel replication topology'
      );
      expect(newRecord.id).toBe('ADR-003');
      expect(newRecord.owner).toBe('Cache Team');
      
      const list = await adrService.getAdrs();
      expect(list.length).toBe(3);
    });
  });

  // --- FinOps Service Tests ---
  describe('FinOpsService', () => {
    it('9. should analyze spot workloads and return idle resources cost waste', async () => {
      const spot = await finOpsService.getSpotAnalysis();
      expect(spot.potentialSavingsPercent).toBe(42.5);
      expect(spot.spotEligibleWorkloads).toContain('teamos-bi-worker');

      const idle = await finOpsService.getIdleResources();
      expect(idle.length).toBeGreaterThan(0);
      expect(idle[0].monthlyWasteCost).toBe(120.0);
    });
  });

  // --- Platform Readiness & Compatibility Tests ---
  describe('PlatformReadinessService & CompatibilityService', () => {
    it('10. should report high readiness score and execute compatibility audits', async () => {
      const report = await platformReadinessService.getReadinessReport();
      expect(report.score).toBe(98);
      expect(report.overall).toBe('READY');

      const audit = await compatibilityService.runCompatibilityAudit('v1.21.0');
      expect(audit.length).toBe(4);
      expect(audit.find(c => c.moduleName === 'ERP-Finance')?.isCompatible).toBe(true);
    });
  });
});
