import { Controller, Post, Get, Body, Query, Headers, Req, HttpCode, HttpStatus, UseGuards, RawBodyRequest } from '@nestjs/common';
import { Request } from 'express';
import { BillingService } from './billing.service';
import { BillingAnalyticsService } from './billing-analytics.service';
import { WorkspaceAuthGuard } from '../../common/guards/workspace-auth.guard';

@Controller('billing')
export class BillingController {
  constructor(
    private readonly billingService: BillingService,
    private readonly analyticsService: BillingAnalyticsService,
  ) {}

  @Post('checkout-session')
  @UseGuards(WorkspaceAuthGuard)
  async checkoutSession(
    @Query('workspaceId') workspaceId: string,
    @Body('plan') plan: string,
    @Body('priceId') priceId?: string,
  ) {
    return this.billingService.createCheckoutSession(workspaceId, plan, priceId);
  }

  @Post('portal-session')
  @UseGuards(WorkspaceAuthGuard)
  async portalSession(@Query('workspaceId') workspaceId: string) {
    return this.billingService.createPortalSession(workspaceId);
  }

  @Get('subscription')
  @UseGuards(WorkspaceAuthGuard)
  async getSubscription(@Query('workspaceId') workspaceId: string) {
    return this.billingService.getSubscription(workspaceId);
  }

  @Get('usage')
  @UseGuards(WorkspaceAuthGuard)
  async getUsage(@Query('workspaceId') workspaceId: string) {
    return this.billingService.getUsage(workspaceId);
  }

  @Get('invoices')
  @UseGuards(WorkspaceAuthGuard)
  async getInvoices(@Query('workspaceId') workspaceId: string) {
    return this.billingService.getInvoices(workspaceId);
  }

  @Post('webhook')
  @HttpCode(HttpStatus.OK)
  async handleWebhook(
    @Headers('stripe-signature') signature: string,
    @Req() req: RawBodyRequest<Request>,
  ) {
    // If rawBody is populated by NestJS express configuration, use it, otherwise fallback to req.body buffer
    const payload = req.rawBody ? req.rawBody : Buffer.from(JSON.stringify(req.body));
    return this.billingService.handleWebhook(signature || 'mock_sig', payload);
  }

  @Get('admin/analytics')
  async getAdminAnalytics() {
    return this.analyticsService.getAdminDashboardMetrics();
  }
}
