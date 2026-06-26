import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class MetadataGitService {
  constructor(private prisma: PrismaService) {}

  async createBranch(workspaceId: string, applicationId: string, name: string, baseCommitId?: string) {
    return this.prisma.metadataBranch.create({
      data: { workspaceId, applicationId, name, lastCommitId: baseCommitId },
    });
  }

  async commit(workspaceId: string, applicationId: string, branchId: string, author: string, message: string, snapshotJson: string) {
    const commitRecord = await this.prisma.metadataCommit.create({
      data: {
        workspaceId,
        applicationId,
        branchId,
        author,
        commitMessage: message,
        snapshotJson,
      },
    });

    await this.prisma.metadataBranch.update({
      where: { id: branchId },
      data: { lastCommitId: commitRecord.id },
    });

    return commitRecord;
  }

  async mergeBranches(workspaceId: string, applicationId: string, sourceBranchId: string, targetBranchId: string, author: string) {
    const [sourceBranch, targetBranch] = await Promise.all([
      this.prisma.metadataBranch.findUnique({ where: { id: sourceBranchId } }),
      this.prisma.metadataBranch.findUnique({ where: { id: targetBranchId } }),
    ]);

    if (!sourceBranch || !targetBranch) throw new Error('Branches not found');

    const sourceCommit = await this.prisma.metadataCommit.findUnique({
      where: { id: sourceBranch.lastCommitId || '' },
    });
    const targetCommit = await this.prisma.metadataCommit.findUnique({
      where: { id: targetBranch.lastCommitId || '' },
    });

    if (!sourceCommit) throw new Error('Source branch has no commits');

    // Simulate merge logic: if targetCommit exists and differs, check for conflicts
    let finalSnapshot = sourceCommit.snapshotJson;
    let hasConflict = false;

    if (targetCommit && targetCommit.snapshotJson !== sourceCommit.snapshotJson) {
      hasConflict = true; // Simple merge simulation flags conflict
      await this.prisma.metadataMergeConflict.create({
        data: {
          workspaceId,
          applicationId,
          sourceBranch: sourceBranch.name,
          targetBranch: targetBranch.name,
          conflictJson: JSON.stringify({
            message: 'Conflict detected on root application config payload.',
            sourceValue: sourceCommit.snapshotJson,
            targetValue: targetCommit.snapshotJson,
          }),
          status: 'OPEN',
        },
      });
    }

    if (hasConflict) {
      throw new Error('Merge conflict detected. Please resolve conflicts before continuing.');
    }

    // Otherwise merge clean
    return this.commit(
      workspaceId,
      applicationId,
      targetBranchId,
      author,
      `Merged branch ${sourceBranch.name} into ${targetBranch.name}`,
      finalSnapshot,
    );
  }
}
