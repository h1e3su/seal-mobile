import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/theme/app_colors.dart';
import '../../common/widgets/app_button.dart';
import '../../common/widgets/app_text_field.dart';
import '../../common/widgets/hud_card.dart';
import '../../common/widgets/status_chip.dart';
import '../../team/viewmodels/team_viewmodel.dart';
import '../viewmodels/appeals_viewmodel.dart';

class AppealsView extends StatefulWidget {
  const AppealsView({super.key});

  @override
  State<AppealsView> createState() => _AppealsViewState();
}

class _AppealsViewState extends State<AppealsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final teamId = context.read<TeamViewModel>().myTeam?.id;
      context.read<AppealsViewModel>().loadMyAppeals(teamId);
    });
  }

  void _showNewAppealBottomSheet(BuildContext context, AppealsViewModel vm) {
    final reasonController = TextEditingController();
    final teamVm = context.read<TeamViewModel>();
    final teamId = teamVm.myTeam?.id ?? 'team_demo';

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
              'GỬI ĐƠN PHÚC KHẢO ĐIỂM',
              style: TextStyle(
                fontFamily: 'Chakra Petch',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 14),
            AppTextField(
              controller: reasonController,
              label: 'Lý do phúc khảo chi tiết',
              hint: 'Giải thích rõ lý do hoặc bằng chứng minh họa...',
              prefixIcon: Icons.edit_note,
              maxLines: 4,
            ),
            const SizedBox(height: 20),
            AppButton(
              label: 'GỬI PHÚC KHẢO',
              isLoading: vm.isLoading,
              onPressed: () async {
                final reason = reasonController.text.trim();
                if (reason.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Vui lòng nhập lý do phúc khảo!'), backgroundColor: AppColors.statusDanger),
                  );
                  return;
                }
                Navigator.of(ctx).pop();
                final success = await vm.createAppeal(
                  teamId: teamId,
                  roundId: 'rnd_01',
                  reason: reason,
                );
                if (success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đã gửi đơn phúc khảo thành công! Vui lòng chờ phản hồi.'), backgroundColor: AppColors.statusSuccess),
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

  @override
  Widget build(BuildContext context) {
    return Consumer<AppealsViewModel>(
      builder: (context, vm, _) {
        final appeals = vm.appeals;

        return Scaffold(
          backgroundColor: AppColors.bgBase,
          appBar: AppBar(
            backgroundColor: AppColors.bgPanel,
            elevation: 0,
            title: const Text(
              'YÊU CẦU PHÚC KHẢO (APPEALS)',
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
                onPressed: () {
                  final teamId = context.read<TeamViewModel>().myTeam?.id;
                  vm.loadMyAppeals(teamId);
                },
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: vm.isLoading && appeals.isEmpty
                      ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                      : appeals.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.fact_check_outlined, size: 64, color: AppColors.textMuted),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'CHƯA CÓ ĐƠN PHÚC KHẢO NÀO',
                                    style: TextStyle(fontFamily: 'Chakra Petch', fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Nếu có thắc mắc về điểm số, hãy gửi đơn phúc khảo để BTC xem xét.',
                                    style: TextStyle(fontFamily: 'Sora', fontSize: 13, color: AppColors.textMuted),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: appeals.length,
                              itemBuilder: (ctx, index) {
                                final item = appeals[index];
                                final isAccepted = item.isAccepted;
                                final isRejected = item.isRejected;

                                StatusChipVariant variant = StatusChipVariant.warning;
                                if (isAccepted) variant = StatusChipVariant.success;
                                if (isRejected) variant = StatusChipVariant.danger;

                                return HudCard(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  accentBarColor: isAccepted
                                      ? AppColors.statusSuccess
                                      : (isRejected ? AppColors.statusDanger : AppColors.statusWarning),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              'PHÚC KHẢO #${item.id.isNotEmpty ? item.id : (index + 1)}',
                                              style: const TextStyle(
                                                fontFamily: 'Chakra Petch',
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.textPrimary,
                                              ),
                                            ),
                                          ),
                                          StatusChip(
                                            label: item.status.toUpperCase(),
                                            variant: variant,
                                            fontSize: 9,
                                          ),
                                        ],
                                      ),
                                      if (item.createdDate != null) ...[
                                        const SizedBox(height: 6),
                                        Text(
                                          'Ngày gửi: ${item.createdDate!.day.toString().padLeft(2, '0')}/${item.createdDate!.month.toString().padLeft(2, '0')}/${item.createdDate!.year}',
                                          style: const TextStyle(
                                            fontFamily: 'JetBrains Mono',
                                            fontSize: 11,
                                            color: AppColors.textMuted,
                                          ),
                                        ),
                                      ],
                                      const SizedBox(height: 8),
                                      Text(
                                        item.reason,
                                        style: const TextStyle(
                                          fontFamily: 'Sora',
                                          fontSize: 13,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      if (item.responseComment != null && item.responseComment!.isNotEmpty) ...[
                                        const SizedBox(height: 10),
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: AppColors.bgInput,
                                            borderRadius: BorderRadius.circular(4),
                                            border: Border.all(color: AppColors.borderMuted),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text('PHẢN HỒI TỪ BAN TỔ CHỨC:', style: TextStyle(fontFamily: 'Chakra Petch', fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary)),
                                              const SizedBox(height: 4),
                                              Text(item.responseComment!, style: const TextStyle(fontFamily: 'Sora', fontSize: 12, color: AppColors.textPrimary)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                );
                              },
                            ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  color: AppColors.bgPanel,
                  child: AppButton(
                    label: '[ GỬI PHÚC KHẢO ]',
                    onPressed: () => _showNewAppealBottomSheet(context, vm),
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
