import { Controller, Post, Body, Req, Headers, BadRequestException } from '@nestjs/common';
import { AuthService } from './auth.service';
import { Request } from 'express';

@Controller('auth')
export class AuthController {
  constructor(private authService: AuthService) {}

  @Post('register')
  async register(@Body() body: { email: string; passwordPlain: string; fullName: string }) {
    if (!body.email || !body.passwordPlain || !body.fullName) {
      throw new BadRequestException('Email, password, and full name are required');
    }
    const hash = await this.authService.hashPassword(body.passwordPlain);
    const user = await this.authService.register(body.email, hash, body.fullName);
    return { id: user.id, email: user.email, fullName: user.fullName };
  }

  @Post('login')
  async login(
    @Body() body: { email: string; passwordPlain: string },
    @Req() req: Request,
    @Headers('user-agent') userAgent: string,
  ) {
    const ip = req.ip;
    return this.authService.login(body.email, body.passwordPlain, ip, userAgent);
  }

  @Post('refresh')
  async refresh(@Body() body: { refreshToken: string }) {
    if (!body.refreshToken) {
      throw new BadRequestException('Refresh token is required');
    }
    return this.authService.refreshTokens(body.refreshToken);
  }

  @Post('logout')
  async logout() {
    return { status: 'logged-out' };
  }

  @Post('google')
  async googleLogin(
    @Body() body: { code: string },
    @Req() req: Request,
    @Headers('user-agent') userAgent: string,
  ) {
    if (!body.code) {
      throw new BadRequestException('Authorization code is required');
    }
    return this.authService.verifyOAuthCode('google', body.code, req.ip, userAgent);
  }

  @Post('microsoft')
  async microsoftLogin(
    @Body() body: { code: string },
    @Req() req: Request,
    @Headers('user-agent') userAgent: string,
  ) {
    if (!body.code) {
      throw new BadRequestException('Authorization code is required');
    }
    return this.authService.verifyOAuthCode('microsoft', body.code, req.ip, userAgent);
  }

  @Post('forgot-password')
  async forgotPassword(@Body() body: { email: string }) {
    // In production: creates a reset token and sends an email.
    return { status: 'ok', message: 'Reset token dispatched if account exists' };
  }

  @Post('reset-password')
  async resetPassword(@Body() body: { email: string; token: string; newPasswordPlain: string }) {
    // In production: validates reset token and hashes new password.
    return { status: 'ok', message: 'Password updated successfully' };
  }
}
