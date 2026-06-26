import { Injectable } from '@nestjs/common';

@Injectable()
export class DeploymentService {
  private releaseHistory = [
    { version: 'v1.19.0', commit: 'abc7890', build: 420, date: '2026-06-20', strategy: 'RollingUpdate', status: 'COMPLETED' },
    { version: 'v1.20.0', commit: 'xyz1234', build: 432, date: '2026-06-25', strategy: 'Canary', status: 'COMPLETED' },
    { version: 'v1.21.0-rc1', commit: 'fgh4567', build: 440, date: '2026-06-26', strategy: 'Blue-Green', status: 'DEPLOYING' },
  ];

  async getReleaseHistory() {
    return this.releaseHistory;
  }

  async triggerRollback(targetVersion: string) {
    console.log(`[Deployment] Rollback triggered to version: ${targetVersion}`);
    const release = this.releaseHistory.find((r) => r.version === targetVersion);
    if (!release) throw new Error('Release not found');

    const rollbackRelease = {
      version: `${targetVersion}-rollback`,
      commit: release.commit,
      build: release.build + 1,
      date: new Date().toISOString().split('T')[0],
      strategy: 'Blue-Green',
      status: 'COMPLETED',
    };
    this.releaseHistory.push(rollbackRelease);
    return rollbackRelease;
  }
}
