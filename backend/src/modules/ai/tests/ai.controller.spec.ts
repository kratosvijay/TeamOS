import { Test, TestingModule } from '@nestjs/testing';
import { AIController } from '../ai.controller';
import { AIService } from '../ai.service';
import { JwtStrategy } from '../../auth/jwt.strategy';
import { PrismaService } from '../../prisma/prisma.service';

describe('AIController', () => {
  let controller: AIController;
  let service: AIService;

  const mockAIService = {
    executeChat: jest.fn(),
    hybridSearch: jest.fn(),
    generateTasks: jest.fn(),
    calculateRiskEngine: jest.fn(),
  };

  // Mock workspace guards requirements
  const mockJwtStrategy = {
    validateToken: jest.fn(),
  };
  const mockPrismaService = {
    workspaceMember: {
      findUnique: jest.fn(),
    },
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [AIController],
      providers: [
        { provide: AIService, useValue: mockAIService },
        { provide: JwtStrategy, useValue: mockJwtStrategy },
        { provide: PrismaService, useValue: mockPrismaService },
      ],
    }).compile();

    controller = module.get<AIController>(AIController);
    service = module.get<AIService>(AIService);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });

  it('should call executeChat service endpoint', async () => {
    mockAIService.executeChat.mockResolvedValue({
      messageId: 'msg-abc',
      content: 'AI Response',
    });

    const body = { conversationId: 'c-1', message: 'Hello AI' };
    const req = { user: { id: 'u-1' } };

    const result = await controller.executeChat('w-1', body, req);
    expect(service.executeChat).toHaveBeenCalledWith('w-1', 'u-1', 'c-1', 'Hello AI', undefined);
    expect(result.content).toBe('AI Response');
  });

  it('should execute hybridSearch on search query post', async () => {
    mockAIService.hybridSearch.mockResolvedValue([]);
    await controller.executeSearch('w-1', { query: 'test search' });
    expect(service.hybridSearch).toHaveBeenCalledWith('w-1', 'test search');
  });
});
