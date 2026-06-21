import { Injectable, OnModuleInit } from '@nestjs/common';
import * as Minio from 'minio';

@Injectable()
export class StorageService implements OnModuleInit {
  private minioClient: Minio.Client;
  private readonly defaultBucket = 'teamos-recordings';

  async onModuleInit() {
    const endPoint = process.env.MINIO_ENDPOINT || 'localhost';
    const port = parseInt(process.env.MINIO_PORT || '9000');
    const accessKey = process.env.MINIO_ACCESS_KEY || 'minioadmin';
    const secretKey = process.env.MINIO_SECRET_KEY || 'minioadmin';
    const useSSL = process.env.MINIO_USE_SSL === 'true';

    this.minioClient = new Minio.Client({
      endPoint,
      port,
      useSSL,
      accessKey,
      secretKey,
    });

    console.log(`Connected to MinIO storage at ${endPoint}:${port}`);
    await this.ensureBucketExists(this.defaultBucket);
  }

  async ensureBucketExists(bucketName: string) {
    try {
      const exists = await this.minioClient.bucketExists(bucketName);
      if (!exists) {
        await this.minioClient.makeBucket(bucketName);
        console.log(`MinIO: Created bucket [${bucketName}]`);
      }
    } catch (e) {
      console.error(`MinIO: Error checking/creating bucket [${bucketName}]`, e);
    }
  }

  async uploadFile(
    bucketName: string,
    fileName: string,
    fileBuffer: Buffer,
    size: number,
    mimeType: string,
  ): Promise<string> {
    await this.ensureBucketExists(bucketName);
    
    await this.minioClient.putObject(
      bucketName,
      fileName,
      fileBuffer,
      size,
      { 'Content-Type': mimeType },
    );

    const bucketPath = `${bucketName}/${fileName}`;
    console.log(`MinIO: File uploaded to path: ${bucketPath}`);
    return bucketPath;
  }

  async getPresignedUrl(bucketName: string, fileName: string, expirySeconds = 3600): Promise<string> {
    try {
      return await this.minioClient.presignedGetObject(bucketName, fileName, expirySeconds);
    } catch (e) {
      console.error(`MinIO: Error generating presigned URL for [${bucketName}/${fileName}]`, e);
      throw e;
    }
  }

  async deleteFile(bucketName: string, fileName: string): Promise<void> {
    try {
      await this.minioClient.removeObject(bucketName, fileName);
      console.log(`MinIO: File deleted [${bucketName}/${fileName}]`);
    } catch (e) {
      console.error(`MinIO: Error deleting file [${bucketName}/${fileName}]`, e);
      throw e;
    }
  }
}
