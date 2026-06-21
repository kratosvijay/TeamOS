import { Controller, Get, Post, Put, Delete, Body, Param, UseGuards } from '@nestjs/common';
import { OrganizationService } from './organization.service';
import { JwtStrategy } from '../auth/jwt.strategy';

@Controller('organization')
export class OrganizationController {
  constructor(private orgService: OrganizationService) {}

  @Post()
  async createOrganization(@Body() body: { name: string; domain?: string }) {
    return this.orgService.createOrganization(body.name, body.domain);
  }

  @Get(':id')
  async getOrganization(@Param('id') id: string) {
    return this.orgService.getOrganization(id);
  }

  @Put(':id')
  async updateOrganization(
    @Param('id') id: string,
    @Body() body: { name: string; domain?: string },
  ) {
    return this.orgService.updateOrganization(id, body.name, body.domain);
  }

  @Post(':id/workspaces')
  async addWorkspaceToOrganization(
    @Param('id') orgId: string,
    @Body() body: { workspaceId: string },
  ) {
    return this.orgService.addWorkspaceToOrganization(orgId, body.workspaceId);
  }

  @Get(':id/workspaces')
  async getWorkspaces(@Param('id') orgId: string) {
    return this.orgService.getWorkspaces(orgId);
  }

  @Post(':id/departments')
  async createDepartment(
    @Param('id') orgId: string,
    @Body() body: { name: string; managerId?: string },
  ) {
    return this.orgService.createDepartment(orgId, body.name, body.managerId);
  }

  @Get(':id/departments')
  async getDepartments(@Param('id') orgId: string) {
    return this.orgService.getDepartments(orgId);
  }

  @Put('departments/:depId')
  async updateDepartment(
    @Param('depId') depId: string,
    @Body() body: { name: string; managerId?: string },
  ) {
    return this.orgService.updateDepartment(depId, body.name, body.managerId);
  }

  @Delete('departments/:depId')
  async deleteDepartment(@Param('depId') depId: string) {
    return this.orgService.deleteDepartment(depId);
  }
}
