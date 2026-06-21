import { Test, TestingModule } from '@nestjs/testing';
import { FormsService } from '../forms.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('FormsService', () => {
  let service: FormsService;
  let prisma: PrismaService;

  const mockPrismaService = {
    dynamicForm: {
      create: jest.fn(),
      findMany: jest.fn(),
      findUnique: jest.fn(),
    },
    formSubmission: {
      create: jest.fn(),
      findMany: jest.fn(),
    },
    workflow: {
      findMany: jest.fn(),
    },
    workflowExecution: {
      create: jest.fn(),
    },
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        FormsService,
        { provide: PrismaService, useValue: mockPrismaService },
      ],
    }).compile();

    service = module.get<FormsService>(FormsService);
    prisma = module.get<PrismaService>(PrismaService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should create dynamic forms with validation schemas', async () => {
    mockPrismaService.dynamicForm.create.mockResolvedValue({ id: 'f-1', name: 'Leave Application' });

    const result = await service.createForm('ws-1', 'user-1', { name: 'Leave Application', schema: {} });
    expect(result.name).toBe('Leave Application');
    expect(mockPrismaService.dynamicForm.create).toHaveBeenCalled();
  });

  it('should accept form submissions and trigger active workflows', async () => {
    mockPrismaService.dynamicForm.findUnique.mockResolvedValue({ id: 'f-1' });
    mockPrismaService.formSubmission.create.mockResolvedValue({ id: 'sub-1', payload: { days: 4 } });
    mockPrismaService.workflow.findMany.mockResolvedValue([
      {
        id: 'w-1',
        status: 'ACTIVE',
        definition: {
          nodes: [
            { id: 'start', type: 'TRIGGER', config: { event: 'Form Submitted', formId: 'f-1' } },
          ],
        },
      },
    ]);

    const result = await service.submitForm('f-1', 'user-1', { days: 4 });
    expect(result.id).toBe('sub-1');
    expect(mockPrismaService.workflowExecution.create).toHaveBeenCalledWith({
      data: expect.objectContaining({
        workflowId: 'w-1',
        triggerEvent: 'Form Submitted',
      }),
    });
  });
});
