import { Test, TestingModule } from '@nestjs/testing';
import { AIGateway } from '../ai.gateway';
import { AIService } from '../ai.service';
import { Socket } from 'socket.io';

describe('AIGateway', () => {
  let gateway: AIGateway;
  let service: AIService;

  const mockAIService = {
    executeChat: jest.fn(),
  };

  const mockSocket = {
    emit: jest.fn(),
    id: 'socket-id',
  } as unknown as Socket;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AIGateway,
        { provide: AIService, useValue: mockAIService },
      ],
    }).compile();

    gateway = module.get<AIGateway>(AIGateway);
    service = module.get<AIService>(AIService);
  });

  it('should be defined', () => {
    expect(gateway).toBeDefined();
  });

  it('should handle ai:chat event and emit streaming updates followed by complete block', async () => {
    mockAIService.executeChat.mockResolvedValue({
      messageId: 'msg-abc',
      content: 'Here is the response text',
      citations: [],
    });

    const payload = {
      workspaceId: 'w-1',
      userId: 'u-1',
      conversationId: 'c-1',
      message: 'Write a sprint plan',
    };

    jest.useFakeTimers();
    await gateway.handleAIChat(mockSocket, payload);

    // Initial state emitted immediately
    expect(mockSocket.emit).toHaveBeenCalledWith('ai:thinking', expect.any(Object));

    // Fast-forward simulator timers
    jest.advanceTimersByTime(3000);

    expect(mockSocket.emit).toHaveBeenCalledWith('ai:stream', expect.any(Object));
    expect(mockSocket.emit).toHaveBeenCalledWith('ai:complete', expect.any(Object));

    jest.useRealTimers();
  });
});
