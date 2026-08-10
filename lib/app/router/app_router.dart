import 'package:flutter/material.dart';
import '../../ui/auth/views/login_view.dart';
import '../../ui/auth/views/register_view.dart';
import '../../ui/home/views/home_view.dart';
import 'route_names.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.login:
        return MaterialPageRoute(builder: (_) => const LoginView());
      case RouteNames.register:
        return MaterialPageRoute(builder: (_) => const RegisterView());
      case RouteNames.home:
      default:
        return MaterialPageRoute(builder: (_) => const HomeView());
    }
  }
}
