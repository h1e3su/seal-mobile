import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/di/locator.dart';
import '../../../data/models/score/judge_score_model.dart';
import '../../common/widgets/loading_indicator.dart';
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
    final theme = Theme.of(context);

    if (vm.isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Bảng điểm chi tiết')),
        body: const Center(child: LoadingIndicator()),
      );
    }

    if (vm.hasError) {
      return Scaffold(
        appBar: AppBar(title: const Text('Bảng điểm chi tiết')),
        body: Center(
          child: Text(
            vm.errorMessage ?? 'Đã có lỗi xảy ra',
            style: TextStyle(color: theme.colorScheme.error),
          ),
        ),
      );
    }

    final breakdown = vm.breakdown;
    if (breakdown == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Bảng điểm chi tiết')),
        body: const Center(child: Text('Không tìm thấy thông tin bảng điểm')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(breakdown.teamName.isNotEmpty ? breakdown.teamName : 'Bảng điểm chi tiết'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Team Header
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(Icons.groups, size: 36),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            breakdown.teamName,
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Mã đội: ${breakdown.teamId}',
                            style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Submissions List
            if (breakdown.submissions.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Text('Chưa có bài nộp nào cho đội thi này.'),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: breakdown.submissions.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final submission = breakdown.submissions[index];
                  final judgeScores = vm.visibleJudgeScores(submission);

                  return Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  '${submission.trackName} - ${submission.roundName}',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Chip(
                                label: Text(
                                  submission.roundPublished ? 'Đã công bố' : 'Chưa công bố',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: submission.roundPublished ? Colors.green[800] : Colors.orange[800],
                                  ),
                                ),
                                backgroundColor: submission.roundPublished ? Colors.green[50] : Colors.orange[50],
                              ),
                            ],
                          ),
                          const Divider(),
                          if (judgeScores == null)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.0),
                              child: Text(
                                'Chưa công bố kết quả',
                                style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
                              ),
                            )
                          else if (judgeScores.isEmpty)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12.0),
                              child: Text('Chưa có phiếu chấm điểm.'),
                            )
                          else
                            Column(
                              children: judgeScores.map((score) => _JudgeScoreTile(score: score)).toList(),
                            ),
                        ],
                      ),
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
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Giám khảo: ${score.judgeName}',
                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                'Tổng: ${score.totalScore.toStringAsFixed(1)} điểm',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
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
                      Text('• ${c.criteriaName}', style: theme.textTheme.bodySmall),
                      Text(
                        '${c.value.toStringAsFixed(1)} / ${c.maxScore.toStringAsFixed(1)}',
                        style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )),
          ],
          if (score.comment != null && score.comment!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Nhận xét: "${score.comment}"',
              style: theme.textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
            ),
          ],
        ],
      ),
    );
  }
}
