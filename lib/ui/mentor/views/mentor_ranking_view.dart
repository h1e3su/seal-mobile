import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/di/locator.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/context/user_role_context.dart';
import '../../common/widgets/clipped_container.dart';
import '../../common/widgets/hud_card.dart';
import '../../common/widgets/loading_indicator.dart';
import '../../common/widgets/status_chip.dart';
import '../viewmodels/mentor_ranking_viewmodel.dart';

class MentorRankingView extends StatelessWidget {
  final String roundId;

  const MentorRankingView({
    super.key,
    required this.roundId,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MentorRankingViewModel>(
      create: (_) => locator<MentorRankingViewModel>(),
      child: _MentorRankingBody(roundId: roundId),
    );
  }
}

class _MentorRankingBody extends StatefulWidget {
  final String roundId;

  const _MentorRankingBody({required this.roundId});

  @override
  State<_MentorRankingBody> createState() => _MentorRankingBodyState();
}

class _MentorRankingBodyState extends State<_MentorRankingBody> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final trackId = context.read<UserRoleContext>().currentRole?.trackId ?? '';
      context.read<MentorRankingViewModel>().loadRanking(widget.roundId, trackId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MentorRankingViewModel>();

    if (vm.isLoading) {
      return Scaffold(
        backgroundColor: AppColors.bgBase,
        appBar: AppBar(title: const Text('BẢNG XẾP HẠNG LEADERBOARD (C12)')),
        body: const Center(child: LoadingIndicator(message: 'COMPUTING STANDINGS...')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bgBase,
      appBar: AppBar(
        title: const Text('BẢNG XẾP HẠNG LEADERBOARD (C12)'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final trackId = context.read<UserRoleContext>().currentRole?.trackId ?? '';
          await vm.loadRanking(widget.roundId, trackId);
        },
        child: vm.results.isEmpty
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Text(
                    'CHƯA CÓ BẢNG XẾP HẠNG ĐƯỢC CÔNG BỐ CHO HẠNG MỤC NÀY.',
                    style: TextStyle(fontFamily: 'JetBrains Mono', color: AppColors.textMuted),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16.0),
                itemCount: vm.results.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final result = vm.results[index];

                  Color rankColor = AppColors.primary;
                  if (result.rank == 1) rankColor = AppColors.accentJudge;
                  if (result.rank == 2) rankColor = const Color(0xFFC0C0C0);
                  if (result.rank == 3) rankColor = const Color(0xFFCD7F32);

                  return HudCard(
                    accentBarColor: rankColor,
                    child: Row(
                      children: [
                        ClippedContainer(
                          width: 44,
                          height: 44,
                          backgroundColor: rankColor.withValues(alpha: 0.15),
                          borderColor: rankColor,
                          child: Center(
                            child: Text(
                              '#${result.rank}',
                              style: TextStyle(
                                fontFamily: 'JetBrains Mono',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: rankColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Đội: ${result.teamId}',
                                style: const TextStyle(
                                  fontFamily: 'Chakra Petch',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'ĐIỂM CHUNG CUỘC: ${result.finalScore.toStringAsFixed(2)} PTS',
                                style: const TextStyle(
                                  fontFamily: 'JetBrains Mono',
                                  fontSize: 11,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (result.isAdvanced)
                          const StatusChip(
                            label: 'ĐI TIẾP',
                            variant: StatusChipVariant.success,
                            fontSize: 9,
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
