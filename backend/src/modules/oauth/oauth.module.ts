import { Module } from '@nestjs/common';
import { OAuthService } from './oauth.service';
import { SecretVaultModule } from '../secret-vault/secret-vault.module';

@Module({
  imports: [SecretVaultModule],
  providers: [OAuthService],
  exports: [OAuthService],
})
export class OAuthModule {}
