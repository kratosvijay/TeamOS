import { Injectable, OnModuleInit } from '@nestjs/common';
import OpenAI from 'openai';

@Injectable()
export class AIService implements OnModuleInit {
  private openai: OpenAI;

  async onModuleInit() {
    this.openai = new OpenAI({
      apiKey: process.env.OPENAI_API_KEY || 'mock-key',
    });
  }

  async generateSummary(text: string): Promise<string> {
    try {
      const response = await this.openai.chat.completions.create({
        model: 'gpt-4-turbo',
        messages: [
          {
            role: 'system',
            content: 'You are a senior team assistant. Summarize the following meeting transcript. Provide action items, key decisions, and high-level summaries.',
          },
          {
            role: 'user',
            content: text,
          },
        ],
      });
      return response.choices[0].message.content;
    } catch (e) {
      console.error('OpenAI: Summary generation failed. Falling back to mockup.', e);
      return `[Mock AI Summary] The meeting discussed sprint boundaries and architectural designs. Action items: 1. Deploy LiveKit Cloud, 2. Build Yjs Socket gateway.`;
    }
  }

  async generateTasks(goal: string): Promise<any[]> {
    try {
      const response = await this.openai.chat.completions.create({
        model: 'gpt-4-turbo',
        response_format: { type: 'json_object' },
        messages: [
          {
            role: 'system',
            content: 'You are a project architect. Generate a list of subtasks for this sprint goal. Return valid JSON containing an array of tasks with key: "tasks", each task having "title", "description", and "priority".',
          },
          {
            role: 'user',
            content: goal,
          },
        ],
      });
      const parsed = JSON.parse(response.choices[0].message.content);
      return parsed.tasks || [];
    } catch (e) {
      console.error('OpenAI: Task generation failed', e);
      return [
        { title: 'Setup project workspace', description: 'Initialize directories and setup configs', priority: 'HIGH' },
        { title: 'Configure Database Schema', description: 'Run prisma migrations', priority: 'HIGH' },
      ];
    }
  }
}
