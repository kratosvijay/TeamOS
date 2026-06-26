import { Injectable, LoggerService } from '@nestjs/common';

@Injectable()
export class StructuredLoggingService implements LoggerService {
  private correlationId: string | null = null;
  private traceId: string | null = null;
  private spanId: string | null = null;
  private workspaceId: string | null = null;
  private userId: string | null = null;
  private requestId: string | null = null;

  setContextIds(ids: {
    correlationId?: string;
    traceId?: string;
    spanId?: string;
    workspaceId?: string;
    userId?: string;
    requestId?: string;
  }) {
    this.correlationId = ids.correlationId || this.correlationId;
    this.traceId = ids.traceId || this.traceId;
    this.spanId = ids.spanId || this.spanId;
    this.workspaceId = ids.workspaceId || this.workspaceId;
    this.userId = ids.userId || this.userId;
    this.requestId = ids.requestId || this.requestId;
  }

  log(message: any, context?: string) {
    console.log(JSON.stringify(this.format('INFO', message, context)));
  }

  error(message: any, trace?: string, context?: string) {
    console.error(JSON.stringify(this.format('ERROR', message, context, trace)));
  }

  warn(message: any, context?: string) {
    console.warn(JSON.stringify(this.format('WARN', message, context)));
  }

  debug(message: any, context?: string) {
    console.debug(JSON.stringify(this.format('DEBUG', message, context)));
  }

  verbose(message: any, context?: string) {
    console.log(JSON.stringify(this.format('VERBOSE', message, context)));
  }

  private format(level: string, message: any, context?: string, stack?: string) {
    return {
      level,
      timestamp: new Date().toISOString(),
      context: context || 'Application',
      message: typeof message === 'object' ? JSON.stringify(message) : message,
      traceId: this.traceId,
      spanId: this.spanId,
      workspaceId: this.workspaceId,
      userId: this.userId,
      requestId: this.requestId,
      correlationId: this.correlationId,
      stack,
    };
  }
}
