import { Module, Global } from '@nestjs/common';
import { SecretVaultService } from './secret-vault.service';

@Global()
@Module({
  providers: [SecretVaultService],
  exports: [SecretVaultService],
})
export class SecretVaultModule {}
