import { Injectable, HttpException, HttpStatus } from '@nestjs/common';

@Injectable()
export class ChaosService {
  private isChaosEnabled = false;
  private latencyMs = 0;
  private failureRate = 0.0; // 0.0 to 1.0

  enableChaos(enable: boolean, latency = 0, failRate = 0.0) {
    this.isChaosEnabled = enable;
    this.latencyMs = latency;
    this.failureRate = failRate;
    console.log(`[Chaos Engineering] Enabled: ${enable} | Latency: ${latency}ms | Fail Rate: ${failRate * 100}%`);
  }

  async injectFault() {
    if (!this.isChaosEnabled) return;

    // 1. Inject Latency
    if (this.latencyMs > 0) {
      await new Promise((resolve) => setTimeout(resolve, this.latencyMs));
    }

    // 2. Inject Failure
    if (Math.random() < this.failureRate) {
      throw new HttpException('[Chaos Engineering] Simulated Service Instability Failure', HttpStatus.SERVICE_UNAVAILABLE);
    }
  }

  getSettings() {
    return {
      enabled: this.isChaosEnabled,
      latencyMs: this.latencyMs,
      failureRate: this.failureRate,
    };
  }
}
