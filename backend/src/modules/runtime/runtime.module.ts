import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma/prisma.module';
import { RuntimeService } from './runtime.service';
import { PageRenderService } from './page-render.service';
import { ComponentEngineService } from './component-engine.service';
import { RuleEngineService } from './rule-engine.service';
import { NavigationService } from './navigation.service';
import { ThemeService } from './theme.service';
import { DynamicApiService } from './dynamic-api.service';
import { PreviewSandboxService } from './preview-sandbox.service';
import { RuntimeDebuggerService } from './runtime-debugger.service';
import { MigrationAssistantService } from './migration-assistant.service';
import { ExtensionSdkService } from './extension-sdk.service';

@Module({
  imports: [PrismaModule],
  providers: [
    RuntimeService,
    PageRenderService,
    ComponentEngineService,
    RuleEngineService,
    NavigationService,
    ThemeService,
    DynamicApiService,
    PreviewSandboxService,
    RuntimeDebuggerService,
    MigrationAssistantService,
    ExtensionSdkService,
  ],
  exports: [
    RuntimeService,
    PageRenderService,
    ComponentEngineService,
    RuleEngineService,
    NavigationService,
    ThemeService,
    DynamicApiService,
    PreviewSandboxService,
    RuntimeDebuggerService,
    MigrationAssistantService,
    ExtensionSdkService,
  ],
})
export class RuntimeModule {}
