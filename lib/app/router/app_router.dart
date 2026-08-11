import 'package:flutter/material.dart';
import '../../ui/auth/views/login_view.dart';
import '../../ui/auth/views/register_view.dart';
import '../../ui/event/views/event_list_view.dart';
import '../../ui/event/views/event_detail_view.dart';
import '../../ui/team/views/my_team_view.dart';
import '../../ui/team/views/create_team_view.dart';
import '../../ui/submission/views/submit_result_view.dart';
import '../../ui/profile/views/profile_view.dart';
import 'route_names.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.login:
        return MaterialPageRoute(builder: (_) => const LoginView());
      case RouteNames.register:
        return MaterialPageRoute(builder: (_) => const RegisterView());
      case RouteNames.home:
      case RouteNames.eventList:
        return MaterialPageRoute(builder: (_) => const EventListView());
      case RouteNames.forgotPassword:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Quên mật khẩu')),
            body: const Center(
              child: Text('Tính năng quên mật khẩu đang được phát triển.'),
            ),
          ),
        );
      case RouteNames.eventDetail:
        return MaterialPageRoute(builder: (_) => const EventDetailView());
      case RouteNames.myTeam:
        return MaterialPageRoute(builder: (_) => const MyTeamView());
      case RouteNames.createTeam:
        return MaterialPageRoute(builder: (_) => const CreateTeamView());
      case RouteNames.submitResult:
        return MaterialPageRoute(builder: (_) => const SubmitResultView());
      case RouteNames.profile:
        return MaterialPageRoute(builder: (_) => const ProfileView());
      default:
        return MaterialPageRoute(builder: (_) => const LoginView());
    }
  }
}
