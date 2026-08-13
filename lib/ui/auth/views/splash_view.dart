import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/router/route_names.dart';
import '../../../app/theme/app_colors.dart';
import '../../common/viewmodels/user_role_viewmodel.dart';
import '../../common/widgets/clipped_container.dart';
import '../../common/widgets/status_chip.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _checkSessionAndNavigate();
  }

  Future<void> _checkSessionAndNavigate() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;

    final userRoleVM = context.read<UserRoleViewModel>();
    await userRoleVM.fetchUserRoles();

    if (!mounted) return;
    if (userRoleVM.isLoggedIn) {
      if (userRoleVM.roles.length >= 2) {
        Navigator.of(context).pushReplacementNamed(RouteNames.roleCheck);
      } else if (userRoleVM.isMentor) {
        Navigator.of(context).pushReplacementNamed(RouteNames.mentorDashboard);
      } else {
        Navigator.of(context).pushReplacementNamed(RouteNames.home);
      }
    } else {
      Navigator.of(context).pushReplacementNamed(RouteNames.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: Stack(
        children: [
          // Navy Grid Background Effect
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClippedContainer(
                  width: 96,
                  height: 96,
                  backgroundColor: AppColors.surfaceContainerLowest,
                  borderColor: AppColors.primary,
                  borderWidth: 2,
                  child: const Icon(
                    Icons.shield_outlined,
                    size: 48,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'SEAL MOBILE',
                  style: TextStyle(
                    fontFamily: 'Chakra Petch',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const StatusChip(
                  label: 'COMMAND DECK :: INITIALIZING...',
                  variant: StatusChipVariant.info,
                ),
                const SizedBox(height: 32),
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
