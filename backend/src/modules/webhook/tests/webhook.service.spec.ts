import { Test, TestingModule } from '@nestjs/testing';
import { WebhookService } from '../webhook.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('WebhookService', () => {
  let service: WebhookService;
  let prisma: PrismaService;

  const mockPrisma = {
    webhook: {
      create: jest.fn(),
      findUnique: jest.fn(),
    },
    webhookDelivery: {
      create: jest.fn(),
      findMany: jest.fn(),
    },
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        WebhookService,
        { provide: PrismaService, useValue: mockPrisma },
      ],
    }).compile();

    service = module.get<WebhookService>(WebhookService);
    prisma = module.get<PrismaService>(PrismaService);
  });

  it('should validate signatures correctly', () => {
    const secret = 'super-secret-key';
    const payload = JSON.stringify({ event: 'ping' });
    const crypto = require('crypto');
    const signature = crypto.createHmac('sha256', secret).update(payload).digest('hex');

    const isValid = service.validateSignature(payload, signature, secret);
    expect(isValid).toBe(true);
  });

  it('should identify replay duplicate events', () => {
    const eventId = 'evt-unique-123';
    expect(service.isDuplicateEvent(eventId)).toBe(false);
    expect(service.isDuplicateEvent(eventId)).toBe(true); // second call is duplicate
  });

  it('should log webhook delivery attempts', async () => {
    mockPrisma.webhook.findUnique.mockResolvedValue({
      id: 'webhook-1',
      url: 'http://localhost/callback',
      secret: 'secret',
      status: 'ACTIVE',
    });

    await service.deliverWebhook('webhook-1', 'task.created', { id: 'task-1' });
    expect(mockPrisma.webhookDelivery.create).toHaveBeenCalledWith(
      expect.objectContaining({
        data: expect.objectContaining({
          webhookId: 'webhook-1',
          attempts: 1,
          responseStatus: 200,
        }),
      }),
    );
  });
});
