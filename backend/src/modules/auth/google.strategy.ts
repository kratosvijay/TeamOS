import { Injectable } from '@nestjs/common';

@Injectable()
export class GoogleStrategy {
  private clientId = process.env.GOOGLE_CLIENT_ID;
  private clientSecret = process.env.GOOGLE_CLIENT_SECRET;
  private redirectUri = process.env.GOOGLE_REDIRECT_URI;

  getOAuthUrls() {
    return `https://accounts.google.com/o/oauth2/v2/auth?client_id=${this.clientId}&redirect_uri=${this.redirectUri}&response_type=code&scope=email%20profile`;
  }
}
