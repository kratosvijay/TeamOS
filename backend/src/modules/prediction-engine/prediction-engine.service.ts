import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class PredictionEngineService {
  constructor(private readonly prisma: PrismaService) {}

  async forecastMetric(workspaceId: string, targetMetric: string, targetDate: Date) {
    let model = await this.prisma.predictionModel.findFirst({
      where: { workspaceId, targetMetric },
    });

    if (!model) {
      model = await this.prisma.predictionModel.create({
        data: {
          workspaceId,
          name: `${targetMetric} ARIMA Forecast Model`,
          targetMetric,
          algorithm: 'ARIMA',
          configJson: JSON.stringify({ p: 1, d: 1, q: 1 }),
        },
      });
    }

    // Solve predicted values (mock ARIMA output)
    let predictedValue = 15.5;
    if (targetMetric.includes('attrition')) predictedValue = 0.08;
    else if (targetMetric.includes('delay')) predictedValue = 24.0; // hours

    return this.prisma.predictionResult.create({
      data: {
        modelId: model.id,
        workspaceId,
        predictedValue,
        lowerBound: predictedValue * 0.85,
        upperBound: predictedValue * 1.15,
        confidence: 0.90,
        targetDate,
      },
    });
  }

  async triggerLearningLoop(workspaceId: string, predictionId: string, actualValue: number) {
    const prediction = await this.prisma.predictionResult.findUnique({
      where: { id: predictionId },
    });

    if (!prediction) {
      throw new Error(`Prediction Result not found: ${predictionId}`);
    }

    const variance = actualValue - prediction.predictedValue;

    // Trigger learning calibration log
    const weightsUpdated = {
      learningRate: 0.05,
      weightChangeRatio: variance * 0.02,
      calibrationFactor: 0.98,
    };

    return this.prisma.learningLoopLog.create({
      data: {
        workspaceId,
        predictionId,
        actualValue,
        variance,
        weightsUpdatedJson: JSON.stringify(weightsUpdated),
      },
    });
  }
}
