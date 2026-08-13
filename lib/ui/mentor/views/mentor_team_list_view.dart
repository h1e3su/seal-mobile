import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/di/locator.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/context/user_role_context.dart';
import '../../common/widgets/app_button.dart';
import '../../common/widgets/hud_card.dart';
import '../../common/widgets/loading_indicator.dart';
import '../../common/widgets/status_chip.dart';
import '../viewmodels/mentor_dashboard_viewmodel.dart';
import 'team_score_breakdown_view.dart';

class MentorTeamListView extends StatelessWidget {
  const MentorTeamListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MentorDashboardViewModel>(
      create: (_) => locator<MentorDashboardViewModel>(),
      child: const _MentorTeamListBody(),
    );
  }
}

class _MentorTeamListBody extends StatefulWidget {
  const _MentorTeamListBody();

  @override
  State<_MentorTeamListBody> createState() => _MentorTeamListBodyState();
}

class _MentorTeamListBodyState extends State<_MentorTeamListBody> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final roleContext = context.read<UserRoleContext>();
      final trackId = roleContext.currentRole?.trackId;
      if (trackId != null) {
        context.read<MentorDashboardViewModel>().loadDashboard(trackId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MentorDashboardViewModel>();

    if (vm.isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.bgBase,
        body: Center(child: LoadingIndicator(message: 'FETCHING TRACK TEAMS...')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bgBase,
      appBar: AppBar(
        title: const Text('ĐỘI THI TRONG HẠNG MỤC (M3)'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final trackId = context.read<UserRoleContext>().currentRole?.trackId;
          if (trackId != null) {
            await vm.loadDashboard(trackId);
          }
        },
        child: vm.teams.isEmpty
            ? const Center(
                child: Text(
                  'CHƯA CÓ ĐỘI THI NÀO TRONG HẠNG MỤC NÀY.',
                  style: TextStyle(fontFamily: 'JetBrains Mono', color: AppColors.textMuted),
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16.0),
                itemCount: vm.teams.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final team = vm.teams[index];
                  return HudCard(
                    accentBarColor: AppColors.accentMentor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              team.name,
                              style: const TextStyle(
                                fontFamily: 'Chakra Petch',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            StatusChip(
                              label: team.status.toUpperCase(),
                              variant: StatusChipVariant.info,
                              fontSize: 9,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Leader: ${team.leaderName ?? "Chưa rõ"}',
                          style: const TextStyle(
                            fontFamily: 'Sora',
                            fontSize: 12,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 12),
                        AppButton(
                          label: 'XEM BÀI NỘP & CHẤM ĐIỂM',
                          height: 36,
                          variant: AppButtonVariant.secondary,
                          icon: Icons.analytics_outlined,
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => TeamScoreBreakdownView(teamId: team.id),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
