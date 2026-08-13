import 'package:flutter/material.dart';
import '../../../app/router/route_names.dart';
import '../../../app/theme/app_colors.dart';
import '../../common/widgets/hud_card.dart';
import '../../common/widgets/status_chip.dart';

class TeamsInTrackView extends StatelessWidget {
  const TeamsInTrackView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> teams = [
      {
        'name': 'CYBER OPERATIVES',
        'status': 'SUBMITTED',
        'members': ['Lê Văn A', 'Nguyễn Văn B', 'Trần Thị C', 'Phạm Văn D'],
      },
      {
        'name': 'NEURAL NEXUS',
        'status': 'SUBMITTED',
        'members': ['Hoàng A', 'Đỗ B', 'Vũ C'],
      },
      {
        'name': 'QUANTUM FORGE',
        'status': 'PENDING_SUBMISSION',
        'members': ['Ngô A', 'Đặng B', 'Lý C', 'Bùi D', 'Dương E'],
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.bgBase,
      appBar: AppBar(
        backgroundColor: AppColors.bgPanel,
        elevation: 0,
        title: const Text(
          'TEAMS IN TRACK',
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
        itemCount: teams.length,
        itemBuilder: (ctx, index) {
          final t = teams[index];
          final isSubmitted = t['status'] == 'SUBMITTED';
          final List<String> members = List<String>.from(t['members']);

          return HudCard(
            margin: const EdgeInsets.only(bottom: 12),
            accentBarColor: isSubmitted ? AppColors.accentMentor : AppColors.statusWarning,
            onTap: () => Navigator.of(context).pushNamed(RouteNames.teamViewer),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      t['name'],
                      style: const TextStyle(fontFamily: 'Chakra Petch', fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    StatusChip(
                      label: isSubmitted ? 'ĐÃ NỘP BÀI' : 'CHƯA NỘP',
                      variant: isSubmitted ? StatusChipVariant.success : StatusChipVariant.warning,
                      fontSize: 9,
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Avatar Stack of Members (M3 spec: max 5, +N)
                Row(
                  children: [
                    ...members.take(4).map((m) => Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: CircleAvatar(
                            radius: 12,
                            backgroundColor: AppColors.surfaceContainerHigh,
                            child: Text(m[0], style: const TextStyle(fontFamily: 'Sora', fontSize: 10, color: AppColors.textPrimary)),
                          ),
                        )),
                    if (members.length > 4)
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: AppColors.bgInput,
                        child: Text('+${members.length - 4}', style: const TextStyle(fontFamily: 'JetBrains Mono', fontSize: 10, color: AppColors.primary)),
                      ),
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
