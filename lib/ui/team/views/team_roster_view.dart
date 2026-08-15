import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/theme/app_colors.dart';
import '../../common/widgets/app_button.dart';
import '../../common/widgets/app_text_field.dart';
import '../../common/widgets/hud_card.dart';
import '../../common/widgets/status_chip.dart';
import '../viewmodels/team_viewmodel.dart';

class TeamRosterView extends StatefulWidget {
  const TeamRosterView({super.key});

  @override
  State<TeamRosterView> createState() => _TeamRosterViewState();
}

class _TeamRosterViewState extends State<TeamRosterView> {
  final bool _hasTransferRequest = false;

  void _showInviteBottomSheet(BuildContext context, TeamViewModel vm) {
    final emailController = TextEditingController();
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgPanel,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'MỜI THÀNH VIÊN VÀO ĐỘI',
              style: TextStyle(
                fontFamily: 'Chakra Petch',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: emailController,
              label: 'Email sinh viên được mời',
              hint: 'student@fpt.edu.vn',
              prefixIcon: Icons.email_outlined,
            ),
            const SizedBox(height: 20),
            AppButton(
              label: 'GỬI LỜI MỜI',
              onPressed: () async {
                final email = emailController.text.trim();
                if (email.isEmpty) return;
                Navigator.of(ctx).pop();
                final success = await vm.inviteMember(email);
                if (success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đã gửi lời mời thành công!'), backgroundColor: AppColors.statusSuccess),
                  );
                } else if (context.mounted && vm.errorMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(vm.errorMessage!), backgroundColor: AppColors.statusDanger),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showTransferLeaderDialog(BuildContext context, TeamViewModel vm) {
    final team = vm.myTeam;
    if (team == null) return;
    final otherMembers = team.members.where((m) => !m.isLeader).toList();

    if (otherMembers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Chưa có thành viên khác trong đội để chuyển quyền!'), backgroundColor: AppColors.statusWarning),
      );
      return;
    }

    String selectedUserId = otherMembers.first.userId;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (dialogCtx, setDialogState) => AlertDialog(
          backgroundColor: AppColors.bgPanel,
          title: const Text('CHUYỂN QUYỀN TRƯỞNG NHÓM', style: TextStyle(fontFamily: 'Chakra Petch', color: AppColors.primary)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Chọn thành viên bạn muốn bàn giao quyền Trưởng nhóm:', style: TextStyle(fontFamily: 'Sora', color: AppColors.textPrimary)),
              const SizedBox(height: 12),
              ...otherMembers.map((m) {
                final isSelected = selectedUserId == m.userId;
                return InkWell(
                  onTap: () => setDialogState(() => selectedUserId = m.userId),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : AppColors.bgInput,
                      border: Border.all(color: isSelected ? AppColors.primary : AppColors.borderMuted),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                          color: isSelected ? AppColors.primary : AppColors.textMuted,
                          size: 18,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(m.fullName, style: const TextStyle(fontFamily: 'Sora', color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.bold)),
                              Text(m.email, style: const TextStyle(fontFamily: 'Sora', fontSize: 11, color: AppColors.textMuted)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('HỦY', style: TextStyle(fontFamily: 'Sora', color: AppColors.textMuted)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              onPressed: () async {
                Navigator.of(ctx).pop();
                final success = await vm.transferLeadership(selectedUserId);
                if (success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đã gửi yêu cầu chuyển quyền Trưởng nhóm thành công!'), backgroundColor: AppColors.statusSuccess),
                  );
                }
              },
              child: const Text('XÁC NHẬN CHUYỂN', style: TextStyle(fontFamily: 'Sora', color: AppColors.bgBase)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TeamViewModel>(
      builder: (context, vm, _) {
        final team = vm.myTeam;
        final members = team?.members ?? [];
        final isLeader = vm.isLeader;

        return Scaffold(
          backgroundColor: AppColors.bgBase,
          appBar: AppBar(
            backgroundColor: AppColors.bgPanel,
            elevation: 0,
            title: const Text(
              'ROSTER & INVITES',
              style: TextStyle(
                fontFamily: 'Chakra Petch',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                if (_hasTransferRequest)
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      border: Border.all(color: AppColors.primary),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.hourglass_top, color: AppColors.primary, size: 20),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Yêu cầu chuyển quyền — hết hạn sau 23:45:00',
                            style: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 12, color: AppColors.textPrimary),
                          ),
                        ),
                      ],
                    ),
                  ),

                Expanded(
                  child: members.isEmpty
                      ? const Center(
                          child: Text(
                            'Chưa có thành viên nào trong đội',
                            style: TextStyle(fontFamily: 'Sora', color: AppColors.textMuted),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: members.length,
                          itemBuilder: (ctx, index) {
                            final m = members[index];
                            return Dismissible(
                              key: Key(m.userId.isNotEmpty ? m.userId : index.toString()),
                              direction: (isLeader && !m.isLeader) ? DismissDirection.endToStart : DismissDirection.none,
                              onDismissed: (_) => vm.removeMember(m.userId),
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20),
                                color: AppColors.statusDanger,
                                child: const Icon(Icons.delete, color: Colors.white),
                              ),
                              child: HudCard(
                                margin: const EdgeInsets.only(bottom: 12),
                                accentBarColor: m.isLeader ? AppColors.primary : AppColors.accentTeam,
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: AppColors.surfaceContainerHigh,
                                      child: Text(
                                        m.fullName.isNotEmpty ? m.fullName[0] : 'U',
                                        style: const TextStyle(fontFamily: 'Sora', color: AppColors.textPrimary),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            m.fullName,
                                            style: const TextStyle(fontFamily: 'Sora', fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                                          ),
                                          Text(
                                            m.isLeader ? 'Trưởng nhóm' : 'Thành viên',
                                            style: const TextStyle(fontFamily: 'Sora', fontSize: 12, color: AppColors.textMuted),
                                          ),
                                        ],
                                      ),
                                    ),
                                    StatusChip(
                                      label: m.isVerified ? 'VERIFIED' : 'UNVERIFIED',
                                      variant: m.isVerified ? StatusChipVariant.success : StatusChipVariant.warning,
                                      fontSize: 8,
                                    ),
                                    if (isLeader && !m.isLeader)
                                      IconButton(
                                        icon: const Icon(Icons.close, color: AppColors.statusDanger, size: 18),
                                        onPressed: () => vm.removeMember(m.userId),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),

                // Bottom CTA Bar (C7 specs)
                if (isLeader && team != null && team.isForming)
                  Container(
                    padding: const EdgeInsets.all(12),
                    color: AppColors.bgPanel,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppButton(
                          label: '[ MỜI THÀNH VIÊN ]',
                          onPressed: () => _showInviteBottomSheet(context, vm),
                        ),
                        const SizedBox(height: 8),
                        OutlinedButton(
                          onPressed: () => _showTransferLeaderDialog(context, vm),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.borderMuted),
                            minimumSize: const Size(double.infinity, 44),
                          ),
                          child: const Text(
                            '[ CHUYỂN QUYỀN TRƯỞNG NHÓM ]',
                            style: TextStyle(fontFamily: 'Chakra Petch', fontSize: 13, color: AppColors.textMuted),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
