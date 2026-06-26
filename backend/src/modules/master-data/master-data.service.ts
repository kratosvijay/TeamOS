import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class MasterDataService {
  constructor(private readonly prisma: PrismaService) {}

  async createMasterEntity(workspaceId: string, domainName: string, externalId: string, payload: any) {
    const payloadJson = JSON.stringify(payload);
    const entity = await this.prisma.masterEntity.create({
      data: {
        workspaceId,
        domainName,
        externalId,
        payloadJson,
      },
    });

    await this.prisma.masterEntityVersion.create({
      data: {
        workspaceId,
        masterEntityId: entity.id,
        version: 1,
        payloadJson,
      },
    });

    return entity;
  }

  async findDuplicates(workspaceId: string, domainName: string) {
    const entities = await this.prisma.masterEntity.findMany({
      where: { workspaceId, domainName },
    });

    const candidates = [];

    // Simple Jaccard similarity / mock duplicate checking logic
    for (let i = 0; i < entities.length; i++) {
      for (let j = i + 1; j < entities.length; j++) {
        const payloadA = JSON.parse(entities[i].payloadJson);
        const payloadB = JSON.parse(entities[j].payloadJson);

        // check if names are highly similar (mocking Levenshtein/Jaccard)
        if (payloadA.name && payloadB.name && payloadA.name.substring(0, 4) === payloadB.name.substring(0, 4)) {
          const confidence = 0.85;

          const duplicate = await this.prisma.duplicateCandidate.create({
            data: {
              workspaceId,
              domainName,
              entityIdA: entities[i].id,
              entityIdB: entities[j].id,
              confidenceScore: confidence,
              status: 'PENDING',
            },
          });
          candidates.push(duplicate);
        }
      }
    }

    return candidates;
  }

  async mergeEntities(workspaceId: string, duplicateId: string, goldenPayload: any) {
    const duplicate = await this.prisma.duplicateCandidate.findUnique({
      where: { id: duplicateId },
    });
    if (!duplicate) throw new Error('Duplicate candidate not found');

    const mergedPayload = JSON.stringify(goldenPayload);
    const sourceIds = JSON.stringify([duplicate.entityIdA, duplicate.entityIdB]);

    const goldenRecord = await this.prisma.goldenRecord.create({
      data: {
        workspaceId,
        domainName: duplicate.domainName,
        mergedPayload,
        sourceEntities: sourceIds,
      },
    });

    await this.prisma.duplicateCandidate.update({
      where: { id: duplicateId },
      data: { status: 'RESOLVED' },
    });

    await this.prisma.mergeOperation.create({
      data: {
        workspaceId,
        goldenRecordId: goldenRecord.id,
        rolledBack: false,
        auditLogJson: JSON.stringify({
          mergedAt: new Date(),
          sourceIds,
          action: 'MERGE',
        }),
      },
    });

    return goldenRecord;
  }
}
