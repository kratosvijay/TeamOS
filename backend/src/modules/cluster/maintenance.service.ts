import { Injectable } from '@nestjs/common';

export interface MaintenanceWindow {
  id: string;
  startTime: Date;
  endTime: Date;
  status: 'SCHEDULED' | 'ACTIVE' | 'COMPLETED' | 'CANCELLED';
  description: string;
  isReadOnlyMode: boolean;
}

@Injectable()
export class MaintenanceService {
  private activeWindows: MaintenanceWindow[] = [];

  async scheduleWindow(description: string, startTime: Date, endTime: Date, isReadOnly = true): Promise<MaintenanceWindow> {
    const newWindow: MaintenanceWindow = {
      id: `maint-${Math.random().toString(36).substr(2, 9)}`,
      startTime,
      endTime,
      status: 'SCHEDULED',
      description,
      isReadOnlyMode: isReadOnly,
    };
    this.activeWindows.push(newWindow);
    return newWindow;
  }

  async getScheduledWindows(): Promise<MaintenanceWindow[]> {
    return this.activeWindows;
  }

  async activateReadOnlyMode(windowId: string) {
    const window = this.activeWindows.find((w) => w.id === windowId);
    if (window) {
      window.status = 'ACTIVE';
      window.isReadOnlyMode = true;
      console.log(`[Maintenance] Platform entered READ-ONLY mode for window: ${windowId}`);
    }
  }

  async endMaintenance(windowId: string) {
    const window = this.activeWindows.find((w) => w.id === windowId);
    if (window) {
      window.status = 'COMPLETED';
      window.isReadOnlyMode = false;
      console.log(`[Maintenance] Platform restored to full read-write mode. Draining complete.`);
    }
  }
}
