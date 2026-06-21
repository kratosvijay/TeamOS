import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { TaskStatus } from '@prisma/client';
import * as PDFDocument from 'pdfkit';

@Injectable()
export class ReportingService {
  constructor(private prisma: PrismaService) {}

  async getSprintReport(sprintId: string) {
    const sprint = await this.prisma.sprint.findUnique({
      where: { id: sprintId },
      include: {
        project: true,
        tasks: {
          include: {
            assignee: true,
            activities: {
              where: { action: 'STATUS_CHANGE' },
              orderBy: { createdAt: 'asc' },
            },
          },
        },
      },
    });

    if (!sprint) {
      throw new NotFoundException('Sprint not found');
    }

    // 1. Calculate Velocity (Average of completed points of last 5 completed sprints)
    const completedSprints = await this.prisma.sprint.findMany({
      where: {
        projectId: sprint.projectId,
        isCompleted: true,
      },
      include: {
        tasks: {
          where: { status: TaskStatus.DONE },
        },
      },
      orderBy: { endDate: 'desc' },
      take: 5,
    });

    const velocities = completedSprints.map((s) =>
      s.tasks.reduce((sum, t) => sum + (t.storyPoints || 0), 0),
    );
    const averageVelocity =
      velocities.length > 0
        ? velocities.reduce((sum, v) => sum + v, 0) / velocities.length
        : 0;

    // 2. Burndown Calculations
    const totalPoints = sprint.tasks.reduce((sum, t) => sum + (t.storyPoints || 0), 0);
    const startDate = new Date(sprint.startDate);
    const endDate = new Date(sprint.endDate);
    const totalDays = Math.max(
      1,
      Math.ceil((endDate.getTime() - startDate.getTime()) / (1000 * 60 * 60 * 24)),
    );

    const burndownData = [];
    const today = new Date();

    for (let i = 0; i <= totalDays; i++) {
      const currentDate = new Date(startDate.getTime() + i * 24 * 60 * 60 * 1000);
      if (currentDate > today && currentDate > endDate) break;

      // Find tasks completed on or before this day
      const completedPoints = sprint.tasks
        .filter((task) => {
          if (task.status !== TaskStatus.DONE) return false;
          // Find when it was moved to DONE
          const doneActivity = task.activities.find(
            (a) => a.newValue === TaskStatus.DONE,
          );
          const completionDate = doneActivity ? new Date(doneActivity.createdAt) : new Date(task.updatedAt);
          return completionDate <= currentDate;
        })
        .reduce((sum, t) => sum + (t.storyPoints || 0), 0);

      const actualRemaining = Math.max(0, totalPoints - completedPoints);
      const idealRemaining = Math.max(0, totalPoints - (totalPoints / totalDays) * i);

      burndownData.push({
        day: i,
        date: currentDate.toISOString().split('T')[0],
        actualRemaining,
        idealRemaining,
      });
    }

    // 3. Backlog Health Metrics
    const unestimatedTasks = sprint.tasks.filter((t) => t.storyPoints === null).length;
    const unassignedTasks = sprint.tasks.filter((t) => t.assigneeId === null).length;
    const criticalTasks = sprint.tasks.filter((t) => t.priority === 'CRITICAL').length;
    const highTasks = sprint.tasks.filter((t) => t.priority === 'HIGH').length;

    const backlogHealth = {
      totalTasks: sprint.tasks.length,
      unestimatedTasks,
      unassignedTasks,
      criticalTasks,
      highTasks,
    };

    // 4. Capacity Planning
    const capacityByAssignee: Record<
      string,
      { assigneeName: string; storyPoints: number; estimatedHours: number; loggedHours: number }
    > = {};

    sprint.tasks.forEach((task) => {
      const assigneeId = task.assigneeId || 'Unassigned';
      const assigneeName = task.assignee ? task.assignee.fullName : 'Unassigned';

      if (!capacityByAssignee[assigneeId]) {
        capacityByAssignee[assigneeId] = {
          assigneeName,
          storyPoints: 0,
          estimatedHours: 0,
          loggedHours: 0,
        };
      }

      capacityByAssignee[assigneeId].storyPoints += task.storyPoints || 0;
      capacityByAssignee[assigneeId].estimatedHours += task.estimatedHours || 0;
      capacityByAssignee[assigneeId].loggedHours += task.loggedHours || 0;
    });

    return {
      sprintId: sprint.id,
      sprintName: sprint.name,
      projectName: sprint.project.name,
      averageVelocity,
      totalStoryPoints: totalPoints,
      burndownData,
      backlogHealth,
      capacityPlanning: Object.values(capacityByAssignee),
    };
  }

  async exportSprintCsv(sprintId: string): Promise<string> {
    const report = await this.getSprintReport(sprintId);

    let csvContent = 'Sprint Report: ' + report.sprintName + '\n';
    csvContent += 'Project: ' + report.projectName + '\n';
    csvContent += 'Average Velocity: ' + report.averageVelocity + ' SP\n';
    csvContent += 'Total Story Points: ' + report.totalStoryPoints + ' SP\n\n';

    csvContent += '--- BURNDOWN DATA ---\n';
    csvContent += 'Day,Date,Actual Remaining SP,Ideal Remaining SP\n';
    report.burndownData.forEach((row) => {
      csvContent += `${row.day},${row.date},${row.actualRemaining},${row.idealRemaining.toFixed(2)}\n`;
    });

    csvContent += '\n--- BACKLOG HEALTH ---\n';
    csvContent += `Metric,Value\n`;
    csvContent += `Total Tasks,${report.backlogHealth.totalTasks}\n`;
    csvContent += `Unestimated Tasks,${report.backlogHealth.unestimatedTasks}\n`;
    csvContent += `Unassigned Tasks,${report.backlogHealth.unassignedTasks}\n`;
    csvContent += `Critical Tasks,${report.backlogHealth.criticalTasks}\n`;
    csvContent += `High Priority Tasks,${report.backlogHealth.highTasks}\n`;

    csvContent += '\n--- CAPACITY PLANNING ---\n';
    csvContent += 'Assignee,Assigned Story Points,Estimated Hours,Logged Hours\n';
    report.capacityPlanning.forEach((c) => {
      csvContent += `"${c.assigneeName}",${c.storyPoints},${c.estimatedHours},${c.loggedHours}\n`;
    });

    return csvContent;
  }

  async exportSprintPdf(sprintId: string): Promise<Buffer> {
    const report = await this.getSprintReport(sprintId);

    return new Promise<Buffer>((resolve, reject) => {
      const doc = new PDFDocument({ margin: 50 });
      const chunks: Buffer[] = [];

      doc.on('data', (chunk) => chunks.push(chunk));
      doc.on('end', () => resolve(Buffer.concat(chunks)));
      doc.on('error', (err) => reject(err));

      // Header Banner
      doc.rect(0, 0, doc.page.width, 80).fill('#0F172A');
      doc.fillColor('#FFFFFF').fontSize(22).text('TeamOS Sprint Report', 50, 28, { align: 'left' });

      // Title Section
      doc.fillColor('#1E293B').fontSize(14).text(`Project: ${report.projectName}`, 50, 100);
      doc.text(`Sprint Name: ${report.sprintName}`, 50, 120);
      doc.text(`Generated At: ${new Date().toLocaleDateString()}`, 50, 140);

      // Key Metrics
      doc.rect(50, 170, 240, 60).fill('#F1F5F9');
      doc.rect(310, 170, 240, 60).fill('#F1F5F9');

      doc.fillColor('#475569').fontSize(10).text('AVERAGE VELOCITY', 60, 180);
      doc.fillColor('#0F172A').fontSize(18).text(`${report.averageVelocity.toFixed(1)} SP`, 60, 195);

      doc.fillColor('#475569').fontSize(10).text('TOTAL PLANNED STORY POINTS', 320, 180);
      doc.fillColor('#0F172A').fontSize(18).text(`${report.totalStoryPoints} SP`, 320, 195);

      // Backlog Health Table
      doc.fillColor('#0F172A').fontSize(14).text('Backlog Health Summary', 50, 260);
      doc.moveTo(50, 280).lineTo(550, 280).stroke('#CBD5E1');

      let y = 295;
      const drawHealthRow = (label: string, val: number) => {
        doc.fillColor('#334155').fontSize(10).text(label, 60, y);
        doc.fillColor('#0F172A').text(val.toString(), 450, y, { align: 'right', width: 90 });
        doc.moveTo(50, y + 15).lineTo(550, y + 15).stroke('#F1F5F9');
        y += 20;
      };

      drawHealthRow('Total Tasks in Sprint', report.backlogHealth.totalTasks);
      drawHealthRow('Unestimated Tasks', report.backlogHealth.unestimatedTasks);
      drawHealthRow('Unassigned Tasks', report.backlogHealth.unassignedTasks);
      drawHealthRow('Critical Priority Tasks', report.backlogHealth.criticalTasks);
      drawHealthRow('High Priority Tasks', report.backlogHealth.highTasks);

      // Capacity Planning Table
      doc.addPage();
      doc.rect(0, 0, doc.page.width, 40).fill('#0F172A');
      doc.fillColor('#FFFFFF').fontSize(14).text('Sprint Capacity & Logs', 50, 13);

      doc.fillColor('#475569').fontSize(10).text('Assignee', 50, 70);
      doc.text('Story Points', 200, 70, { align: 'right', width: 90 });
      doc.text('Est. Hours', 310, 70, { align: 'right', width: 90 });
      doc.text('Logged Hours', 420, 70, { align: 'right', width: 90 });
      doc.moveTo(50, 85).lineTo(550, 85).stroke('#CBD5E1');

      y = 95;
      report.capacityPlanning.forEach((c) => {
        doc.fillColor('#0F172A').fontSize(10).text(c.assigneeName, 50, y);
        doc.text(c.storyPoints.toString(), 200, y, { align: 'right', width: 90 });
        doc.text(c.estimatedHours.toFixed(1), 310, y, { align: 'right', width: 90 });
        doc.text(c.loggedHours.toFixed(1), 420, y, { align: 'right', width: 90 });
        doc.moveTo(50, y + 15).lineTo(550, y + 15).stroke('#F1F5F9');
        y += 20;
      });

      doc.end();
    });
  }
}
