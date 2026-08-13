import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/router/route_names.dart';
import '../../../app/theme/app_colors.dart';
import '../../common/viewmodels/user_role_viewmodel.dart';
import '../../common/widgets/hud_card.dart';
import '../../common/widgets/status_chip.dart';

class RoleCheckView extends StatelessWidget {
  const RoleCheckView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              const Center(
                child: StatusChip(
                  label: 'ONBOARDING ROLE CHECK',
                  variant: StatusChipVariant.info,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'CHỌN VAI TRÒ TRUY CẬP',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Chakra Petch',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Tài khoản của bạn được cấp quyền sử dụng nhiều không gian làm việc.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Sora',
                  fontSize: 14,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 36),

              // Contestant Role Card
              HudCard(
                accentBarColor: AppColors.accentTeam,
                backgroundColor: AppColors.bgPanel,
                onTap: () {
                  context.read<UserRoleViewModel>().setActiveRole('contestant');
                  Navigator.of(context).pushReplacementNamed(RouteNames.home);
                },
                child: const Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.surfaceContainerHigh,
                      child: Icon(Icons.person, color: AppColors.accentTeam),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'THAM GIA VỚI VAI TRÒ THÍ SINH',
                            style: TextStyle(
                              fontFamily: 'Chakra Petch',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.accentTeam,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Quản lý đội thi, xem tiến độ nộp bài và bảng xếp hạng.',
                            style: TextStyle(
                              fontFamily: 'Sora',
                              fontSize: 12,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.accentTeam),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Mentor Role Card
              HudCard(
                accentBarColor: AppColors.accentMentor,
                backgroundColor: AppColors.bgPanel,
                onTap: () {
                  context.read<UserRoleViewModel>().setActiveRole('mentor');
                  Navigator.of(context).pushReplacementNamed(RouteNames.mentorDashboard);
                },
                child: const Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.surfaceContainerHigh,
                      child: Icon(Icons.psychology, color: AppColors.accentMentor),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'THAM GIA VỚI VAI TRÒ MENTOR',
                            style: TextStyle(
                              fontFamily: 'Chakra Petch',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.accentMentor,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Theo dõi các Track được phân công và danh sách đội hướng dẫn.',
                            style: TextStyle(
                              fontFamily: 'Sora',
                              fontSize: 12,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.accentMentor),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
