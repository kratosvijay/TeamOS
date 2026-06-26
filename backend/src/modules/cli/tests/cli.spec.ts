import { Test, TestingModule } from '@nestjs/testing';
import { CliService } from '../cli.service';

describe('CliService', () => {
  let service: CliService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [CliService],
    }).compile();

    service = module.get<CliService>(CliService);
  });

  it('should authenticate user developer credentials', async () => {
    const login = await service.login('dev@teamos.com', 'https://teamos.com');
    expect(login.token).toBe('mock-session-jwt-token');
  });

  it('should run doctor diagnostics', async () => {
    const report = await service.runDoctor();
    expect(report.status).toBe('ALL_SYSTEMS_GO');
    expect(report.cliVersion).toBe('1.0.0');
  });

  it('should generate template structures', async () => {
    const gen = await service.generate('widget', 'SalesChart');
    expect(gen.status).toBe('SUCCESS');
    expect(gen.type).toBe('widget');
  });

  it('should create template apps', async () => {
    const app = await service.createApp('MyWidgetApp', './tmp/widget-app');
    expect(app.appName).toBe('MyWidgetApp');
  });
});
