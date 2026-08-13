import 'package:flutter/material.dart';
import '../../../app/router/route_names.dart';
import '../../../app/theme/app_colors.dart';
import '../../common/widgets/app_button.dart';
import '../../common/widgets/hud_card.dart';
import '../../common/widgets/status_chip.dart';

enum TeamUserState { unassigned, member, leader }

class MyTeamView extends StatefulWidget {
  const MyTeamView({super.key});

  @override
  State<MyTeamView> createState() => _MyTeamViewState();
}

class _MyTeamViewState extends State<MyTeamView> {
  TeamUserState _userState = TeamUserState.leader; // Dynamic state demo
  final String _lastRejectReason = 'Trưởng nhóm chưa đủ 3 thành viên chính thức';
  final int _memberCount = 4;
  final bool _allMembersVerified = true;

  void _showLeaveConfirmDialog() {
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
            onPressed: () {
              Navigator.of(ctx).pop();
              setState(() => _userState = TeamUserState.unassigned);
            },
            child: const Text('RỜI ĐỘI', style: TextStyle(fontFamily: 'Sora', color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showConfirmRegistrationDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgPanel,
        title: const Text('CHỐT ĐĂNG KÝ ĐỘI THI', style: TextStyle(fontFamily: 'Chakra Petch', color: AppColors.primary)),
        content: const Text('Sau khi chốt đăng ký, danh sách thành viên sẽ bị khóa và không thể thay đổi.', style: TextStyle(fontFamily: 'Sora', color: AppColors.textPrimary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('HỦY', style: TextStyle(fontFamily: 'Sora', color: AppColors.textMuted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã chốt đăng ký đội thi thành công!'), backgroundColor: AppColors.statusSuccess),
              );
            },
            child: const Text('XÁC NHẬN CHỐT', style: TextStyle(fontFamily: 'Sora', color: AppColors.bgBase)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      appBar: AppBar(
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
          PopupMenuButton<TeamUserState>(
            icon: const Icon(Icons.tune, color: AppColors.primary),
            color: AppColors.bgPanel,
            onSelected: (state) => setState(() => _userState = state),
            itemBuilder: (_) => const [
              PopupMenuItem(value: TeamUserState.unassigned, child: Text('Demo: Unassigned', style: TextStyle(color: AppColors.textPrimary))),
              PopupMenuItem(value: TeamUserState.member, child: Text('Demo: Member State', style: TextStyle(color: AppColors.textPrimary))),
              PopupMenuItem(value: TeamUserState.leader, child: Text('Demo: Leader State', style: TextStyle(color: AppColors.textPrimary))),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_userState == TeamUserState.unassigned) ...[
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
                              onPressed: () => setState(() => _userState = TeamUserState.leader),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: AppButton(
                              label: '[ VÀO ĐỘI ]',
                              variant: AppButtonVariant.secondary,
                              onPressed: () => setState(() => _userState = TeamUserState.member),
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      // Warning Banner for LastRejectReason (C6 Leader spec)
                      if (_userState == TeamUserState.leader)
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
                                        'CẢNH BÁO LẦN TỪ CHỐI GẦN NHẤT',
                                        style: TextStyle(fontFamily: 'Chakra Petch', fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.statusDanger),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        _lastRejectReason,
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
                                const Text(
                                  'ĐỘI THI :: CYBER OPERATIVES',
                                  style: TextStyle(fontFamily: 'Chakra Petch', fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.accentTeam),
                                ),
                                StatusChip(
                                  label: _userState == TeamUserState.leader ? 'LEADER' : 'MEMBER',
                                  variant: StatusChipVariant.role,
                                  fontSize: 9,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Mã tham gia: TEAM-8821',
                              style: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 13, color: AppColors.primary),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Roster Card (Tapping opens C7 Team Roster & Invite if Leader)
                      HudCard(
                        onTap: _userState == TeamUserState.leader
                            ? () => Navigator.of(context).pushNamed(RouteNames.teamRoster)
                            : null,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('DANH SÁCH THÀNH VIÊN', style: TextStyle(fontFamily: 'Chakra Petch', fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                                if (_userState == TeamUserState.leader)
                                  const Row(
                                    children: [
                                      Text('QUẢN LÝ', style: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 11, color: AppColors.primary)),
                                      Icon(Icons.chevron_right, size: 16, color: AppColors.primary),
                                    ],
                                  ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            _buildMemberRow('Lê Văn A', 'Trưởng nhóm', true),
                            const Divider(color: AppColors.borderMuted, height: 16),
                            _buildMemberRow('Nguyễn Văn B', 'Thành viên', true),
                            const Divider(color: AppColors.borderMuted, height: 16),
                            _buildMemberRow('Trần Thị C', 'Thành viên', true),
                            const Divider(color: AppColors.borderMuted, height: 16),
                            _buildMemberRow('Phạm Văn D', 'Thành viên', true),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Bottom Actions by Role State
            if (_userState == TeamUserState.member)
              Container(
                padding: const EdgeInsets.all(12),
                color: AppColors.bgPanel,
                child: OutlinedButton(
                  onPressed: _showLeaveConfirmDialog,
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
            else if (_userState == TeamUserState.leader)
              Container(
                padding: const EdgeInsets.all(12),
                color: AppColors.bgPanel,
                child: AppButton(
                  label: '[ CHỐT ĐĂNG KÝ ]',
                  isEnabled: _memberCount >= 3 && _allMembersVerified,
                  onPressed: _showConfirmRegistrationDialog,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberRow(String name, String role, bool verified) {
    return Row(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: AppColors.surfaceContainerHigh,
          child: Text(name[0], style: const TextStyle(fontFamily: 'Sora', fontSize: 12, color: AppColors.textPrimary)),
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
