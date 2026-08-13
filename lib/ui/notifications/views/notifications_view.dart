import 'package:flutter/material.dart';
import '../../../app/router/route_names.dart';
import '../../../app/theme/app_colors.dart';
import '../../common/widgets/hud_card.dart';
import '../../team/widgets/team_invite_bottom_sheet.dart';
import '../../mentor/widgets/mentor_role_invite_bottom_sheet.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  final List<Map<String, dynamic>> _notifs = [
    {
      'type': 'TEAM_INVITE',
      'title': 'Lời mời tham gia đội thi',
      'body': 'Lê Văn A đã mời bạn vào đội CYBER OPERATIVES',
      'time': '10 phút trước',
      'isRead': false,
      'icon': Icons.group_add,
    },
    {
      'type': 'MENTOR_INVITE',
      'title': 'Lời mời làm Mentor',
      'body': 'BTC đã mời bạn làm Mentor cho Track AI Hackathon 2026',
      'time': '1 giờ trước',
      'isRead': false,
      'icon': Icons.psychology,
    },
    {
      'type': 'GRADE_RESULT',
      'title': 'Đã có kết quả chấm bài Vòng 1',
      'body': 'Đội của bạn đạt 92.5 điểm, xem xếp hạng ngay',
      'time': '2 giờ trước',
      'isRead': true,
      'icon': Icons.emoji_events,
    },
    {
      'type': 'DEADLINE',
      'title': 'Sắp hết hạn nộp bài Vòng 1',
      'body': 'Còn lại 18h 45m trước khi cổng nộp bài đóng',
      'time': '5 giờ trước',
      'isRead': true,
      'icon': Icons.timer,
    },
  ];

  void _onNotificationTap(Map<String, dynamic> item) {
    setState(() => item['isRead'] = true);
    final type = item['type'];

    if (type == 'TEAM_INVITE') {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (_) => const TeamInviteBottomSheet(),
      );
    } else if (type == 'MENTOR_INVITE') {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (_) => const MentorRoleInviteBottomSheet(),
      );
    } else if (type == 'GRADE_RESULT') {
      Navigator.of(context).pushNamed(RouteNames.leaderboard);
    } else if (type == 'DEADLINE') {
      Navigator.of(context).pushNamed(RouteNames.submissionList);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      appBar: AppBar(
        backgroundColor: AppColors.bgPanel,
        elevation: 0,
        title: const Text(
          'NOTIFICATIONS CENTER',
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
        itemCount: _notifs.length,
        itemBuilder: (ctx, index) {
          final item = _notifs[index];
          final isRead = item['isRead'] as bool;

          return HudCard(
            margin: const EdgeInsets.only(bottom: 12),
            accentBarColor: isRead ? AppColors.borderMuted : AppColors.primary,
            onTap: () => _onNotificationTap(item),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(item['icon'], color: isRead ? AppColors.textMuted : AppColors.primary, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item['title'],
                              style: TextStyle(
                                fontFamily: 'Chakra Petch',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: isRead ? AppColors.textMuted : AppColors.textPrimary,
                              ),
                            ),
                          ),
                          if (!isRead)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(item['body'], style: const TextStyle(fontFamily: 'Sora', fontSize: 13, color: AppColors.textPrimary)),
                      const SizedBox(height: 6),
                      Text(item['time'], style: const TextStyle(fontFamily: 'JetBrains Mono', fontSize: 11, color: AppColors.textMuted)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
