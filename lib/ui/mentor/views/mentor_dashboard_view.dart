import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/di/locator.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/context/user_role_context.dart';
import '../../common/widgets/clipped_container.dart';
import '../../common/widgets/hud_card.dart';
import '../../common/widgets/loading_indicator.dart';
import '../../common/widgets/status_chip.dart';
import '../viewmodels/mentor_dashboard_viewmodel.dart';
import 'mentor_ranking_view.dart';
import 'mentor_team_list_view.dart';

class MentorDashboardView extends StatelessWidget {
  const MentorDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MentorDashboardViewModel>(
      create: (_) => locator<MentorDashboardViewModel>(),
      child: const _MentorDashboardBody(),
    );
  }
}

class _MentorDashboardBody extends StatefulWidget {
  const _MentorDashboardBody();

  @override
  State<_MentorDashboardBody> createState() => _MentorDashboardBodyState();
}

class _MentorDashboardBodyState extends State<_MentorDashboardBody> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentRole = context.read<UserRoleContext>().currentRole;
      if (currentRole?.trackId != null) {
        context.read<MentorDashboardViewModel>().loadDashboard(currentRole!.trackId!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final roleContext = context.watch<UserRoleContext>();
    final vm = context.watch<MentorDashboardViewModel>();
    final currentRole = roleContext.currentRole;

    if (currentRole == null || currentRole.type != ActiveRoleType.mentor) {
      return const Scaffold(
        backgroundColor: AppColors.bgBase,
        body: Center(
          child: Text(
            'BẠN CHƯA CHỌN VAI TRÒ MENTOR.',
            style: TextStyle(fontFamily: 'JetBrains Mono', color: AppColors.textMuted),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: RefreshIndicator(
        onRefresh: () async {
          if (currentRole.trackId != null) {
            await vm.loadDashboard(currentRole.trackId!);
          }
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // M1 Track Info Banner HUD Card
              HudCard(
                accentBarColor: AppColors.accentMentor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StatusChip(
                          label: 'MENTOR DASHBOARD',
                          variant: StatusChipVariant.role,
                          customColor: AppColors.accentMentor,
                          fontSize: 10,
                        ),
                        StatusChip(
                          label: 'ONLINE',
                          variant: StatusChipVariant.success,
                          fontSize: 9,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'HẠNG MỤC: ${currentRole.trackName ?? "AI & MACHINE LEARNING"}',
                      style: const TextStyle(
                        fontFamily: 'Chakra Petch',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Sự kiện: ${currentRole.eventName}',
                      style: const TextStyle(
                        fontFamily: 'Sora',
                        fontSize: 13,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: ClippedContainer(
                            padding: const EdgeInsets.all(10),
                            backgroundColor: AppColors.surfaceContainerLowest,
                            borderColor: AppColors.accentMentor.withValues(alpha: 0.4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'ĐỘI THEO DÕI',
                                  style: TextStyle(
                                    fontFamily: 'JetBrains Mono',
                                    fontSize: 9,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                                Text(
                                  '${vm.teams.length} Teams',
                                  style: const TextStyle(
                                    fontFamily: 'JetBrains Mono',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.accentMentor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ClippedContainer(
                            padding: const EdgeInsets.all(10),
                            backgroundColor: AppColors.surfaceContainerLowest,
                            borderColor: AppColors.primary.withValues(alpha: 0.4),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ĐÁNH GIÁ CHẤM',
                                  style: TextStyle(
                                    fontFamily: 'JetBrains Mono',
                                    fontSize: 9,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                                Text(
                                  'ACTIVE',
                                  style: TextStyle(
                                    fontFamily: 'JetBrains Mono',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'MENTOR ACTIONS & TELEMETRY',
                style: TextStyle(
                  fontFamily: 'JetBrains Mono',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 12),

              if (vm.isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(child: LoadingIndicator(message: 'LOADING TEAMS...')),
                )
              else ...[
                // M3 Teams Navigation Card
                HudCard(
                  accentBarColor: AppColors.accentMentor,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const MentorTeamListView()),
                    );
                  },
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.bgInput,
                        child: Icon(Icons.groups_outlined, color: AppColors.accentMentor, size: 22),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'DANH SÁCH ĐỘI THI TRONG TRACK',
                              style: TextStyle(
                                fontFamily: 'Chakra Petch',
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              'Xem danh sách & chấm điểm (${vm.teams.length} đội)',
                              style: const TextStyle(
                                fontFamily: 'Sora',
                                fontSize: 12,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: AppColors.primary),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // C12 Leaderboard Navigation Card
                HudCard(
                  accentBarColor: AppColors.accentJudge,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => MentorRankingView(roundId: currentRole.trackId ?? ''),
                      ),
                    );
                  },
                  child: const Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.bgInput,
                        child: Icon(Icons.leaderboard_outlined, color: AppColors.accentJudge, size: 22),
                      ),
                      SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'BẢNG XẾP HẠNG HẠNG MỤC',
                              style: TextStyle(
                                fontFamily: 'Chakra Petch',
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              'Bảng tổng hợp điểm số & xếp hạng',
                              style: TextStyle(
                                fontFamily: 'Sora',
                                fontSize: 12,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right, color: AppColors.primary),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
