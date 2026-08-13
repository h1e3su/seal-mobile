import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/di/locator.dart';
import '../../../app/theme/app_colors.dart';
import '../../../data/models/score/judge_score_model.dart';
import '../../common/widgets/clipped_container.dart';
import '../../common/widgets/hud_card.dart';
import '../../common/widgets/loading_indicator.dart';
import '../../common/widgets/status_chip.dart';
import '../viewmodels/team_score_breakdown_viewmodel.dart';

class TeamScoreBreakdownView extends StatelessWidget {
  final String teamId;

  const TeamScoreBreakdownView({
    super.key,
    required this.teamId,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TeamScoreBreakdownViewModel>(
      create: (_) => locator<TeamScoreBreakdownViewModel>(),
      child: _TeamScoreBreakdownBody(teamId: teamId),
    );
  }
}

class _TeamScoreBreakdownBody extends StatefulWidget {
  final String teamId;

  const _TeamScoreBreakdownBody({required this.teamId});

  @override
  State<_TeamScoreBreakdownBody> createState() => _TeamScoreBreakdownBodyState();
}

class _TeamScoreBreakdownBodyState extends State<_TeamScoreBreakdownBody> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TeamScoreBreakdownViewModel>().loadBreakdown(widget.teamId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TeamScoreBreakdownViewModel>();

    if (vm.isLoading) {
      return Scaffold(
        backgroundColor: AppColors.bgBase,
        appBar: AppBar(title: const Text('BẢNG ĐIỂM CHI TIẾT (M4)')),
        body: const Center(child: LoadingIndicator(message: 'FETCHING SCORE BREAKDOWN...')),
      );
    }

    final breakdown = vm.breakdown;

    return Scaffold(
      backgroundColor: AppColors.bgBase,
      appBar: AppBar(
        title: Text(breakdown?.teamName.isNotEmpty == true ? breakdown!.teamName : 'BẢNG ĐIỂM CHI TIẾT (M4)'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: breakdown == null
          ? const Center(
              child: Text('KHÔNG TÌM THẤY BẢNG ĐIỂM', style: TextStyle(fontFamily: 'JetBrains Mono', color: AppColors.textMuted)),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Team Header Card HUD
                  HudCard(
                    accentBarColor: AppColors.accentJudge,
                    child: Row(
                      children: [
                        ClippedContainer(
                          width: 44,
                          height: 44,
                          backgroundColor: AppColors.surfaceContainerLowest,
                          borderColor: AppColors.accentJudge,
                          child: const Icon(Icons.shield_outlined, color: AppColors.accentJudge, size: 24),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                breakdown.teamName,
                                style: const TextStyle(
                                  fontFamily: 'Chakra Petch',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                'MÃ ĐỘI THI: ${breakdown.teamId}',
                                style: const TextStyle(
                                  fontFamily: 'JetBrains Mono',
                                  fontSize: 11,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    'PHIẾU CHẤM ĐIỂM TỪ GIÁM KHẢO (EVALUATION BREAKDOWN)',
                    style: TextStyle(
                      fontFamily: 'JetBrains Mono',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (breakdown.submissions.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Text(
                          'CHƯA CÓ BÀI NỘP NÀO CHO ĐỘI THI NÀY.',
                          style: TextStyle(fontFamily: 'JetBrains Mono', color: AppColors.textMuted),
                        ),
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: breakdown.submissions.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final submission = breakdown.submissions[index];
                        final judgeScores = vm.visibleJudgeScores(submission);

                        return HudCard(
                          accentBarColor: AppColors.primary,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${submission.trackName} - ${submission.roundName}',
                                      style: const TextStyle(
                                        fontFamily: 'Chakra Petch',
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                  StatusChip(
                                    label: submission.roundPublished ? 'ĐÃ CÔNG BỐ' : 'CHỜ CÔNG BỐ',
                                    variant: submission.roundPublished
                                        ? StatusChipVariant.success
                                        : StatusChipVariant.warning,
                                    fontSize: 9,
                                  ),
                                ],
                              ),
                              const Divider(color: AppColors.borderMuted, height: 16),
                              if (judgeScores == null)
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12.0),
                                  child: Text(
                                    'Kết quả chưa được công bố công khai',
                                    style: TextStyle(
                                      fontFamily: 'Sora',
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic,
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                )
                              else if (judgeScores.isEmpty)
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12.0),
                                  child: Text(
                                    'Chưa có phiếu chấm điểm từ giám khảo.',
                                    style: TextStyle(fontFamily: 'Sora', fontSize: 12, color: AppColors.textMuted),
                                  ),
                                )
                              else
                                Column(
                                  children: judgeScores.map((score) => _JudgeScoreTile(score: score)).toList(),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
    );
  }
}

class _JudgeScoreTile extends StatelessWidget {
  final JudgeScoreModel score;

  const _JudgeScoreTile({required this.score});

  @override
  Widget build(BuildContext context) {
    return ClippedContainer(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      padding: const EdgeInsets.all(12.0),
      backgroundColor: AppColors.surfaceContainerLowest,
      borderColor: AppColors.borderMuted,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Giám khảo: ${score.judgeName}',
                style: const TextStyle(
                  fontFamily: 'Sora',
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '${score.totalScore.toStringAsFixed(1)} Pts',
                style: const TextStyle(
                  fontFamily: 'JetBrains Mono',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          if (score.criteria.isNotEmpty) ...[
            const SizedBox(height: 8),
            ...score.criteria.map((c) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '• ${c.criteriaName}',
                        style: const TextStyle(fontFamily: 'Sora', fontSize: 12, color: AppColors.onSurfaceVariant),
                      ),
                      Text(
                        '${c.value.toStringAsFixed(1)} / ${c.maxScore.toStringAsFixed(1)}',
                        style: const TextStyle(
                          fontFamily: 'JetBrains Mono',
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                )),
          ],
          if (score.comment != null && score.comment!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Nhận xét: "${score.comment}"',
              style: const TextStyle(
                fontFamily: 'Sora',
                fontSize: 11,
                fontStyle: FontStyle.italic,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
