import 'package:flutter/material.dart';
import '../../../app/router/route_names.dart';
import '../../../app/theme/app_colors.dart';
import '../../common/widgets/hud_card.dart';
import '../../common/widgets/status_chip.dart';

class MentorHomeView extends StatelessWidget {
  const MentorHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Bento 1: Assigned Tracks Count
            HudCard(
              accentBarColor: AppColors.accentMentor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'MENTOR DASHBOARD',
                        style: TextStyle(fontFamily: 'Chakra Petch', fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.accentMentor),
                      ),
                      StatusChip(
                        label: 'MENTOR ACTIVE',
                        variant: StatusChipVariant.info,
                        customColor: AppColors.accentMentor,
                        fontSize: 9,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '2 TRACKS PHÂN CÔNG',
                    style: TextStyle(fontFamily: 'Chakra Petch', fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Track 1: AI & Data Science  •  Track 2: IoT Hardware',
                    style: TextStyle(fontFamily: 'Sora', fontSize: 13, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Bento 2: Teams Needing Attention (M1 spec: warning highlighted)
            HudCard(
              accentBarColor: AppColors.statusWarning,
              borderColor: AppColors.statusWarning.withValues(alpha: 0.6),
              onTap: () => Navigator.of(context).pushNamed(RouteNames.teamsInTrack),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'ĐỘI CẦN CHÚ Ý (ATTENTION NEEDED)',
                        style: TextStyle(fontFamily: 'Chakra Petch', fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.statusWarning),
                      ),
                      StatusChip(
                        label: '2 TEAMS URGENT',
                        variant: StatusChipVariant.warning,
                        fontSize: 9,
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    '2 đội thi chưa nộp bài dù còn < 24h hạn nộp',
                    style: TextStyle(fontFamily: 'Sora', fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Chạm để xem danh sách chi tiết các đội thuộc Track >',
                    style: TextStyle(fontFamily: 'Sora', fontSize: 12, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              'TRACK OVERVIEW',
              style: TextStyle(fontFamily: 'Chakra Petch', fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 10),

            HudCard(
              onTap: () => Navigator.of(context).pushNamed(RouteNames.myTracks),
              child: const Row(
                children: [
                  Icon(Icons.alt_route, color: AppColors.accentMentor, size: 28),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Xem danh sách Track được gán', style: TextStyle(fontFamily: 'Chakra Petch', fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                        Text('Xem tổng số 12 đội thi đang tham gia', style: TextStyle(fontFamily: 'Sora', fontSize: 12, color: AppColors.textMuted)),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: AppColors.accentMentor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
