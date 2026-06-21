import { Test, TestingModule } from '@nestjs/testing';
import { GoogleService } from '../google.service';
import { OAuthService } from '../../oauth/oauth.service';
import { PrismaService } from '../../prisma/prisma.service';

describe('GoogleService', () => {
  let service: GoogleService;
  let oauth: OAuthService;
  let prisma: PrismaService;

  const mockOAuth = {
    connectProvider: jest.fn(),
    getCredentials: jest.fn(),
  };

  const mockPrisma = {
    meeting: {
      upsert: jest.fn(),
    },
    document: {
      create: jest.fn(),
    },
    documentContent: {
      create: jest.fn(),
    },
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        GoogleService,
        { provide: OAuthService, useValue: mockOAuth },
        { provide: PrismaService, useValue: mockPrisma },
      ],
    }).compile();

    service = module.get<GoogleService>(GoogleService);
    oauth = module.get<OAuthService>(OAuthService);
    prisma = module.get<PrismaService>(PrismaService);
  });

  it('should sync calendar events successfully', async () => {
    mockOAuth.getCredentials.mockResolvedValue({ accessToken: 'google_token' });
    mockPrisma.meeting.upsert.mockResolvedValue({});

    const result = await service.syncCalendarEvents('workspace-1');
    expect(result.success).toBe(true);
    expect(result.syncedEventsCount).toBe(2);
    expect(mockPrisma.meeting.upsert).toHaveBeenCalled();
  });

  it('should import Google Doc as a TeamOS Wiki page', async () => {
    mockOAuth.getCredentials.mockResolvedValue({ accessToken: 'google_token' });
    mockPrisma.document.create.mockResolvedValue({ id: 'doc-1', title: 'Sprint Review' });
    mockPrisma.documentContent.create.mockResolvedValue({});

    const doc = await service.importGoogleDoc('workspace-1', 'user-1', 'g-doc-id-100', 'Sprint Review');
    expect(doc.id).toBe('doc-1');
    expect(mockPrisma.document.create).toHaveBeenCalled();
    expect(mockPrisma.documentContent.create).toHaveBeenCalled();
  });
});
