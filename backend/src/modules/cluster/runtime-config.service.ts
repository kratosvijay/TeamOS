import { Injectable } from '@nestjs/common';

@Injectable()
export class RuntimeConfigService {
  private currentConfig = new Map<string, any>();
  private history: { version: number; config: any; timestamp: Date }[] = [];
  private version = 1;

  constructor() {
    this.currentConfig.set('maxUploadSize', 10485760);
    this.currentConfig.set('logLevel', 'INFO');
    this.currentConfig.set('enableAnalytics', true);
    this.history.push({
      version: this.version,
      config: Object.fromEntries(this.currentConfig.entries()),
      timestamp: new Date(),
    });
  }

  async getValue(key: string, workspaceId?: string): Promise<any> {
    if (workspaceId) {
      const wsKey = `${workspaceId}:${key}`;
      if (this.currentConfig.has(wsKey)) {
        return this.currentConfig.get(wsKey);
      }
    }
    return this.currentConfig.get(key);
  }

  async updateConfig(key: string, value: any) {
    this.currentConfig.set(key, value);
    this.version++;
    this.history.push({
      version: this.version,
      config: Object.fromEntries(this.currentConfig.entries()),
      timestamp: new Date(),
    });
    return { version: this.version, key, value };
  }

  getHistory() {
    return this.history;
  }
}
