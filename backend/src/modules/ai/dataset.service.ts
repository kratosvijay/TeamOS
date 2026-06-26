import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

export interface DatasetItem {
  id: string;
  datasetName: string;
  prompt: string;
  expectedResponse: string;
  category: string;
}

@Injectable()
export class DatasetService {
  private datasets = new Map<string, DatasetItem[]>();

  constructor(private readonly prisma: PrismaService) {
    this.initializeDefaultBenchmarks();
  }

  private initializeDefaultBenchmarks() {
    this.datasets.set('hr_benchmarks', [
      {
        id: 'bench-1',
        datasetName: 'hr_benchmarks',
        prompt: 'Check candidate onboarding qualifications.',
        expectedResponse: 'Onboarding check completed: standard checks apply.',
        category: 'HR',
      },
    ]);

    this.datasets.set('finance_benchmarks', [
      {
        id: 'bench-2',
        datasetName: 'finance_benchmarks',
        prompt: 'Verify ledger balance checks anomalies.',
        expectedResponse: 'No anomalies detected in database records.',
        category: 'Finance',
      },
    ]);
  }

  async getDataset(name: string): Promise<DatasetItem[]> {
    return this.datasets.get(name) || [];
  }

  async addDatasetItem(name: string, item: DatasetItem) {
    const existing = this.datasets.get(name) || [];
    existing.push(item);
    this.datasets.set(name, existing);
    return item;
  }
}
