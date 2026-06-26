import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class PreviewSandboxService {
  constructor(private prisma: PrismaService) {}

  async renderPreviewLayout(workspaceId: string, applicationId: string, tempLayoutSchema: string) {
    // Validate schema safety first
    try {
      const parsed = JSON.parse(tempLayoutSchema);
      if (!parsed.pages) {
        throw new Error('Missing page layouts key.');
      }
    } catch (e: any) {
      throw new Error(`Preview sandboxing failed verification: ${e.message}`);
    }

    return {
      sandboxId: `sb-${Math.random().toString(36).substring(2, 10)}`,
      status: 'VERIFIED_SAFE',
      renderedHtml: `<div class="eap-preview-frame">Dynamic layout frame verified for App ${applicationId}</div>`,
    };
  }
}
