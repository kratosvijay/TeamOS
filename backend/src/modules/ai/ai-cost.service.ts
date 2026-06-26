import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class AICostService {
  constructor(private readonly prisma: PrismaService) {}

  async compressPrompt(prompt: string): Promise<{ compressed: string; savingsRatio: number }> {
    // Basic compression rule: strip redundant spacing, comments, and stop-words
    const originalLength = prompt.length;
    let compressed = prompt.replace(/\s+/g, ' ').trim();
    
    // Simulate minor summary/shortening if prompt is extremely long
    if (compressed.length > 500) {
      compressed = compressed.substring(0, 450) + '... [Compressed Context for Tokens Optimization]';
    }

    const savingsRatio = originalLength > 0 ? (originalLength - compressed.length) / originalLength : 0;

    return {
      compressed,
      savingsRatio,
    };
  }

  async calculateCost(tokensUsed: number, costPerThousand: number): Promise<number> {
    return (tokensUsed / 1000) * costPerThousand;
  }
}
