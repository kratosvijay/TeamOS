import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class FormsService {
  constructor(private prisma: PrismaService) {}

  async createForm(workspaceId: string, createdBy: string, data: { name: string; schema: any }) {
    return this.prisma.dynamicForm.create({
      data: {
        workspaceId,
        name: data.name,
        schema: data.schema || {},
        createdBy,
      },
    });
  }

  async getForms(workspaceId: string) {
    return this.prisma.dynamicForm.findMany({
      where: { workspaceId },
      orderBy: { createdAt: 'desc' },
    });
  }

  async getFormById(id: string) {
    const form = await this.prisma.dynamicForm.findUnique({
      where: { id },
    });
    if (!form) {
      throw new NotFoundException(`Dynamic Form with ID ${id} not found`);
    }
    return form;
  }

  async submitForm(formId: string, submittedBy: string, payload: any) {
    await this.getFormById(formId);
    const submission = await this.prisma.formSubmission.create({
      data: {
        formId,
        submittedBy,
        payload: payload || {},
      },
    });

    // Optionally trigger a workflow execution for "Form Submitted" if a workflow has a TRIGGER on form submission
    const matchingWorkflows = await this.prisma.workflow.findMany({
      where: {
        status: 'ACTIVE',
      },
    });

    for (const workflow of matchingWorkflows) {
      const definition = workflow.definition as any;
      const nodes = definition.nodes || [];
      const hasFormTrigger = nodes.some(
        (n: any) =>
          n.type === 'TRIGGER' &&
          n.config?.event === 'Form Submitted' &&
          n.config?.formId === formId,
      );

      if (hasFormTrigger) {
        // Trigger workflow execution
        await this.prisma.workflowExecution.create({
          data: {
            workflowId: workflow.id,
            status: 'RUNNING',
            triggerEvent: 'Form Submitted',
            inputData: { submissionId: submission.id, payload },
          },
        });
      }
    }

    return submission;
  }

  async getSubmissions(formId: string) {
    await this.getFormById(formId);
    return this.prisma.formSubmission.findMany({
      where: { formId },
      orderBy: { createdAt: 'desc' },
    });
  }
}
