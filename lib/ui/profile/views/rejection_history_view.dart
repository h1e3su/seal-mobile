import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/theme/app_colors.dart';
import '../../common/widgets/hud_card.dart';
import '../../common/widgets/status_chip.dart';
import '../viewmodels/profile_viewmodel.dart';

class RejectionHistoryView extends StatefulWidget {
  const RejectionHistoryView({super.key});

  @override
  State<RejectionHistoryView> createState() => _RejectionHistoryViewState();
}

class _RejectionHistoryViewState extends State<RejectionHistoryView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileViewModel>().fetchRejectionHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(
      builder: (context, vm, _) {
        final rejections = vm.rejections;

        return Scaffold(
          backgroundColor: AppColors.bgBase,
          appBar: AppBar(
            backgroundColor: AppColors.bgPanel,
            elevation: 0,
            title: const Text(
              'LỊCH SỬ TỪ CHỐI HỒ SƠ',
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
                onPressed: () => vm.fetchRejectionHistory(),
              ),
            ],
          ),
          body: vm.isLoading && rejections.isEmpty
              ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
              : rejections.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.verified_user_outlined, size: 64, color: AppColors.statusSuccess),
                          const SizedBox(height: 16),
                          const Text(
                            'BẠN CHƯA TỪNG BỊ TỪ CHỐI HỒ SƠ',
                            style: TextStyle(fontFamily: 'Chakra Petch', fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Mọi thông tin hồ sơ của bạn đều hợp lệ hoặc chưa gửi duyệt.',
                            style: TextStyle(fontFamily: 'Sora', fontSize: 13, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: rejections.length,
                      itemBuilder: (ctx, index) {
                        final item = rejections[index];
                        return HudCard(
                          margin: const EdgeInsets.only(bottom: 12),
                          accentBarColor: AppColors.statusDanger,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    item.rejectedAt != null
                                        ? '${item.rejectedAt!.day.toString().padLeft(2, '0')}/${item.rejectedAt!.month.toString().padLeft(2, '0')}/${item.rejectedAt!.year}'
                                        : 'Lần từ chối #${index + 1}',
                                    style: const TextStyle(fontFamily: 'JetBrains Mono', fontSize: 12, color: AppColors.textMuted),
                                  ),
                                  const StatusChip(
                                    label: 'REJECTED',
                                    variant: StatusChipVariant.danger,
                                    fontSize: 9,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Lý do từ chối từ Ban Tổ Chức:',
                                style: TextStyle(fontFamily: 'Chakra Petch', fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.statusDanger),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.reason,
                                style: const TextStyle(fontFamily: 'Sora', fontSize: 13, color: AppColors.textPrimary),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
        );
      },
    );
  }
}
