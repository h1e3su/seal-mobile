import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/router/route_names.dart';
import '../../../app/theme/app_colors.dart';
import '../../common/widgets/clipped_container.dart';
import '../../common/widgets/hud_card.dart';
import '../../common/widgets/status_chip.dart';
import '../../mentor/viewmodels/mentor_ranking_viewmodel.dart';

class LeaderboardView extends StatefulWidget {
  final String? roundId;
  const LeaderboardView({super.key, this.roundId});

  @override
  State<LeaderboardView> createState() => _LeaderboardViewState();
}

class _LeaderboardViewState extends State<LeaderboardView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final rId = widget.roundId ?? 'rnd_01';
      context.read<MentorRankingViewModel>().loadRanking(rId);
    });
  }

  void _showScoreDetailBottomSheet(BuildContext context, String teamName, int rank, double score) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgPanel,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    teamName,
                    style: const TextStyle(fontFamily: 'Chakra Petch', fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                ),
                StatusChip(label: 'RANK #$rank', variant: StatusChipVariant.info, fontSize: 10),
              ],
            ),
            const SizedBox(height: 16),
            const Text('CHI TIẾT ĐIỂM SỐ THEO TIÊU CHÍ:', style: TextStyle(fontFamily: 'Chakra Petch', fontSize: 13, color: AppColors.textMuted)),
            const SizedBox(height: 10),
            _buildScoreRow('1. Tính sáng tạo & Đổi mới', '9.0 / 10'),
            _buildScoreRow('2. Kiến trúc & Công nghệ', '8.8 / 10'),
            _buildScoreRow('3. Thuyết trình & Demo', '9.2 / 10'),
            const Divider(color: AppColors.borderMuted, height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('TỔNG ĐIỂM:', style: TextStyle(fontFamily: 'Chakra Petch', fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                Text('$score pts', style: const TextStyle(fontFamily: 'JetBrains Mono', fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary)),
              ],
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).pushNamed(RouteNames.appeals);
              },
              child: const Text('Gửi yêu cầu phúc khảo bài chấm', style: TextStyle(fontFamily: 'Sora', fontSize: 13, color: AppColors.statusWarning)),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildScoreRow(String criteria, String score) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(criteria, style: const TextStyle(fontFamily: 'Sora', fontSize: 13, color: AppColors.textPrimary)),
          Text(score, style: const TextStyle(fontFamily: 'JetBrains Mono', fontSize: 13, color: AppColors.primary)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MentorRankingViewModel>(
      builder: (context, vm, _) {
        final results = vm.results;
        final top3 = results.take(3).toList();
        final rest = results.skip(3).toList();

        return Scaffold(
          backgroundColor: AppColors.bgBase,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.bgPanel,
            elevation: 0,
            title: const Text(
              'BẢNG XẾP HẠNG (LEADERBOARD)',
              style: TextStyle(
                fontFamily: 'Chakra Petch',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          body: vm.isLoading && results.isEmpty
              ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
              : results.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.emoji_events_outlined, size: 64, color: AppColors.textMuted),
                            const SizedBox(height: 16),
                            const Text(
                              'BẢNG XẾP HẠNG CHƯA CÔNG BỐ',
                              style: TextStyle(fontFamily: 'Chakra Petch', fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Ban tổ chức đang tổng hợp điểm từ Ban Giám khảo. Kết quả chính thức sẽ được công bố sớm nhất.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontFamily: 'Sora', fontSize: 13, color: AppColors.textMuted),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        const Text(
                          'MOBILE PODIUM — TOP 3',
                          style: TextStyle(fontFamily: 'Chakra Petch', fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primary),
                        ),
                        const SizedBox(height: 10),

                        // Vertical Podium for Top 3
                        ...top3.map((item) {
                          final isRank1 = item.rank == 1;
                          final teamName = item.teamName ?? 'TEAM ${item.teamId}';
                          return ClippedContainer(
                            margin: const EdgeInsets.only(bottom: 10),
                            backgroundColor: isRank1 ? AppColors.surfaceContainerHigh : AppColors.bgPanel,
                            borderColor: isRank1 ? AppColors.primary : AppColors.borderMuted,
                            borderWidth: isRank1 ? 2.0 : 1.0,
                            padding: const EdgeInsets.all(14),
                            child: InkWell(
                              onTap: () => _showScoreDetailBottomSheet(context, teamName, item.rank, item.finalScore),
                              child: Row(
                                children: [
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: isRank1 ? AppColors.primary : AppColors.surfaceContainer,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '#${item.rank}',
                                        style: TextStyle(
                                          fontFamily: 'JetBrains Mono',
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: isRank1 ? AppColors.bgBase : AppColors.textPrimary,
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
                                          teamName,
                                          style: TextStyle(
                                            fontFamily: 'Chakra Petch',
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: isRank1 ? AppColors.primary : AppColors.textPrimary,
                                          ),
                                        ),
                                        Text(
                                          'Hạng mục: ${item.trackName ?? "Chung"}',
                                          style: const TextStyle(fontFamily: 'Sora', fontSize: 11, color: AppColors.textMuted),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '${item.finalScore} pts',
                                    style: const TextStyle(fontFamily: 'JetBrains Mono', fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),

                        if (rest.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          const Text(
                            'DANH SÁCH ĐỘI CÒN LẠI',
                            style: TextStyle(fontFamily: 'Chakra Petch', fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textMuted),
                          ),
                          const SizedBox(height: 10),
                          ...rest.map((item) {
                            final teamName = item.teamName ?? 'TEAM ${item.teamId}';
                            return HudCard(
                              margin: const EdgeInsets.only(bottom: 8),
                              onTap: () => _showScoreDetailBottomSheet(context, teamName, item.rank, item.finalScore),
                              child: Row(
                                children: [
                                  Text(
                                    '#${item.rank}',
                                    style: const TextStyle(fontFamily: 'JetBrains Mono', fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textMuted),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      teamName,
                                      style: const TextStyle(fontFamily: 'Sora', fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                                    ),
                                  ),
                                  Text(
                                    '${item.finalScore} pts',
                                    style: const TextStyle(fontFamily: 'JetBrains Mono', fontSize: 14, color: AppColors.textPrimary),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ],
                    ),
        );
      },
    );
  }
}
