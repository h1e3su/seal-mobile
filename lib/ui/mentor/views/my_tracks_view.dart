import 'package:flutter/material.dart';
import '../../../app/router/route_names.dart';
import '../../../app/theme/app_colors.dart';
import '../../common/widgets/hud_card.dart';
import '../../common/widgets/status_chip.dart';

class MyTracksView extends StatelessWidget {
  const MyTracksView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> tracks = [
      {
        'name': 'Track 1: AI & Machine Learning Innovations',
        'event': 'SEAL Hackathon 2026 - Vòng 1',
        'teamsCount': 8,
      },
      {
        'name': 'Track 2: Smart IoT & Embedded Systems',
        'event': 'SEAL Hackathon 2026 - Vòng 1',
        'teamsCount': 6,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.bgBase,
      appBar: AppBar(
        backgroundColor: AppColors.bgPanel,
        elevation: 0,
        title: const Text(
          'MY ASSIGNED TRACKS',
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
          final t = tracks[index];
          return HudCard(
            margin: const EdgeInsets.only(bottom: 12),
            accentBarColor: AppColors.accentMentor,
            onTap: () => Navigator.of(context).pushNamed(RouteNames.teamsInTrack),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        t['name'],
                        style: const TextStyle(
                          fontFamily: 'Chakra Petch',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const StatusChip(
                      label: 'ASSIGNED',
                      variant: StatusChipVariant.info,
                      customColor: AppColors.accentMentor,
                      fontSize: 9,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(t['event'], style: const TextStyle(fontFamily: 'Sora', fontSize: 13, color: AppColors.textMuted)),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Số đội thi: ${t['teamsCount']} đội', style: const TextStyle(fontFamily: 'JetBrains Mono', fontSize: 13, color: AppColors.primary)),
                    const Icon(Icons.chevron_right, color: AppColors.accentMentor),
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
