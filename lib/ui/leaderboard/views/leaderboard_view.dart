import 'package:flutter/material.dart';
import '../../../app/router/route_names.dart';
import '../../../app/theme/app_colors.dart';
import '../../common/widgets/clipped_container.dart';
import '../../common/widgets/hud_card.dart';
import '../../common/widgets/status_chip.dart';

class LeaderboardView extends StatelessWidget {
  const LeaderboardView({super.key});

  void _showScoreDetailBottomSheet(BuildContext context, Map<String, dynamic> team) {
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
                Text(
                  team['name'],
                  style: const TextStyle(fontFamily: 'Chakra Petch', fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
                StatusChip(label: 'RANK #${team['rank']}', variant: StatusChipVariant.info, fontSize: 10),
              ],
            ),
            const SizedBox(height: 16),
            const Text('CHI TIẾT ĐIỂM SỐ THEO TIÊU CHÍ:', style: TextStyle(fontFamily: 'Chakra Petch', fontSize: 13, color: AppColors.textMuted)),
            const SizedBox(height: 10),
            _buildScoreRow('1. Tính sáng tạo & Đổi mới (30%)', '28.5 / 30'),
            _buildScoreRow('2. Kiến trúc & Công nghệ (40%)', '37.0 / 40'),
            _buildScoreRow('3. Thuyết trình & Demo (30%)', '27.0 / 30'),
            const Divider(color: AppColors.borderMuted, height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('TỔNG ĐIỂM:', style: TextStyle(fontFamily: 'Chakra Petch', fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                Text('${team['score']} pts', style: const TextStyle(fontFamily: 'JetBrains Mono', fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary)),
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
    final List<Map<String, dynamic>> top3 = [
      {'rank': 1, 'name': 'CYBER OPERATIVES', 'score': '92.5', 'change': '+2'},
      {'rank': 2, 'name': 'NEURAL NEXUS', 'score': '90.0', 'change': '0'},
      {'rank': 3, 'name': 'QUANTUM FORGE', 'score': '88.5', 'change': '-1'},
    ];

    final List<Map<String, dynamic>> rest = [
      {'rank': 4, 'name': 'BYTE BUILDERS', 'score': '85.0', 'change': '+1'},
      {'rank': 5, 'name': 'CODE DEVILS', 'score': '82.0', 'change': '-2'},
      {'rank': 6, 'name': 'BINARY SQUAD', 'score': '79.5', 'change': '0'},
    ];

    return Scaffold(
      backgroundColor: AppColors.bgBase,
      appBar: AppBar(
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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'MOBILE PODIUM — TOP 3',
            style: TextStyle(fontFamily: 'Chakra Petch', fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primary),
          ),
          const SizedBox(height: 10),

          // Vertical Podium for Top 3 (C12 spec: rank 1 top with glow)
          ...top3.map((item) {
            final isRank1 = item['rank'] == 1;
            return ClippedContainer(
              margin: const EdgeInsets.only(bottom: 10),
              backgroundColor: isRank1 ? AppColors.surfaceContainerHigh : AppColors.bgPanel,
              borderColor: isRank1 ? AppColors.primary : AppColors.borderMuted,
              borderWidth: isRank1 ? 2.0 : 1.0,
              padding: const EdgeInsets.all(14),
              child: InkWell(
                onTap: () => _showScoreDetailBottomSheet(context, item),
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
                          '#${item['rank']}',
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
                            item['name'],
                            style: TextStyle(
                              fontFamily: 'Chakra Petch',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: isRank1 ? AppColors.primary : AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'Thứ hạng thay đổi: ${item['change']}',
                            style: const TextStyle(fontFamily: 'Sora', fontSize: 11, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${item['score']} pts',
                      style: const TextStyle(fontFamily: 'JetBrains Mono', fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 16),
          const Text(
            'DANH SÁCH ĐỘI CÒN LẠI',
            style: TextStyle(fontFamily: 'Chakra Petch', fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textMuted),
          ),
          const SizedBox(height: 10),

          ...rest.map((item) {
            return HudCard(
              margin: const EdgeInsets.only(bottom: 8),
              onTap: () => _showScoreDetailBottomSheet(context, item),
              child: Row(
                children: [
                  Text(
                    '#${item['rank']}',
                    style: const TextStyle(fontFamily: 'JetBrains Mono', fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textMuted),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      item['name'],
                      style: const TextStyle(fontFamily: 'Sora', fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                  ),
                  Text(
                    '${item['score']} pts',
                    style: const TextStyle(fontFamily: 'JetBrains Mono', fontSize: 14, color: AppColors.textPrimary),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
