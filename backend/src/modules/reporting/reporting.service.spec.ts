import { Test, TestingModule } from '@nestjs/testing';
import { ReportingService } from './reporting.service';
import { PrismaService } from '../prisma/prisma.service';
import { TaskStatus } from '@prisma/client';

describe('ReportingService', () => {
  let service: ReportingService;
  let prisma: PrismaService;

  const mockSprintData = {
    id: 'sprint-1',
    name: 'Sprint 1',
    startDate: new Date('2026-06-01T00:00:00Z'),
    endDate: new Date('2026-06-15T00:00:00Z'),
    projectId: 'proj-1',
    project: {
      name: 'TeamOS',
    },
    tasks: [
      {
        id: 'task-1',
        title: 'Task 1',
        description: 'First task',
        storyPoints: 5,
        status: TaskStatus.DONE,
        updatedAt: new Date('2026-06-03T10:00:00Z'),
        assigneeId: 'user-1',
        assignee: {
          fullName: 'John Doe',
        },
        activities: [
          {
            action: 'STATUS_CHANGE',
            oldValue: 'TODO',
            newValue: 'DONE',
            createdAt: new Date('2026-06-03T10:00:00Z'),
          },
        ],
      },
      {
        id: 'task-2',
        title: 'Task 2',
        description: 'Second task',
        storyPoints: 3,
        status: TaskStatus.IN_PROGRESS,
        updatedAt: new Date('2026-06-05T12:00:00Z'),
        assigneeId: 'user-2',
        assignee: {
          fullName: 'Sarah Jenkins',
        },
        activities: [],
      },
    ],
  };

  const mockPrismaService = {
    sprint: {
      findUnique: jest.fn().mockResolvedValue(mockSprintData),
      findMany: jest.fn().mockResolvedValue([
        {
          id: 'prev-sprint-1',
          name: 'Sprint 0',
          endDate: new Date('2026-05-30T00:00:00Z'),
          tasks: [
            { id: 'prev-t1', storyPoints: 8, status: TaskStatus.DONE },
            { id: 'prev-t2', storyPoints: 5, status: TaskStatus.DONE },
          ],
        },
      ]),
    },
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ReportingService,
        { provide: PrismaService, useValue: mockPrismaService },
      ],
    }).compile();

    service = module.get<ReportingService>(ReportingService);
    prisma = module.get<PrismaService>(PrismaService);
  });

  it('should compile sprint analytics correctly', async () => {
    const report = await service.getSprintReport('sprint-1');

    expect(report.sprintId).toBe('sprint-1');
    expect(report.sprintName).toBe('Sprint 1');
    expect(report.projectName).toBe('TeamOS');
    expect(report.totalStoryPoints).toBe(8); // 5 + 3

    // Velocity should be average of previous completed sprints completed points (13 SP)
    expect(report.averageVelocity).toBe(13);

    // Backlog health assertions
    expect(report.backlogHealth.totalTasks).toBe(2);
    expect(report.backlogHealth.unestimatedTasks).toBe(0);

    // Capacity planning assertions
    expect(report.capacityPlanning).toHaveLength(2);
    const johnLoad = report.capacityPlanning.find((c) => c.assigneeName === 'John Doe');
    expect(johnLoad?.storyPoints).toBe(5);
  });
});
