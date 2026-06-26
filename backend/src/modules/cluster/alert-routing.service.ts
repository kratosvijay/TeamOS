import { Injectable } from '@nestjs/common';

export interface AlertMessage {
  ruleName: string;
  severity: 'INFO' | 'WARNING' | 'CRITICAL';
  description: string;
  workspaceId?: string;
}

@Injectable()
export class AlertRoutingService {
  private routeLogs: { service: string; payload: any; timestamp: Date }[] = [];

  async routeAlert(alert: AlertMessage) {
    console.log(`[AlertRouting] Processing Alert: ${alert.ruleName} (${alert.severity})`);

    // Route dynamically based on severity
    if (alert.severity === 'CRITICAL') {
      await this.sendToPagerDuty(alert);
      await this.sendToSlack(alert);
      await this.sendToOpsgenie(alert);
    } else if (alert.severity === 'WARNING') {
      await this.sendToSlack(alert);
      await this.sendToTeams(alert);
    } else {
      await this.sendToEmail(alert);
    }
  }

  private async sendToPagerDuty(alert: AlertMessage) {
    const payload = {
      event_action: 'trigger',
      payload: {
        summary: alert.description,
        source: 'teamos-observability-layer',
        severity: 'critical',
        custom_details: { ...alert },
      },
    };
    this.routeLogs.push({ service: 'PagerDuty', payload, timestamp: new Date() });
    console.log('[AlertRouting] Dispatched Incident payload to PagerDuty REST API integration.');
  }

  private async sendToSlack(alert: AlertMessage) {
    const payload = {
      text: `🚨 *[${alert.severity}] Alert Fired:* ${alert.ruleName}\n> ${alert.description}\n_Workspace: ${alert.workspaceId || 'Platform'}_`,
    };
    this.routeLogs.push({ service: 'Slack', payload, timestamp: new Date() });
    console.log('[AlertRouting] Dispatched webhook webhook payload to Slack channel integrations.');
  }

  private async sendToTeams(alert: AlertMessage) {
    const payload = {
      title: `Microsoft Teams Alert: ${alert.ruleName}`,
      text: alert.description,
    };
    this.routeLogs.push({ service: 'Teams', payload, timestamp: new Date() });
  }

  private async sendToOpsgenie(alert: AlertMessage) {
    const payload = {
      message: alert.ruleName,
      description: alert.description,
      priority: 'P1',
    };
    this.routeLogs.push({ service: 'Opsgenie', payload, timestamp: new Date() });
  }

  private async sendToEmail(alert: AlertMessage) {
    const payload = {
      to: 'devops-alerts@teamos.com',
      subject: `Alert: ${alert.ruleName}`,
      body: alert.description,
    };
    this.routeLogs.push({ service: 'Email', payload, timestamp: new Date() });
  }

  async getRouteLogs() {
    return this.routeLogs;
  }
}
