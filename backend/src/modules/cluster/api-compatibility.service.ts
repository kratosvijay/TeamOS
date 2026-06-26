import { Injectable } from '@nestjs/common';

export interface ApiVersionStatus {
  endpointType: 'REST' | 'GRAPHQL' | 'WEBSOCKET' | 'SDK';
  version: string;
  status: 'CURRENT' | 'DEPRECATED' | 'RETIRED';
  deprecatedAt?: string;
  migrationGuideUrl?: string;
}

@Injectable()
export class ApiCompatibilityService {
  private statuses: ApiVersionStatus[] = [
    { endpointType: 'REST', version: 'v1', status: 'CURRENT' },
    { endpointType: 'REST', version: 'v0-beta', status: 'DEPRECATED', deprecatedAt: '2026-06-01', migrationGuideUrl: 'https://docs.teamos.com/migrate/rest-v1' },
    { endpointType: 'GRAPHQL', version: 'current', status: 'CURRENT' },
    { endpointType: 'WEBSOCKET', version: 'v1', status: 'CURRENT' },
    { endpointType: 'SDK', version: 'Python-v1.0.0', status: 'CURRENT' },
    { endpointType: 'SDK', version: 'Dart-v0.9.0', status: 'DEPRECATED', deprecatedAt: '2026-06-20', migrationGuideUrl: 'https://docs.teamos.com/migrate/dart-sdk' },
  ];

  async getCompatibilityList(): Promise<ApiVersionStatus[]> {
    return this.statuses;
  }
}
