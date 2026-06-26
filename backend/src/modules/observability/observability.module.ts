import { Module, Global } from '@nestjs/common';
import { MetricsService } from './metrics.service';
import { TracingService } from './tracing.service';
import { ResilienceService } from './resilience.service';
import { CacheLayerService } from './cache-layer.service';
import { SloService } from './slo.service';
import { ChaosService } from './chaos.service';
import { ErrorBudgetService } from './error-budget.service';
import { GoldenSignalsService } from './golden-signals.service';

@Global()
@Module({
  providers: [
    MetricsService,
    TracingService,
    ResilienceService,
    CacheLayerService,
    SloService,
    ChaosService,
    ErrorBudgetService,
    GoldenSignalsService,
  ],
  exports: [
    MetricsService,
    TracingService,
    ResilienceService,
    CacheLayerService,
    SloService,
    ChaosService,
    ErrorBudgetService,
    GoldenSignalsService,
  ],
})
export class ObservabilityModule {}
