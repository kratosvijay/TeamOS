import { Controller, Get, Res } from '@nestjs/common';
import { Response } from 'express';

@Controller()
export class ApiGatewayController {
  @Get('openapi.json')
  getOpenApiJson() {
    return {
      openapi: '3.0.0',
      info: {
        title: 'TeamOS Enterprise API',
        description: 'PaaS & Developer Extensions public API schemas.',
        version: '1.0.0',
      },
      paths: {
        '/api/v1/developer/apps': {
          get: {
            summary: 'Get all apps',
            responses: {
              '200': { description: 'Success' },
            },
          },
        },
      },
    };
  }

  @Get('docs')
  redirectToDocs(@Res() res: Response) {
    return res.redirect('/api/docs');
  }
}
