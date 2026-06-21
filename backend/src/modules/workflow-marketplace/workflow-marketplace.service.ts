import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class WorkflowMarketplaceService {
  private readonly mockTemplates = [
    {
      name: 'Employee Onboarding Flow',
      category: 'HR',
      definition: {
        nodes: [
          { id: 'start', type: 'TRIGGER', name: 'New Employee Profile Created', config: { event: 'Task Created' } },
          { id: 'notify-it', type: 'ACTION', name: 'Provision Email & Laptop Accounts', config: {} },
          { id: 'manager-approve', type: 'APPROVAL', name: 'Department Head Welcome Signoff', config: { approverId: 'manager-1' } },
          { id: 'slack-announce', type: 'NOTIFICATION', name: 'Announce on Slack #general', config: {} },
        ],
        edges: [
          { source: 'start', target: 'notify-it' },
          { source: 'notify-it', target: 'manager-approve' },
          { source: 'manager-approve', target: 'slack-announce' },
        ],
      },
    },
    {
      name: 'Leave Request Automation',
      category: 'HR',
      definition: {
        nodes: [
          { id: 'trigger-form', type: 'TRIGGER', name: 'Leave Submission Form Submitter', config: { event: 'Form Submitted' } },
          { id: 'check-days', type: 'CONDITION', name: 'Check if leave days > 3', config: { field: 'days', operator: '>', value: '3' } },
          { id: 'hr-approval', type: 'APPROVAL', name: 'HR approval verification', config: { approverId: 'hr-lead' } },
          { id: 'manager-approval', type: 'APPROVAL', name: 'Direct supervisor signoff', config: { approverId: 'manager-1' } },
          { id: 'notify-outcome', type: 'NOTIFICATION', name: 'Deliver confirmation email', config: {} },
        ],
        edges: [
          { source: 'trigger-form', target: 'check-days' },
          { source: 'check-days', target: 'hr-approval', sourceHandle: 'true' },
          { source: 'check-days', target: 'manager-approval', sourceHandle: 'false' },
          { source: 'hr-approval', target: 'notify-outcome' },
          { source: 'manager-approval', target: 'notify-outcome' },
        ],
      },
    },
    {
      name: 'Procurement & CAPEX Approval',
      category: 'Finance',
      definition: {
        nodes: [
          { id: 'req', type: 'TRIGGER', name: 'Expense Request form submission', config: { event: 'Form Submitted' } },
          { id: 'budget-check', type: 'CONDITION', name: 'Check if expense > $100,000', config: { field: 'amount', operator: '>', value: '100000' } },
          { id: 'cfo-signoff', type: 'APPROVAL', name: 'CFO review validation', config: { approverId: 'cfo-1' } },
          { id: 'manager-signoff', type: 'APPROVAL', name: 'Direct manager validation', config: { approverId: 'manager-1' } },
          { id: 'complete-transfer', type: 'ACTION', name: 'Log bank transaction transfer', config: {} },
        ],
        edges: [
          { source: 'req', target: 'budget-check' },
          { source: 'budget-check', target: 'cfo-signoff', sourceHandle: 'true' },
          { source: 'budget-check', target: 'manager-signoff', sourceHandle: 'false' },
          { source: 'cfo-signoff', target: 'complete-transfer' },
          { source: 'manager-signoff', target: 'complete-transfer' },
        ],
      },
    },
    {
      name: 'Incident Response SOP',
      category: 'Security',
      definition: {
        nodes: [
          { id: 'incident', type: 'TRIGGER', name: 'Critical incident alert matching', config: { event: 'Security Incident' } },
          { id: 'ai-triage', type: 'AI_ACTION', name: 'AI summarize incident events', config: {} },
          { id: 'notify-sec', type: 'NOTIFICATION', name: 'Notify Security On-Call duty pager', config: {} },
        ],
        edges: [
          { source: 'incident', target: 'ai-triage' },
          { source: 'ai-triage', target: 'notify-sec' },
        ],
      },
    },
  ];

  constructor(private prisma: PrismaService) {}

  async listTemplates() {
    return this.mockTemplates;
  }

  async installTemplate(workspaceId: string, createdBy: string, templateName: string) {
    const template = this.mockTemplates.find((t) => t.name === templateName);
    if (!template) {
      throw new Error(`Template "${templateName}" not found in marketplace`);
    }

    return this.prisma.workflow.create({
      data: {
        workspaceId,
        name: template.name,
        description: `Marketplace installed template for ${template.category}`,
        status: 'DRAFT',
        definition: template.definition,
        createdBy,
      },
    });
  }
}
