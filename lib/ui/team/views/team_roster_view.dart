import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../common/widgets/app_button.dart';
import '../../common/widgets/app_text_field.dart';
import '../../common/widgets/hud_card.dart';
import '../../common/widgets/status_chip.dart';

class TeamRosterView extends StatefulWidget {
  const TeamRosterView({super.key});

  @override
  State<TeamRosterView> createState() => _TeamRosterViewState();
}

class _TeamRosterViewState extends State<TeamRosterView> {
  bool _hasTransferRequest = false;
  final List<Map<String, dynamic>> _members = [
    {'name': 'Lê Văn A', 'role': 'Trưởng nhóm', 'isLeader': true, 'verified': true},
    {'name': 'Nguyễn Văn B', 'role': 'Thành viên', 'isLeader': false, 'verified': true},
    {'name': 'Trần Thị C', 'role': 'Thành viên', 'isLeader': false, 'verified': true},
    {'name': 'Phạm Văn D', 'role': 'Thành viên', 'isLeader': false, 'verified': false},
  ];

  void _showInviteBottomSheet() {
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
              onPressed: () {
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã gửi lời mời thành công!'), backgroundColor: AppColors.statusSuccess),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _removeMember(int index) {
    setState(() {
      _members.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
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
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _members.length,
                itemBuilder: (ctx, index) {
                  final m = _members[index];
                  return Dismissible(
                    key: Key(m['name']),
                    direction: m['isLeader'] ? DismissDirection.none : DismissDirection.endToStart,
                    onDismissed: (_) => _removeMember(index),
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      color: AppColors.statusDanger,
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    child: HudCard(
                      margin: const EdgeInsets.only(bottom: 12),
                      accentBarColor: m['isLeader'] ? AppColors.primary : AppColors.accentTeam,
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: AppColors.surfaceContainerHigh,
                            child: Text(m['name'][0], style: const TextStyle(fontFamily: 'Sora', color: AppColors.textPrimary)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(m['name'], style: const TextStyle(fontFamily: 'Sora', fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                                Text(m['role'], style: const TextStyle(fontFamily: 'Sora', fontSize: 12, color: AppColors.textMuted)),
                              ],
                            ),
                          ),
                          StatusChip(
                            label: m['verified'] ? 'VERIFIED' : 'UNVERIFIED',
                            variant: m['verified'] ? StatusChipVariant.success : StatusChipVariant.warning,
                            fontSize: 8,
                          ),
                          if (!m['isLeader'])
                            IconButton(
                              icon: const Icon(Icons.close, color: AppColors.statusDanger, size: 18),
                              onPressed: () => _removeMember(index),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Bottom CTA Bar (C7 specs)
            Container(
              padding: const EdgeInsets.all(12),
              color: AppColors.bgPanel,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppButton(
                    label: '[ MỜI THÀNH VIÊN ]',
                    onPressed: _showInviteBottomSheet,
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: () => setState(() => _hasTransferRequest = true),
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
  }
}
