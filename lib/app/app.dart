import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/context/user_role_context.dart';
import 'di/locator.dart';
import 'router/app_router.dart';
import 'router/route_names.dart';
import 'theme/app_theme.dart';

// ViewModels
import '../ui/auth/viewmodels/login_viewmodel.dart';
import '../ui/auth/viewmodels/register_viewmodel.dart';
import '../ui/event/viewmodels/event_viewmodel.dart';
import '../ui/team/viewmodels/team_viewmodel.dart';
import '../ui/submission/viewmodels/submission_viewmodel.dart';
import '../ui/profile/viewmodels/profile_viewmodel.dart';
import '../ui/common/viewmodels/user_role_viewmodel.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // App-wide singleton context for role state
        ChangeNotifierProvider<UserRoleContext>.value(
          value: locator<UserRoleContext>(),
        ),
        ChangeNotifierProvider<UserRoleViewModel>(
          create: (_) => locator<UserRoleViewModel>(),
        ),
        ChangeNotifierProvider<LoginViewModel>(
          create: (_) => locator<LoginViewModel>(),
        ),
        ChangeNotifierProvider<RegisterViewModel>(
          create: (_) => locator<RegisterViewModel>(),
        ),
        ChangeNotifierProvider<EventViewModel>(
          create: (_) => locator<EventViewModel>(),
        ),
        ChangeNotifierProvider<TeamViewModel>(
          create: (_) => locator<TeamViewModel>(),
        ),
        ChangeNotifierProvider<SubmissionViewModel>(
          create: (_) => locator<SubmissionViewModel>(),
        ),
        ChangeNotifierProvider<ProfileViewModel>(
          create: (_) => locator<ProfileViewModel>(),
        ),
      ],
      child: MaterialApp(
        title: 'SEAL App',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        initialRoute: RouteNames.login,
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}
