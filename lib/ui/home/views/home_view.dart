import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/di/locator.dart';
import '../../../app/router/route_names.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/utils/student_verification_guard.dart';
import '../../common/widgets/hud_card.dart';
import '../../common/widgets/status_chip.dart';
import '../../profile/viewmodels/profile_viewmodel.dart';
import '../../team/viewmodels/team_viewmodel.dart';
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileViewModel>().fetchProfile();
      context.read<TeamViewModel>().loadMyTeam();
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
    final profileVm = context.watch<ProfileViewModel>();
    final teamVm = context.watch<TeamViewModel>();
    final profile = profileVm.profile;
    final team = teamVm.myTeam;
    final isPending = profile?.isPending ?? false;
    final isApproved = profile?.isApproved ?? false;

    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Banner for Student Verification
            if (isPending)
              GestureDetector(
                onTap: () => Navigator.of(context).pushNamed(RouteNames.profileVerification),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.statusWarning.withValues(alpha: 0.15),
                    border: Border.all(color: AppColors.statusWarning),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.hourglass_top, color: AppColors.statusWarning, size: 20),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'HỒ SƠ ĐANG ĐƯỢC BAN TỔ CHỨC PHÊ DUYỆT',
                              style: TextStyle(
                                fontFamily: 'Chakra Petch',
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.statusWarning,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Vui lòng chờ BTC xác thực trước khi tạo đội hoặc tham gia sự kiện.',
                              style: TextStyle(fontFamily: 'Sora', fontSize: 11, color: AppColors.textPrimary),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right, color: AppColors.statusWarning, size: 18),
                    ],
                  ),
                ),
              )
            else if (!isApproved)
              GestureDetector(
                onTap: () => Navigator.of(context).pushNamed(RouteNames.profileVerification),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    border: Border.all(color: AppColors.primary),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.verified_user_outlined, color: AppColors.primary, size: 20),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CHƯA XÁC MINH HỒ SƠ SINH VIÊN',
                              style: TextStyle(
                                fontFamily: 'Chakra Petch',
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Chạm để xác minh hồ sơ sinh viên để đủ điều kiện thi đấu.',
                              style: TextStyle(fontFamily: 'Sora', fontSize: 11, color: AppColors.textPrimary),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right, color: AppColors.primary, size: 18),
                    ],
                  ),
                ),
              ),

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
              onTap: () async {
                final canProceed = await StudentVerificationGuard.ensureVerified(
                  context,
                  profileVm,
                  actionName: 'quản lý đội thi',
                );
                if (canProceed && context.mounted) {
                  Navigator.of(context).pushNamed(RouteNames.myTeam);
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'MY TEAM HUB',
                        style: TextStyle(
                          fontFamily: 'Chakra Petch',
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.accentTeam,
                        ),
                      ),
                      StatusChip(
                        label: team != null ? (team.isConfirmed ? 'REGISTERED' : 'FORMING') : 'UNASSIGNED',
                        variant: team != null && team.isConfirmed ? StatusChipVariant.success : StatusChipVariant.warning,
                        fontSize: 9,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    team?.name.toUpperCase() ?? 'CHƯA CÓ ĐỘI THI',
                    style: const TextStyle(
                      fontFamily: 'Chakra Petch',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    team != null
                        ? 'Thành viên: ${team.memberCount}  •  ${team.isLeader ? "Bạn là Trưởng nhóm" : "Thành viên"}'
                        : 'Chạm để tạo đội hoặc tham gia đội thi',
                    style: const TextStyle(fontFamily: 'Sora', fontSize: 13, color: AppColors.textMuted),
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
                    onTap: () async {
                      final canProceed = await StudentVerificationGuard.ensureVerified(
                        context,
                        profileVm,
                        actionName: 'nộp bài dự thi',
                      );
                      if (canProceed && context.mounted) {
                        Navigator.of(context).pushNamed(RouteNames.submissionList);
                      }
                    },
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
