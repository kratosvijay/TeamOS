import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { MemoryHierarchyService } from './memory-hierarchy.service';
import { SemanticSearchService } from './semantic-search.service';

@Injectable()
export class ContextBuilderService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly memoryHierarchyService: MemoryHierarchyService,
    private readonly semanticSearchService: SemanticSearchService,
  ) {}

  async assembleContextPrompt(
    workspaceId: string,
    userId: string,
    conversationId: string,
    prompt: string,
    options: { department?: string; collectionId?: string } = {},
  ): Promise<string> {
    // 1. Fetch multi-level memory context
    const memories = await this.memoryHierarchyService.retrieveContextPipeline(
      workspaceId,
      userId,
      conversationId,
      prompt,
      options.department,
    );

    // 2. Fetch vector/semantic search resources
    const hybridSearchResults = await this.semanticSearchService.hybridSearch(
      workspaceId,
      prompt,
      options.collectionId,
    );

    // 3. Assemble prompt with bounded context
    let assembledContext = `--- SYSTEM CONTEXT ---\n`;
    assembledContext += `Workspace ID: ${workspaceId}\n`;
    if (options.department) {
      assembledContext += `Department: ${options.department}\n`;
    }

    assembledContext += `\n--- HIERARCHICAL MEMORY ---\n`;
    assembledContext += `Recent Conversation:\n${memories.conversation.join('\n')}\n`;
    assembledContext += `User Profile Context:\n${memories.user.join('\n')}\n`;
    assembledContext += `Workspace Summary:\n${memories.workspace.join('\n')}\n`;
    if (memories.department.length > 0) {
      assembledContext += `Department Knowledge:\n${memories.department.join('\n')}\n`;
    }

    assembledContext += `\n--- RETRIEVED SEMANTIC RESOURCES ---\n`;
    hybridSearchResults.slice(0, 3).forEach((hit, idx) => {
      assembledContext += `[Resource ${idx + 1}] ID: ${hit.id}, Type: ${hit.type}, Relevance Score: ${hit.score}\n`;
    });

    assembledContext += `\n--- USER PROMPT ---\n${prompt}`;

    return assembledContext;
  }
}
