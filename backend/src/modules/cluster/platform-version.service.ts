import { Injectable } from '@nestjs/common';

export interface VersionInfo {
  version: string;
  releaseDate: string;
  changelogSummary: string;
  isUpgradeAvailable: boolean;
  nextRecommendedVersion?: string;
}

@Injectable()
export class PlatformVersionService {
  private currentVersion = 'v1.20.0';

  async getCurrentVersionInfo(): Promise<VersionInfo> {
    return {
      version: this.currentVersion,
      releaseDate: '2026-06-25',
      changelogSummary: 'Enables developer REST v1 public endpoints, custom dashboard widgets, and commander CLI integration.',
      isUpgradeAvailable: true,
      nextRecommendedVersion: 'v1.21.0-rc1',
    };
  }

  async verifyVersionCompatibility(moduleName: string, moduleVersion: string): Promise<boolean> {
    // Mocks checks for core module version boundaries
    if (moduleName === 'billing' && moduleVersion.startsWith('v2.')) return false;
    return true;
  }
}
