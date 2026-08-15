import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/theme/app_colors.dart';
import '../../common/widgets/hud_card.dart';
import '../../common/widgets/status_chip.dart';
import '../viewmodels/notifications_viewmodel.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationsViewModel>().loadNotifications();
    });
  }

  void _showTeamInviteDialog(BuildContext context, NotificationsViewModel vm, String inviteId, String teamName, String invitedBy) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgPanel,
        title: const Text('LỜI MỜI VÀO ĐỘI THI', style: TextStyle(fontFamily: 'Chakra Petch', color: AppColors.primary)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bạn nhận được lời mời tham gia đội thi "$teamName" từ $invitedBy.', style: const TextStyle(fontFamily: 'Sora', color: AppColors.textPrimary)),
            const SizedBox(height: 12),
            const Text('Bạn có đồng ý tham gia đội này không?', style: TextStyle(fontFamily: 'Sora', fontSize: 13, color: AppColors.textMuted)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await vm.respondTeamInvitation(inviteId, false);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã từ chối lời mời vào đội.'), backgroundColor: AppColors.textMuted),
                );
              }
            },
            child: const Text('TỪ CHỐI', style: TextStyle(color: AppColors.statusDanger)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () async {
              Navigator.of(ctx).pop();
              final success = await vm.respondTeamInvitation(inviteId, true);
              if (success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã gia nhập đội thi thành công!'), backgroundColor: AppColors.statusSuccess),
                );
              }
            },
            child: const Text('ĐỒNG Ý', style: TextStyle(fontFamily: 'Sora', color: AppColors.bgBase)),
          ),
        ],
      ),
    );
  }

  void _showRoleInviteDialog(BuildContext context, NotificationsViewModel vm, String inviteId, String roleName, String eventName, String? trackName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgPanel,
        title: Text('LỜI MỜI LÀM $roleName'.toUpperCase(), style: const TextStyle(fontFamily: 'Chakra Petch', color: AppColors.primary)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ban tổ chức mời bạn đảm nhận vai trò $roleName cho sự kiện "$eventName"${trackName != null ? " ($trackName)" : ""}.', style: const TextStyle(fontFamily: 'Sora', color: AppColors.textPrimary)),
            const SizedBox(height: 12),
            const Text('Bạn có đồng ý nhận lời mời không?', style: TextStyle(fontFamily: 'Sora', fontSize: 13, color: AppColors.textMuted)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await vm.respondRoleInvitation(inviteId, false);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã từ chối lời mời vai trò.'), backgroundColor: AppColors.textMuted),
                );
              }
            },
            child: const Text('TỪ CHỐI', style: TextStyle(color: AppColors.statusDanger)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () async {
              Navigator.of(ctx).pop();
              final success = await vm.respondRoleInvitation(inviteId, true);
              if (success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã nhận lời mời vai trò thành công!'), backgroundColor: AppColors.statusSuccess),
                );
              }
            },
            child: const Text('ĐỒNG Ý', style: TextStyle(fontFamily: 'Sora', color: AppColors.bgBase)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationsViewModel>(
      builder: (context, vm, _) {
        final teamInvites = vm.teamInvitations;
        final roleInvites = vm.roleInvitations;
        final isEmpty = teamInvites.isEmpty && roleInvites.isEmpty;

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
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh, color: AppColors.primary),
                onPressed: () => vm.loadNotifications(),
              ),
            ],
          ),
          body: vm.isLoading && isEmpty
              ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
              : isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.notifications_none_outlined, size: 64, color: AppColors.textMuted),
                          const SizedBox(height: 16),
                          const Text(
                            'KHÔNG CÓ THÔNG BÁO HOẶC LỜI MỜI NÀO',
                            style: TextStyle(fontFamily: 'Chakra Petch', fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Tất cả lời mời tham gia đội thi hoặc sự kiện sẽ xuất hiện ở đây.',
                            style: TextStyle(fontFamily: 'Sora', fontSize: 13, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    )
                  : ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        if (teamInvites.isNotEmpty) ...[
                          const Text(
                            'LỜI MỜI VÀO ĐỘI THI',
                            style: TextStyle(fontFamily: 'Chakra Petch', fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primary),
                          ),
                          const SizedBox(height: 10),
                          ...teamInvites.map((item) {
                            return HudCard(
                              margin: const EdgeInsets.only(bottom: 12),
                              accentBarColor: AppColors.accentTeam,
                              onTap: () => _showTeamInviteDialog(
                                context,
                                vm,
                                item.id,
                                item.teamName,
                                item.invitedByUserName ?? 'Trưởng nhóm',
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.group_add, color: AppColors.accentTeam, size: 24),
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
                                                item.teamName.toUpperCase(),
                                                style: const TextStyle(
                                                  fontFamily: 'Chakra Petch',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.textPrimary,
                                                ),
                                              ),
                                            ),
                                            const StatusChip(label: 'TEAM INVITE', variant: StatusChipVariant.info, fontSize: 8),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Người mời: ${item.invitedByUserName ?? "Thành viên"} (${item.eventName ?? "Sự kiện"})',
                                          style: const TextStyle(fontFamily: 'Sora', fontSize: 12, color: AppColors.textMuted),
                                        ),
                                        const SizedBox(height: 8),
                                        const Text('Chạm để xem và phản hồi lời mời >', style: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 11, color: AppColors.primary)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                          const SizedBox(height: 16),
                        ],

                        if (roleInvites.isNotEmpty) ...[
                          const Text(
                            'LỜI MỜI VAI TRÒ SỰ KIỆN (MENTOR / JUDGE)',
                            style: TextStyle(fontFamily: 'Chakra Petch', fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.accentMentor),
                          ),
                          const SizedBox(height: 10),
                          ...roleInvites.map((item) {
                            return HudCard(
                              margin: const EdgeInsets.only(bottom: 12),
                              accentBarColor: AppColors.accentMentor,
                              onTap: () => _showRoleInviteDialog(
                                context,
                                vm,
                                item.id,
                                item.roleName,
                                item.eventName,
                                item.trackName,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.psychology, color: AppColors.accentMentor, size: 24),
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
                                                'VAI TRÒ: ${item.roleName.toUpperCase()}',
                                                style: const TextStyle(
                                                  fontFamily: 'Chakra Petch',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.textPrimary,
                                                ),
                                              ),
                                            ),
                                            StatusChip(label: item.roleName.toUpperCase(), variant: StatusChipVariant.role, fontSize: 8),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Sự kiện: ${item.eventName}${item.trackName != null ? " — ${item.trackName}" : ""}',
                                          style: const TextStyle(fontFamily: 'Sora', fontSize: 12, color: AppColors.textMuted),
                                        ),
                                        const SizedBox(height: 8),
                                        const Text('Chạm để phản hồi lời mời >', style: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 11, color: AppColors.primary)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ],
                    ),
        );
      },
    );
  }
}
