import { Injectable } from '@nestjs/common';
import * as crypto from 'crypto';

export interface Span {
  traceId: string;
  spanId: string;
  name: string;
  workspaceId: string;
  durationMs: number;
  error: boolean;
  timestamp: Date;
}

@Injectable()
export class TracingService {
  private spans: Span[] = [];

  startSpan(name: string, workspaceId: string): { traceId: string; spanId: string; end: (err?: boolean) => void } {
    const traceId = crypto.randomBytes(16).toString('hex');
    const spanId = crypto.randomBytes(8).toString('hex');
    const start = Date.now();

    return {
      traceId,
      spanId,
      end: (err = false) => {
        const durationMs = Date.now() - start;
        this.spans.push({
          traceId,
          spanId,
          name,
          workspaceId,
          durationMs,
          error: err,
          timestamp: new Date(),
        });
      },
    };
  }

  getSpans(workspaceId?: string): Span[] {
    if (workspaceId) {
      return this.spans.filter((s) => s.workspaceId === workspaceId);
    }
    return this.spans;
  }

  clearSpans() {
    this.spans = [];
  }
}
