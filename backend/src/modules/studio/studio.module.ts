import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma/prisma.module';
import { StudioService } from './studio.service';
import { ApplicationLifecycleService } from './application-lifecycle.service';
import { PackageManagerService } from './package-manager.service';
import { ApplicationMarketplaceService } from './application-marketplace.service';
import { ValidatorService } from './validator.service';
import { MetadataDiffService } from './metadata-diff.service';
import { MetadataGitService } from './metadata-git.service';

@Module({
  imports: [PrismaModule],
  providers: [
    StudioService,
    ApplicationLifecycleService,
    PackageManagerService,
    ApplicationMarketplaceService,
    ValidatorService,
    MetadataDiffService,
    MetadataGitService,
  ],
  exports: [
    StudioService,
    ApplicationLifecycleService,
    PackageManagerService,
    ApplicationMarketplaceService,
    ValidatorService,
    MetadataDiffService,
    MetadataGitService,
  ],
})
export class StudioModule {}
