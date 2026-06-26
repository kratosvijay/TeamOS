import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class MetadataDiffService {
  constructor(private prisma: PrismaService) {}

  compareMetadata(versionA: string, versionB: string) {
    let jsonA: any = {};
    let jsonB: any = {};

    try {
      jsonA = JSON.parse(versionA);
    } catch {}

    try {
      jsonB = JSON.parse(versionB);
    } catch {}

    const diffs = [] as { path: string; type: 'ADDED' | 'REMOVED' | 'MODIFIED'; before?: any; after?: any }[];

    // Simple key-value comparison
    const keysA = Object.keys(jsonA);
    const keysB = Object.keys(jsonB);

    for (const key of keysB) {
      if (!keysA.includes(key)) {
        diffs.push({ path: key, type: 'ADDED', after: jsonB[key] });
      } else if (JSON.stringify(jsonA[key]) !== JSON.stringify(jsonB[key])) {
        diffs.push({ path: key, type: 'MODIFIED', before: jsonA[key], after: jsonB[key] });
      }
    }

    for (const key of keysA) {
      if (!keysB.includes(key)) {
        diffs.push({ path: key, type: 'REMOVED', before: jsonA[key] });
      }
    }

    return {
      hasChanges: diffs.length > 0,
      diffs,
    };
  }
}
