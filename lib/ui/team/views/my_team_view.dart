import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/router/route_names.dart';
import '../../../app/theme/app_colors.dart';
import '../../common/widgets/app_button.dart';
import '../../common/widgets/hud_card.dart';
import '../../common/widgets/status_chip.dart';
import '../../../core/utils/student_verification_guard.dart';
import '../../profile/viewmodels/profile_viewmodel.dart';
import '../viewmodels/team_viewmodel.dart';

class MyTeamView extends StatefulWidget {
  const MyTeamView({super.key});

  @override
  State<MyTeamView> createState() => _MyTeamViewState();
}

class _MyTeamViewState extends State<MyTeamView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TeamViewModel>().loadMyTeam();
    });
  }

  void _showLeaveConfirmDialog(BuildContext context, TeamViewModel vm) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgPanel,
        title: const Text('XÁC NHẬN RỜI ĐỘI', style: TextStyle(fontFamily: 'Chakra Petch', color: AppColors.statusDanger)),
        content: const Text('Bạn có chắc chắn muốn rời khỏi đội thi hiện tại không?', style: TextStyle(fontFamily: 'Sora', color: AppColors.textPrimary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('HỦY BỎ', style: TextStyle(fontFamily: 'Sora', color: AppColors.textMuted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.statusDanger),
            onPressed: () async {
              Navigator.of(ctx).pop();
              final success = await vm.leaveTeam();
              if (success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã rời khỏi đội thi thành công!'), backgroundColor: AppColors.statusSuccess),
                );
              }
            },
            child: const Text('RỜI ĐỘI', style: TextStyle(fontFamily: 'Sora', color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showConfirmRegistrationDialog(BuildContext context, TeamViewModel vm) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgPanel,
        title: const Text('CHỐT ĐĂNG KÝ ĐỘI THI', style: TextStyle(fontFamily: 'Chakra Petch', color: AppColors.primary)),
        content: const Text('Sau khi chốt đăng ký, danh sách thành viên sẽ bị khóa và chuyển sang chờ BTC phê duyệt.', style: TextStyle(fontFamily: 'Sora', color: AppColors.textPrimary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('HỦY', style: TextStyle(fontFamily: 'Sora', color: AppColors.textMuted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () async {
              Navigator.of(ctx).pop();
              final success = await vm.confirmRegistration();
              if (success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã chốt đăng ký đội thi thành công! Vui lòng chờ BTC duyệt.'), backgroundColor: AppColors.statusSuccess),
                );
              } else if (context.mounted && vm.errorMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(vm.errorMessage!), backgroundColor: AppColors.statusDanger),
                );
              }
            },
            child: const Text('XÁC NHẬN CHỐT', style: TextStyle(fontFamily: 'Sora', color: AppColors.bgBase)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TeamViewModel>(
      builder: (context, vm, _) {
        final team = vm.myTeam;
        final userState = vm.userState;
        final lastReject = vm.lastRejectReason;

        return Scaffold(
          backgroundColor: AppColors.bgBase,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.bgPanel,
            elevation: 0,
            title: const Text(
              'MY TEAM HUB',
              style: TextStyle(
                fontFamily: 'Chakra Petch',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh, color: AppColors.primary),
                onPressed: () => vm.loadMyTeam(),
              ),
            ],
          ),
          body: SafeArea(
            child: vm.isLoading && team == null
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (userState == TeamUserState.unassigned) ...[
                                const SizedBox(height: 30),
                                const Icon(Icons.groups_outlined, size: 72, color: AppColors.primary),
                                const SizedBox(height: 16),
                                const Text(
                                  'BẠN CHƯA THAM GIA ĐỘI THI NÀO',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontFamily: 'Chakra Petch', fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Hãy tạo đội mới với vai trò Trưởng nhóm hoặc tham gia đội thi bằng mã mời từ bạn bè.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontFamily: 'Sora', fontSize: 13, color: AppColors.textMuted),
                                ),
                                const SizedBox(height: 32),
                                Row(
                                  children: [
                                    Expanded(
                                      child: AppButton(
                                        label: '[ TẠO ĐỘI ]',
                                        onPressed: () async {
                                          final profileVm = context.read<ProfileViewModel>();
                                          final canProceed = await StudentVerificationGuard.ensureVerified(
                                            context,
                                            profileVm,
                                            actionName: 'tạo đội thi',
                                          );
                                          if (canProceed && context.mounted) {
                                            Navigator.of(context).pushNamed(RouteNames.createTeam);
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: AppButton(
                                        label: '[ LỜI MỜI ]',
                                        variant: AppButtonVariant.secondary,
                                        onPressed: () => Navigator.of(context).pushNamed(RouteNames.notifications),
                                      ),
                                    ),
                                  ],
                                ),
                              ] else if (team != null) ...[
                                // Warning Banner for LastRejectReason
                                if (lastReject != null && lastReject.isNotEmpty)
                                  GestureDetector(
                                    onTap: () => Navigator.of(context).pushNamed(RouteNames.rejectionHistory),
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 16),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: AppColors.statusDanger.withValues(alpha: 0.12),
                                        border: Border.all(color: AppColors.statusDanger),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.error_outline, color: AppColors.statusDanger, size: 20),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'LÝ DO TỪ CHỐI GẦN NHẤT',
                                                  style: TextStyle(fontFamily: 'Chakra Petch', fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.statusDanger),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  lastReject,
                                                  style: const TextStyle(fontFamily: 'Sora', fontSize: 12, color: AppColors.textPrimary),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Icon(Icons.chevron_right, color: AppColors.statusDanger),
                                        ],
                                      ),
                                    ),
                                  ),

                                // Team Header Card
                                HudCard(
                                  accentBarColor: AppColors.accentTeam,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              'ĐỘI THI :: ${team.name.toUpperCase()}',
                                              style: const TextStyle(fontFamily: 'Chakra Petch', fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.accentTeam),
                                            ),
                                          ),
                                          StatusChip(
                                            label: team.status.toUpperCase(),
                                            variant: team.isRegistered
                                                ? StatusChipVariant.success
                                                : (team.isPendingApproval ? StatusChipVariant.warning : StatusChipVariant.info),
                                            fontSize: 9,
                                          ),
                                        ],
                                      ),
                                      if (team.description != null && team.description!.isNotEmpty) ...[
                                        const SizedBox(height: 6),
                                        Text(
                                          team.description!,
                                          style: const TextStyle(fontFamily: 'Sora', fontSize: 12, color: AppColors.textMuted),
                                        ),
                                      ],
                                      const SizedBox(height: 8),
                                      Text(
                                        'Vai trò: ${userState == TeamUserState.leader ? "Trưởng nhóm (Leader)" : "Thành viên (Member)"}',
                                        style: const TextStyle(fontFamily: 'JetBrains Mono', fontSize: 12, color: AppColors.primary),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 16),

                                // Roster Card
                                HudCard(
                                  onTap: () => Navigator.of(context).pushNamed(RouteNames.teamRoster),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'THÀNH VIÊN (${team.members.length}/5)',
                                            style: const TextStyle(fontFamily: 'Chakra Petch', fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                                          ),
                                          const Row(
                                            children: [
                                              Text('QUẢN LÝ', style: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 11, color: AppColors.primary)),
                                              Icon(Icons.chevron_right, size: 16, color: AppColors.primary),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      if (team.members.isEmpty)
                                        const Padding(
                                          padding: EdgeInsets.symmetric(vertical: 8),
                                          child: Text('Chưa có danh sách thành viên', style: TextStyle(fontFamily: 'Sora', fontSize: 12, color: AppColors.textMuted)),
                                        )
                                      else
                                        ...team.members.map((m) => Column(
                                              children: [
                                                _buildMemberRow(m.fullName, m.isLeader ? 'Trưởng nhóm' : 'Thành viên', m.isVerified),
                                                if (m != team.members.last)
                                                  const Divider(color: AppColors.borderMuted, height: 16),
                                              ],
                                            )),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),

                      // Bottom Actions by Role State
                      if (userState == TeamUserState.member && team != null && !team.isRegistered)
                        Container(
                          padding: const EdgeInsets.all(12),
                          color: AppColors.bgPanel,
                          child: OutlinedButton(
                            onPressed: () => _showLeaveConfirmDialog(context, vm),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.statusDanger),
                              minimumSize: const Size(double.infinity, 48),
                            ),
                            child: const Text(
                              'RỜI ĐỘI THI',
                              style: TextStyle(fontFamily: 'Chakra Petch', fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.statusDanger),
                            ),
                          ),
                        )
                      else if (userState == TeamUserState.leader && team != null && team.isForming)
                        Container(
                          padding: const EdgeInsets.all(12),
                          color: AppColors.bgPanel,
                          child: AppButton(
                            label: '[ CHỐT ĐĂNG KÝ ]',
                            isEnabled: vm.canConfirmRegistration,
                            onPressed: () => _showConfirmRegistrationDialog(context, vm),
                          ),
                        ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  Widget _buildMemberRow(String name, String role, bool verified) {
    return Row(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: AppColors.surfaceContainerHigh,
          child: Text(name.isNotEmpty ? name[0] : 'U', style: const TextStyle(fontFamily: 'Sora', fontSize: 12, color: AppColors.textPrimary)),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontFamily: 'Sora', fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              Text(role, style: const TextStyle(fontFamily: 'Sora', fontSize: 11, color: AppColors.textMuted)),
            ],
          ),
        ),
        StatusChip(
          label: verified ? 'VERIFIED' : 'UNVERIFIED',
          variant: verified ? StatusChipVariant.success : StatusChipVariant.warning,
          fontSize: 8,
        ),
      ],
    );
  }
}
