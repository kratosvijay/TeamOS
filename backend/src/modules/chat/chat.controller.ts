import { Controller, Post, Get, Delete, Body, Param, Query, UseGuards, Headers, Req } from '@nestjs/common';
import { ChatService } from './chat.service';
import { WorkspaceAuthGuard } from '../../common/guards/workspace-auth.guard';
import { ChannelType, ChannelRole } from '@prisma/client';
import { SearchService } from '../search/search.service';

@Controller('chat')
@UseGuards(WorkspaceAuthGuard)
export class ChatController {
  constructor(
    private chatService: ChatService,
    private searchService: SearchService,
  ) {}

  @Post('channels')
  async createChannel(
    @Headers('x-workspace-id') workspaceId: string,
    @Req() req: any,
    @Body() body: { name: string; description?: string; type: ChannelType },
  ) {
    const creatorId = req.user.id;
    return this.chatService.createChannel(workspaceId, creatorId, body);
  }

  @Get('channels')
  async getChannels(
    @Headers('x-workspace-id') workspaceId: string,
    @Req() req: any,
  ) {
    const userId = req.user.id;
    return this.chatService.getChannels(workspaceId, userId);
  }

  @Post('channels/:id/members')
  async addChannelMember(
    @Param('id') channelId: string,
    @Body() body: { userId: string; role?: ChannelRole },
    @Req() req: any,
  ) {
    const actorId = req.user.id;
    return this.chatService.addChannelMember(channelId, body.userId, body.role || ChannelRole.MEMBER, actorId);
  }

  @Delete('channels/:id/members/:userId')
  async removeChannelMember(
    @Param('id') channelId: string,
    @Param('userId') userId: string,
    @Req() req: any,
  ) {
    const actorId = req.user.id;
    return this.chatService.removeChannelMember(channelId, userId, actorId);
  }

  @Get('channels/:id/messages')
  async getChannelMessages(
    @Param('id') channelId: string,
    @Query('limit') limit?: string,
    @Query('offset') offset?: string,
  ) {
    const parsedLimit = limit ? parseInt(limit, 10) : 50;
    const parsedOffset = offset ? parseInt(offset, 10) : 0;
    return this.chatService.getChannelMessages(channelId, parsedLimit, parsedOffset);
  }

  @Get('messages/:id/threads')
  async getThreadReplies(
    @Param('id') parentId: string,
    @Query('limit') limit?: string,
    @Query('offset') offset?: string,
  ) {
    const parsedLimit = limit ? parseInt(limit, 10) : 50;
    const parsedOffset = offset ? parseInt(offset, 10) : 0;
    return this.chatService.getThreadReplies(parentId, parsedLimit, parsedOffset);
  }

  @Post('messages/:id/pin')
  async pinMessage(
    @Param('id') messageId: string,
    @Body() body: { channelId: string },
    @Req() req: any,
  ) {
    const userId = req.user.id;
    return this.chatService.pinMessage(messageId, body.channelId, userId);
  }

  @Delete('messages/:id/pin')
  async unpinMessage(
    @Param('id') messageId: string,
  ) {
    return this.chatService.unpinMessage(messageId);
  }

  @Get('channels/:id/pins')
  async getPinnedMessages(
    @Param('id') channelId: string,
  ) {
    return this.chatService.getPinnedMessages(channelId);
  }

  @Post('dms')
  async createDirectMessageRoom(
    @Body() body: { userIds: string[] },
    @Req() req: any,
  ) {
    const currentUserId = req.user.id;
    const allUserIds = Array.from(new Set([currentUserId, ...body.userIds]));
    return this.chatService.createDirectMessageRoom(allUserIds);
  }

  @Get('dms')
  async getDirectMessageRooms(
    @Req() req: any,
  ) {
    const userId = req.user.id;
    return this.chatService.getDirectMessageRooms(userId);
  }

  @Get('search')
  async searchChat(
    @Query('q') query: string,
  ) {
    return this.searchService.search(query, ['teamos-message', 'teamos-channel']);
  }
}
