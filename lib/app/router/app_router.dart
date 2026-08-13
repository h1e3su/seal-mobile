import 'package:flutter/material.dart';
import '../../ui/auth/views/splash_view.dart';
import '../../ui/auth/views/login_view.dart';
import '../../ui/auth/views/register_view.dart';
import '../../ui/auth/views/forgot_password_view.dart';
import '../../ui/auth/views/role_check_view.dart';
import '../../ui/common/views/contestant_shell_view.dart';
import '../../ui/common/views/mentor_shell_view.dart';
import '../../ui/profile/views/profile_verification_view.dart';
import '../../ui/profile/views/profile_locked_view.dart';
import '../../ui/event/views/event_list_view.dart';
import '../../ui/event/views/event_detail_view.dart';
import '../../ui/team/views/my_team_view.dart';
import '../../ui/team/views/team_roster_view.dart';
import '../../ui/submission/views/submission_list_view.dart';
import '../../ui/submission/views/submission_detail_view.dart';
import '../../ui/submission/views/submit_entry_view.dart';
import '../../ui/leaderboard/views/leaderboard_view.dart';
import '../../ui/appeals/views/appeals_view.dart';
import '../../ui/notifications/views/notifications_view.dart';
import '../../ui/profile/views/profile_view.dart';
import '../../ui/profile/views/rejection_history_view.dart';
import '../../ui/mentor/views/my_tracks_view.dart';
import '../../ui/mentor/views/teams_in_track_view.dart';
import '../../ui/mentor/views/team_viewer_view.dart';
import 'route_names.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case RouteNames.splash:
        return MaterialPageRoute(builder: (_) => const SplashView());
      case RouteNames.login:
        String? regEmail;
        bool isActSuccess = false;
        if (args is Map<String, dynamic>) {
          regEmail = args['registeredEmail'] as String?;
          isActSuccess = (args['isActivatedSuccess'] as bool?) ?? false;
        } else if (args is String) {
          regEmail = args;
        }
        return MaterialPageRoute(
          builder: (_) => LoginView(
            registeredEmail: regEmail,
            isActivatedSuccess: isActSuccess,
          ),
        );
      case RouteNames.register:
        return MaterialPageRoute(builder: (_) => const RegisterView());
      case RouteNames.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordView());
      case RouteNames.roleCheck:
        return MaterialPageRoute(builder: (_) => const RoleCheckView());
      case RouteNames.home:
        return MaterialPageRoute(builder: (_) => const ContestantShellView());
      case RouteNames.mentorDashboard:
        return MaterialPageRoute(builder: (_) => const MentorShellView());
      case RouteNames.profileVerification:
        return MaterialPageRoute(builder: (_) => const ProfileVerificationView());
      case RouteNames.profileLocked:
        return MaterialPageRoute(builder: (_) => const ProfileLockedView());
      case RouteNames.eventList:
        return MaterialPageRoute(builder: (_) => const EventListView());
      case RouteNames.eventDetail:
        return MaterialPageRoute(builder: (_) => const EventDetailView());
      case RouteNames.myTeam:
      case RouteNames.createTeam:
        return MaterialPageRoute(builder: (_) => const MyTeamView());
      case RouteNames.teamRoster:
        return MaterialPageRoute(builder: (_) => const TeamRosterView());
      case RouteNames.submissionList:
        return MaterialPageRoute(builder: (_) => const SubmissionListView());
      case RouteNames.submissionDetail:
      case RouteNames.submitResult:
        return MaterialPageRoute(builder: (_) => const SubmissionDetailView());
      case RouteNames.submitEntry:
        return MaterialPageRoute(builder: (_) => const SubmitEntryView());
      case RouteNames.leaderboard:
        return MaterialPageRoute(builder: (_) => const LeaderboardView());
      case RouteNames.appeals:
        return MaterialPageRoute(builder: (_) => const AppealsView());
      case RouteNames.notifications:
        return MaterialPageRoute(builder: (_) => const NotificationsView());
      case RouteNames.profile:
        return MaterialPageRoute(builder: (_) => const ProfileView());
      case RouteNames.rejectionHistory:
        return MaterialPageRoute(builder: (_) => const RejectionHistoryView());
      case RouteNames.myTracks:
        return MaterialPageRoute(builder: (_) => const MyTracksView());
      case RouteNames.teamsInTrack:
        return MaterialPageRoute(builder: (_) => const TeamsInTrackView());
      case RouteNames.teamViewer:
        return MaterialPageRoute(builder: (_) => const TeamViewerView());
      default:
        return MaterialPageRoute(builder: (_) => const SplashView());
    }
  }
}
