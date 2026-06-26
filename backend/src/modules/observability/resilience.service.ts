import { Injectable, HttpException, HttpStatus } from '@nestjs/common';

@Injectable()
export class ResilienceService {
  private circuitState = new Map<string, { status: 'CLOSED' | 'OPEN' | 'HALF_OPEN'; failures: number; lastStateChange: number }>();

  async executeWithResilience<T>(
    serviceName: string,
    action: () => Promise<T>,
    fallback: () => Promise<T>,
    retryCount = 3,
  ): Promise<T> {
    const circuit = this.circuitState.get(serviceName) || { status: 'CLOSED', failures: 0, lastStateChange: Date.now() };

    // Check if circuit is open
    if (circuit.status === 'OPEN') {
      const cooldown = 10000; // 10s cooldown
      if (Date.now() - circuit.lastStateChange > cooldown) {
        circuit.status = 'HALF_OPEN';
        this.circuitState.set(serviceName, circuit);
      } else {
        console.warn(`[Resilience] Circuit OPEN for ${serviceName}. Invoking Fallback.`);
        return fallback();
      }
    }

    let attempts = 0;
    while (attempts < retryCount) {
      attempts++;
      try {
        const result = await action();
        // Success: reset failures and close circuit
        if (circuit.status !== 'CLOSED') {
          circuit.status = 'CLOSED';
          circuit.failures = 0;
          circuit.lastStateChange = Date.now();
          this.circuitState.set(serviceName, circuit);
        }
        return result;
      } catch (err) {
        console.error(`[Resilience] Attempt ${attempts} failed for ${serviceName}: ${err.message}`);
        if (attempts >= retryCount) {
          // Trip circuit
          circuit.failures++;
          if (circuit.failures >= 3) {
            circuit.status = 'OPEN';
            circuit.lastStateChange = Date.now();
            console.error(`[Resilience] Tripping circuit to OPEN for ${serviceName}`);
          }
          this.circuitState.set(serviceName, circuit);
          return fallback();
        }
        // Exponential backoff
        await new Promise((resolve) => setTimeout(resolve, Math.pow(2, attempts) * 100));
      }
    }

    return fallback();
  }

  getCircuitStatus(serviceName: string) {
    return this.circuitState.get(serviceName) || { status: 'CLOSED', failures: 0 };
  }
}
