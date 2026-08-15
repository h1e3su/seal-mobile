import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/di/locator.dart';
import '../../../app/router/route_names.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/utils/student_verification_guard.dart';
import '../../../data/models/event/event_model.dart';
import '../../common/widgets/app_text_field.dart';
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
  final _searchController = TextEditingController();

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

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<ProfileViewModel>().fetchProfile();
      final homeVm = context.read<HomeViewModel>();
      await homeVm.initHome();
      if (mounted) {
        final activeEventId = homeVm.events.isNotEmpty ? homeVm.events.first.id : null;
        context.read<TeamViewModel>().loadMyTeam(activeEventId);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    final homeVm = context.read<HomeViewModel>();
    await Future.wait([
      context.read<ProfileViewModel>().fetchProfile(),
      homeVm.initHome(),
    ]);
    if (mounted) {
      final activeEventId = homeVm.events.isNotEmpty ? homeVm.events.first.id : null;
      await context.read<TeamViewModel>().loadMyTeam(activeEventId);
    }
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(d.inHours);
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return '';
    final d = dt.day.toString().padLeft(2, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final y = dt.year.toString();
    return '$d/$m/$y';
  }

  String _getEventTimeRange(EventModel event) {
    if (event.startDate != null && event.endDate != null) {
      return '${_formatDate(event.startDate)} - ${_formatDate(event.endDate)}';
    } else if (event.startDate != null) {
      return 'Bắt đầu: ${_formatDate(event.startDate)}';
    }
    return '15/08/2026 - 30/09/2026';
  }

  @override
  Widget build(BuildContext context) {
    final isWarningCountdown = _remainingTime.inHours < 24;
    final profileVm = context.watch<ProfileViewModel>();
    final teamVm = context.watch<TeamViewModel>();
    final homeVm = context.watch<HomeViewModel>();

    final profile = profileVm.profile;
    final team = teamVm.myTeam;
    final isPending = profile?.isPending ?? false;
    final isApproved = profile?.isApproved ?? false;
    final events = homeVm.events;

    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: AppColors.bgPanel,
        onRefresh: _handleRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Status Banner for Student Verification
              if (isPending)
                GestureDetector(
                  onTap: () async {
                    await Navigator.of(context).pushNamed(RouteNames.profileVerification);
                    if (context.mounted) {
                      _handleRefresh();
                    }
                  },
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
                  onTap: () async {
                    await Navigator.of(context).pushNamed(RouteNames.profileVerification);
                    if (context.mounted) {
                      _handleRefresh();
                    }
                  },
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

              const SizedBox(height: 24),

              // EVENT LIST SECTION (C4/Luồng 2)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'DANH SÁCH SỰ KIỆN',
                    style: TextStyle(
                      fontFamily: 'Chakra Petch',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pushNamed(RouteNames.eventList),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Xem tất cả >',
                      style: TextStyle(
                        fontFamily: 'Sora',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Quick Search Events Bar
              AppTextField(
                label: 'Tìm kiếm sự kiện',
                controller: _searchController,
                hint: 'Tìm nhanh theo tên cuộc thi, từ khóa...',
                prefixIcon: Icons.search,
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 16, color: AppColors.textMuted),
                        onPressed: () {
                          _searchController.clear();
                          homeVm.setSearchQuery('');
                        },
                      )
                    : null,
                onChanged: (val) => homeVm.setSearchQuery(val),
              ),
              const SizedBox(height: 12),

              // Event Cards List
              if (homeVm.isLoading && events.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                )
              else if (events.isEmpty)
                HudCard(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        children: [
                          const Icon(Icons.event_note, size: 36, color: AppColors.textMuted),
                          const SizedBox(height: 8),
                          Text(
                            homeVm.searchQuery.isNotEmpty
                                ? 'Không tìm thấy sự kiện nào cho "${homeVm.searchQuery}"'
                                : 'Chưa có sự kiện nào đang diễn ra',
                            style: const TextStyle(
                              fontFamily: 'Sora',
                              fontSize: 13,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                ...events.map((event) {
                  final isOpen = event.isOpen;

                  return HudCard(
                    margin: const EdgeInsets.only(bottom: 12),
                    accentBarColor: isOpen ? AppColors.primary : AppColors.textMuted,
                    onTap: () => Navigator.of(context).pushNamed(
                      RouteNames.eventDetail,
                      arguments: event,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                event.title.toUpperCase(),
                                style: const TextStyle(
                                  fontFamily: 'Chakra Petch',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            StatusChip(
                              label: isOpen ? 'ĐANG MỞ' : 'ĐÃ ĐÓNG',
                              variant: isOpen ? StatusChipVariant.success : StatusChipVariant.danger,
                              fontSize: 9,
                            ),
                          ],
                        ),
                        if (event.description.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            event.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Sora',
                              fontSize: 12,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 13, color: AppColors.primary),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                _getEventTimeRange(event),
                                style: const TextStyle(
                                  fontFamily: 'JetBrains Mono',
                                  fontSize: 11,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ),
                            if (event.totalTeams > 0) ...[
                              const SizedBox(width: 8),
                              const Icon(Icons.groups_outlined, size: 13, color: AppColors.accentTeam),
                              const SizedBox(width: 4),
                              Text(
                                '${event.totalTeams} đội',
                                style: const TextStyle(
                                  fontFamily: 'JetBrains Mono',
                                  fontSize: 11,
                                  color: AppColors.accentTeam,
                                ),
                              ),
                            ],
                          ],
                        ),
                        if (event.location != null && event.location!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined, size: 13, color: AppColors.textMuted),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  event.location!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontFamily: 'Sora',
                                    fontSize: 11,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }
}
