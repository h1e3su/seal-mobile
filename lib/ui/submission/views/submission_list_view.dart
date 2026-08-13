import 'package:flutter/material.dart';
import '../../../app/router/route_names.dart';
import '../../../app/theme/app_colors.dart';
import '../../common/widgets/hud_card.dart';
import '../../common/widgets/status_chip.dart';

class SubmissionListView extends StatelessWidget {
  const SubmissionListView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> tracks = [
      {
        'track': 'Track 1: AI & Data Science',
        'round': 'Vòng 1: Ý tưởng & Kiến trúc',
        'status': 'SUBMITTED',
        'countdown': 'Còn 05h 20m',
        'isSubmitted': true,
      },
      {
        'track': 'Track 2: IoT & Embedded Hardware',
        'round': 'Vòng 1: Prototype Demo',
        'status': 'NOT_SUBMITTED',
        'countdown': 'Còn 18h 45m',
        'isSubmitted': false,
      },
      {
        'track': 'Track 3: Blockchain Security',
        'round': 'Vòng sơ loại',
        'status': 'GRADED',
        'score': '88.5 / 100',
        'isSubmitted': true,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.bgBase,
      appBar: AppBar(
        backgroundColor: AppColors.bgPanel,
        elevation: 0,
        title: const Text(
          'DANH SÁCH BÀI NỘP',
          style: TextStyle(
            fontFamily: 'Chakra Petch',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tracks.length,
        itemBuilder: (ctx, index) {
          final item = tracks[index];
          final isSubmitted = item['isSubmitted'] as bool;
          final isGraded = item['status'] == 'GRADED';

          return HudCard(
            margin: const EdgeInsets.only(bottom: 12),
            accentBarColor: isGraded ? AppColors.accentMentor : (isSubmitted ? AppColors.statusSuccess : AppColors.statusWarning),
            onTap: () {
              if (isSubmitted) {
                Navigator.of(context).pushNamed(RouteNames.submissionDetail);
              } else {
                Navigator.of(context).pushNamed(RouteNames.submitEntry);
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item['track'],
                        style: const TextStyle(
                          fontFamily: 'Chakra Petch',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    StatusChip(
                      label: isGraded ? 'ĐÃ CHẤM' : (isSubmitted ? 'ĐÃ NỘP' : 'CHƯA NỘP'),
                      variant: isGraded ? StatusChipVariant.info : (isSubmitted ? StatusChipVariant.success : StatusChipVariant.warning),
                      fontSize: 9,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(item['round'], style: const TextStyle(fontFamily: 'Sora', fontSize: 13, color: AppColors.textMuted)),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (item['countdown'] != null)
                      Row(
                        children: [
                          const Icon(Icons.timer_outlined, size: 14, color: AppColors.primary),
                          const SizedBox(width: 4),
                          Text(item['countdown'], style: const TextStyle(fontFamily: 'JetBrains Mono', fontSize: 12, color: AppColors.primary)),
                        ],
                      ),
                    if (item['score'] != null)
                      Text('Điểm: ${item['score']}', style: const TextStyle(fontFamily: 'JetBrains Mono', fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primary)),
                    const Icon(Icons.chevron_right, color: AppColors.primary, size: 18),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
