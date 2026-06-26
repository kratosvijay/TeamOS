import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class ValidatorService {
  constructor(private prisma: PrismaService) {}

  async validateMetadata(applicationId: string, metadataJson: string) {
    const report = {
      isValid: true,
      errors: [] as string[],
      warnings: [] as string[],
    };

    try {
      const parsed = JSON.parse(metadataJson);
      
      // Basic validations
      if (!parsed.pages || !Array.isArray(parsed.pages)) {
        report.errors.push('Missing valid page pathways list in JSON.');
      } else {
        // Find orphaned routes or actions
        const routes = parsed.pages.map((p: any) => p.path);
        parsed.pages.forEach((p: any) => {
          if (p.components) {
            p.components.forEach((c: any) => {
              if (c.action && c.action.targetRoute && !routes.includes(c.action.targetRoute)) {
                report.warnings.push(`Orphaned action target route: ${c.action.targetRoute} on widget ${c.name}`);
              }
            });
          }
        });
      }

      if (report.errors.length > 0) {
        report.isValid = false;
      }
    } catch (e: any) {
      report.isValid = false;
      report.errors.push(`JSON structure parsing failed: ${e.message}`);
    }

    return report;
  }
}
