import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/di/locator.dart';
import '../../../app/router/route_names.dart';
import '../../../app/theme/app_colors.dart';
import '../../common/widgets/hud_card.dart';
import '../../common/widgets/status_chip.dart';
import '../viewmodels/home_viewmodel.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeViewModel>(
      create: (_) => locator<HomeViewModel>()..initHome(),
      child: const _HomeBody(),
    );
  }
}

class _HomeBody extends StatefulWidget {
  const _HomeBody();

  @override
  State<_HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<_HomeBody> {
  Timer? _timer;
  Duration _remainingTime = const Duration(hours: 18, minutes: 45, seconds: 30);

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime.inSeconds > 0) {
        if (mounted) {
          setState(() {
            _remainingTime = _remainingTime - const Duration(seconds: 1);
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(d.inHours);
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final isWarningCountdown = _remainingTime.inHours < 24;

    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // C1 Countdown Card (Bento stack top item)
            HudCard(
              accentBarColor: isWarningCountdown ? AppColors.statusDanger : AppColors.primary,
              borderColor: isWarningCountdown ? AppColors.statusDanger.withValues(alpha: 0.6) : AppColors.borderMuted,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'HẠN NỘP BÀI GẦN NHẤT',
                        style: TextStyle(
                          fontFamily: 'Chakra Petch',
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textMuted,
                        ),
                      ),
                      StatusChip(
                        label: isWarningCountdown ? 'URGENT < 24H' : 'OPEN',
                        variant: isWarningCountdown ? StatusChipVariant.danger : StatusChipVariant.info,
                        fontSize: 9,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatDuration(_remainingTime),
                    style: TextStyle(
                      fontFamily: 'JetBrains Mono',
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: isWarningCountdown ? AppColors.statusDanger : AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Vòng 1: Ý Tưởng Sản Phẩm (Track AI & IoT)',
                    style: TextStyle(fontFamily: 'Sora', fontSize: 13, color: AppColors.textPrimary),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Team Summary Card
            HudCard(
              accentBarColor: AppColors.accentTeam,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'MY TEAM HUB',
                        style: TextStyle(
                          fontFamily: 'Chakra Petch',
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.accentTeam,
                        ),
                      ),
                      StatusChip(
                        label: 'VERIFIED TEAM',
                        variant: StatusChipVariant.success,
                        fontSize: 9,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'CYBER OPERATIVES',
                    style: TextStyle(
                      fontFamily: 'Chakra Petch',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Thành viên: 4 / 5  •  Trưởng nhóm: Lê Văn A',
                    style: TextStyle(fontFamily: 'Sora', fontSize: 13, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              'QUICK ACTIONS',
              style: TextStyle(
                fontFamily: 'Chakra Petch',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),

            // Quick Links Stack
            Row(
              children: [
                Expanded(
                  child: HudCard(
                    onTap: () => Navigator.of(context).pushNamed(RouteNames.eventList),
                    child: const Column(
                      children: [
                        Icon(Icons.event, color: AppColors.primary, size: 28),
                        SizedBox(height: 8),
                        Text(
                          'Sự kiện',
                          style: TextStyle(fontFamily: 'Sora', fontSize: 13, color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: HudCard(
                    onTap: () => Navigator.of(context).pushNamed(RouteNames.submissionList),
                    child: const Column(
                      children: [
                        Icon(Icons.upload_file, color: AppColors.primary, size: 28),
                        SizedBox(height: 8),
                        Text(
                          'Nộp bài',
                          style: TextStyle(fontFamily: 'Sora', fontSize: 13, color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: HudCard(
                    onTap: () => Navigator.of(context).pushNamed(RouteNames.leaderboard),
                    child: const Column(
                      children: [
                        Icon(Icons.emoji_events, color: AppColors.primary, size: 28),
                        SizedBox(height: 8),
                        Text(
                          'Xem BXH',
                          style: TextStyle(fontFamily: 'Sora', fontSize: 13, color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
