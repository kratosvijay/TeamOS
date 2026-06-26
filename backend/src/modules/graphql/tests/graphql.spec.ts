import { Test, TestingModule } from '@nestjs/testing';
import { GraphqlResolver } from '../graphql.resolver';

describe('GraphqlResolver', () => {
  let resolver: GraphqlResolver;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [GraphqlResolver],
    }).compile();

    resolver = module.get<GraphqlResolver>(GraphqlResolver);
  });

  it('should return hello message', async () => {
    expect(await resolver.hello()).toBe('Hello from TeamOS GraphQL Gateway!');
  });

  it('should return projects', async () => {
    const projects = await resolver.getProjects('ws-123');
    expect(projects).toContain('Project A');
    expect(projects[2]).toContain('ws-123');
  });

  it('should return tasks', async () => {
    const tasks = await resolver.getTasks('ws-123');
    expect(tasks).toContain('Task A');
  });
});
