import { Module } from '@nestjs/common';
import { PlatformVersionService } from './platform-version.service';
import { MigrationService } from './migration.service';
import { UpgradeService } from './upgrade.service';
import { CompatibilityService } from './compatibility.service';

@Module({
  providers: [
    PlatformVersionService,
    MigrationService,
    UpgradeService,
    CompatibilityService,
  ],
  exports: [
    PlatformVersionService,
    MigrationService,
    UpgradeService,
    CompatibilityService,
  ],
})
export class PlatformLifecycleModule {}
