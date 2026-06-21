import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Import feature screens
import '../features/auth/presentation/splash_screen.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/signup_screen.dart';
import '../features/auth/presentation/forgot_password_screen.dart';
import '../features/workspace/presentation/workspace_setup_screen.dart';
import '../features/workspace/presentation/workspace_selection_screen.dart';
import '../features/dashboard/presentation/dashboard_screen.dart';
import '../features/projects/presentation/project_list_screen.dart';
import '../features/projects/presentation/project_create_screen.dart';
import '../features/projects/presentation/project_details_screen.dart';
import '../features/tasks/presentation/chat_home_screen.dart';
import '../features/tasks/presentation/channel_screen.dart';
import '../features/tasks/presentation/dm_screen.dart';
import '../features/tasks/presentation/thread_screen.dart';
import '../features/tasks/presentation/voice_room_screen.dart';
import '../features/tasks/presentation/chat_search_screen.dart';
import '../features/tasks/presentation/mentions_screen.dart';
import '../features/tasks/presentation/pinned_messages_screen.dart';
import '../features/meetings/presentation/meeting_home_screen.dart';
import '../features/meetings/presentation/meeting_room_screen.dart';
import '../features/meetings/presentation/meeting_scheduler_screen.dart';
import '../features/meetings/presentation/meeting_details_screen.dart';
import '../features/meetings/presentation/meeting_notes_screen.dart';
import '../features/meetings/presentation/meeting_recordings_screen.dart';
import '../features/meetings/presentation/calendar_screen.dart';
import '../features/meetings/presentation/meeting_action_items_screen.dart';
import '../features/meetings/presentation/meeting_decisions_screen.dart';
import '../features/meetings/presentation/meeting_transcript_screen.dart';
import '../features/meetings/presentation/waiting_room_screen.dart';
import '../features/meetings/presentation/breakout_room_screen.dart';
import '../features/meetings/presentation/meeting_analytics_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/workspace-setup',
      builder: (context, state) => const WorkspaceSetupScreen(),
    ),
    GoRoute(
      path: '/workspaces',
      builder: (context, state) => const WorkspaceSelectionScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/projects',
      builder: (context, state) => const ProjectListScreen(),
    ),
    GoRoute(
      path: '/projects/create',
      builder: (context, state) => const ProjectCreateScreen(),
    ),
    GoRoute(
      path: '/projects/details/:projectId',
      builder: (context, state) {
        final projectId = state.pathParameters['projectId'] ?? '';
        return ProjectDetailsScreen(projectId: projectId);
      },
    ),
    GoRoute(
      path: '/chat',
      builder: (context, state) => const ChatHomeScreen(),
    ),
    GoRoute(
      path: '/chat/search',
      builder: (context, state) => const ChatSearchScreen(),
    ),
    GoRoute(
      path: '/chat/mentions',
      builder: (context, state) => const MentionsScreen(),
    ),
    GoRoute(
      path: '/chat/channel/:channelName',
      builder: (context, state) {
        final channelName = state.pathParameters['channelName'] ?? '';
        return ChannelScreen(channelName: channelName);
      },
    ),
    GoRoute(
      path: '/chat/channel/:channelName/pins',
      builder: (context, state) {
        final channelName = state.pathParameters['channelName'] ?? '';
        return PinnedMessagesScreen(channelName: channelName);
      },
    ),
    GoRoute(
      path: '/chat/dm/:userName',
      builder: (context, state) {
        final userName = state.pathParameters['userName'] ?? '';
        return DmScreen(userName: userName);
      },
    ),
    GoRoute(
      path: '/chat/thread/:messageId',
      builder: (context, state) {
        final messageId = state.pathParameters['messageId'] ?? '';
        return ThreadScreen(messageId: messageId);
      },
    ),
    GoRoute(
      path: '/chat/voice/:huddleId',
      builder: (context, state) {
        final huddleId = state.pathParameters['huddleId'] ?? '';
        return VoiceRoomScreen(huddleId: huddleId);
      },
    ),
    GoRoute(
      path: '/meetings',
      builder: (context, state) => const MeetingHomeScreen(),
    ),
    GoRoute(
      path: '/meetings/room/:meetingId',
      builder: (context, state) {
        final meetingId = state.pathParameters['meetingId'] ?? '';
        return MeetingRoomScreen(meetingId: meetingId);
      },
    ),
    GoRoute(
      path: '/meetings/schedule/new',
      builder: (context, state) => const MeetingSchedulerScreen(),
    ),
    GoRoute(
      path: '/meetings/details/:meetingId',
      builder: (context, state) {
        final meetingId = state.pathParameters['meetingId'] ?? '';
        return MeetingDetailsScreen(meetingId: meetingId);
      },
    ),
    GoRoute(
      path: '/meetings/notes/:meetingId',
      builder: (context, state) {
        final meetingId = state.pathParameters['meetingId'] ?? '';
        return MeetingNotesScreen(meetingId: meetingId);
      },
    ),
    GoRoute(
      path: '/meetings/recordings',
      builder: (context, state) => const MeetingRecordingsScreen(),
    ),
    GoRoute(
      path: '/meetings/calendar',
      builder: (context, state) => const CalendarScreen(),
    ),
    GoRoute(
      path: '/meetings/action-items/:meetingId',
      builder: (context, state) {
        final meetingId = state.pathParameters['meetingId'] ?? '';
        return MeetingActionItemsScreen(meetingId: meetingId);
      },
    ),
    GoRoute(
      path: '/meetings/decisions/:meetingId',
      builder: (context, state) {
        final meetingId = state.pathParameters['meetingId'] ?? '';
        return MeetingDecisionsScreen(meetingId: meetingId);
      },
    ),
    GoRoute(
      path: '/meetings/transcript/:meetingId',
      builder: (context, state) {
        final meetingId = state.pathParameters['meetingId'] ?? '';
        return MeetingTranscriptScreen(meetingId: meetingId);
      },
    ),
    GoRoute(
      path: '/meetings/waiting-room/:meetingId',
      builder: (context, state) {
        final meetingId = state.pathParameters['meetingId'] ?? '';
        return WaitingRoomScreen(meetingId: meetingId);
      },
    ),
    GoRoute(
      path: '/meetings/breakout-rooms/:meetingId',
      builder: (context, state) {
        final meetingId = state.pathParameters['meetingId'] ?? '';
        return BreakoutRoomScreen(meetingId: meetingId);
      },
    ),
    GoRoute(
      path: '/meetings/analytics/:meetingId',
      builder: (context, state) {
        final meetingId = state.pathParameters['meetingId'] ?? '';
        return MeetingAnalyticsScreen(meetingId: meetingId);
      },
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(child: Text('Page not found: ${state.uri}')),
  ),
);
