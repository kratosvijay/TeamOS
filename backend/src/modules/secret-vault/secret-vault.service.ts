import { Injectable } from '@nestjs/common';
import * as crypto from 'crypto';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class SecretVaultService {
  private readonly algorithm = 'aes-256-cbc';
  private readonly key: Buffer;

  constructor(private readonly prisma: PrismaService) {
    const secretKey = process.env.ENCRYPTION_KEY || 'e5b721245a498b31a029d5b78d2b6cd5';
    this.key = Buffer.from(secretKey.padEnd(32, '0').substring(0, 32), 'utf-8');
  }

  encrypt(text: string): string {
    if (!text) return '';
    const iv = crypto.randomBytes(16);
    const cipher = crypto.createCipheriv(this.algorithm, this.key, iv);
    let encrypted = cipher.update(text, 'utf8', 'hex');
    encrypted += cipher.final('hex');
    return `${iv.toString('hex')}:${encrypted}`;
  }

  decrypt(encryptedText: string): string {
    if (!encryptedText) return '';
    try {
      const parts = encryptedText.split(':');
      if (parts.length !== 2) {
        throw new Error('Invalid encrypted format');
      }
      const iv = Buffer.from(parts[0], 'hex');
      const encrypted = parts[1];
      const decipher = crypto.createDecipheriv(this.algorithm, this.key, iv);
      let decrypted = decipher.update(encrypted, 'hex', 'utf8');
      decrypted += decipher.final('utf8');
      return decrypted;
    } catch (e) {
      throw new Error(`Decryption failed: ${e.message}`);
    }
  }

  maskSecret(secret: string): string {
    if (!secret) return '';
    if (secret.length <= 8) {
      return '****';
    }
    return `${secret.substring(0, 4)}****${secret.substring(secret.length - 4)}`;
  }

  async auditAccess(workspaceId: string, actorId: string, action: string, resource: string) {
    await this.prisma.auditTrail.create({
      data: {
        workspaceId,
        actorId,
        action,
        entityType: 'SECRET_VAULT',
        entityId: resource,
        newValue: { action, timestamp: new Date().toISOString() },
      },
    });
  }
}
