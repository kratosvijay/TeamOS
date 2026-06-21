import { Injectable, OnModuleInit } from '@nestjs/common';
import { AccessToken, RoomServiceClient } from 'livekit-server-sdk';

@Injectable()
export class LiveKitService implements OnModuleInit {
  private roomServiceClient: RoomServiceClient;
  private apiKey: string;
  private apiSecret: string;
  private apiUrl: string;

  async onModuleInit() {
    this.apiKey = process.env.LIVEKIT_API_KEY || 'devkey';
    this.apiSecret = process.env.LIVEKIT_API_SECRET || 'secret';
    this.apiUrl = process.env.LIVEKIT_API_URL || 'http://localhost:7880';

    this.roomServiceClient = new RoomServiceClient(
      this.apiUrl,
      this.apiKey,
      this.apiSecret,
    );
    console.log(`LiveKit Service initialized connecting to URL: ${this.apiUrl}`);
  }

  generateToken(
    roomName: string,
    userId: string,
    userName: string,
    role: 'HOST' | 'CO_HOST' | 'PRESENTER' | 'ATTENDEE' = 'ATTENDEE',
  ): string {
    const at = new AccessToken(this.apiKey, this.apiSecret, {
      identity: userId,
      name: userName,
      ttl: '4h', // Token expires in 4 hours
    });

    const isHost = role === 'HOST' || role === 'CO_HOST';

    at.addGrant({
      roomJoin: true,
      room: roomName,
      canPublish: true,
      canSubscribe: true,
      canPublishData: true,
      roomAdmin: isHost, // Host roles get room admin credentials
    });

    return at.toJwt();
  }

  async createRoom(roomName: string, emptyTimeoutSeconds = 300) {
    try {
      return await this.roomServiceClient.createRoom({
        name: roomName,
        emptyTimeout: emptyTimeoutSeconds,
      });
    } catch (e) {
      console.error(`LiveKit: Failed to create room: ${roomName}`, e);
      throw e;
    }
  }

  async deleteRoom(roomName: string) {
    try {
      await this.roomServiceClient.deleteRoom(roomName);
      console.log(`LiveKit: Deleted room: ${roomName}`);
    } catch (e) {
      console.error(`LiveKit: Failed to delete room: ${roomName}`, e);
      throw e;
    }
  }

  async listParticipants(roomName: string) {
    try {
      return await this.roomServiceClient.listParticipants(roomName);
    } catch (e) {
      console.error(`LiveKit: Failed to list participants in room: ${roomName}`, e);
      return [];
    }
  }

  async muteParticipant(
    roomName: string,
    identity: string,
    trackSid: string,
    muted: boolean,
  ) {
    try {
      await this.roomServiceClient.mutePublishedTrack(
        roomName,
        identity,
        trackSid,
        muted,
      );
      console.log(`LiveKit: Toggled mute state of track: ${trackSid} for participant: ${identity}`);
    } catch (e) {
      console.error(`LiveKit: Failed to toggle mute state for participant: ${identity}`, e);
      throw e;
    }
  }

  async removeParticipant(roomName: string, identity: string) {
    try {
      await this.roomServiceClient.removeParticipant(roomName, identity);
      console.log(`LiveKit: Removed participant: ${identity} from room: ${roomName}`);
    } catch (e) {
      console.error(`LiveKit: Failed to remove participant: ${identity}`, e);
      throw e;
    }
  }
}
