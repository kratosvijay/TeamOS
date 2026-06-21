import { Injectable } from '@nestjs/common';

@Injectable()
export class MicrosoftStrategy {
  private clientId = process.env.MICROSOFT_CLIENT_ID;
  private clientSecret = process.env.MICROSOFT_CLIENT_SECRET;
  private redirectUri = process.env.MICROSOFT_REDIRECT_URI;

  getOAuthUrls() {
    return `https://login.microsoftonline.com/common/oauth2/v2.0/authorize?client_id=${this.clientId}&redirect_uri=${this.redirectUri}&response_type=code&scope=openid%20profile%20email`;
  }
}
