import { Test, TestingModule } from '@nestjs/testing';
import { CliService } from '../cli.service';

describe('SdkGenerator', () => {
  let service: CliService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [CliService],
    }).compile();

    service = module.get<CliService>(CliService);
  });

  it('should auto generate TypeScript client SDK code', async () => {
    const openApiJson = { paths: { '/api/v1/tasks': { get: {} } } };
    const sdk = await service.generateSdk('TypeScript', openApiJson);

    expect(sdk.language).toBe('TypeScript');
    expect(sdk.code).toContain('TeamOSClient');
    expect(sdk.code).toContain('getTasks()');
  });

  it('should auto generate Flutter client SDK code', async () => {
    const openApiJson = { paths: { '/api/v1/tasks': { get: {} } } };
    const sdk = await service.generateSdk('Flutter', openApiJson);

    expect(sdk.language).toBe('Flutter');
    expect(sdk.code).toContain('TeamOSClient');
  });
});
