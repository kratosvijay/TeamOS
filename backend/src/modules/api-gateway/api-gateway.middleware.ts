import { Injectable, NestMiddleware, UnauthorizedException } from '@nestjs/common';
import { Request, Response, NextFunction } from 'express';
import { ApiGatewayService } from './api-gateway.service';

@Injectable()
export class ApiGatewayMiddleware implements NestMiddleware {
  constructor(private readonly apiGatewayService: ApiGatewayService) {}

  async use(req: Request, res: Response, next: NextFunction) {
    const start = Date.now();
    const apiKeyHeader = req.headers['x-api-key'] as string;

    if (!apiKeyHeader) {
      if (req.path.startsWith('/api/v1')) {
        throw new UnauthorizedException('API key is required for public REST APIs under /api/v1');
      }
      return next();
    }

    try {
      const apiKeyRecord = await this.apiGatewayService.validateApiKey(apiKeyHeader);

      this.apiGatewayService.checkRateLimit(apiKeyRecord.keyHash);

      req['apiKey'] = apiKeyRecord;
      req['workspaceId'] = apiKeyRecord.workspaceId;

      res.on('finish', () => {
        const duration = Date.now() - start;
        const hasError = res.statusCode >= 400;
        this.apiGatewayService.logAnalytics(apiKeyRecord.workspaceId, req.path, duration, hasError);
      });

      next();
    } catch (err) {
      const duration = Date.now() - start;
      this.apiGatewayService.logAnalytics('unknown', req.path, duration, true);
      throw err;
    }
  }
}
