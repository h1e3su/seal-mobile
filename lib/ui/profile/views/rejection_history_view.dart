import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../common/widgets/hud_card.dart';
import '../../common/widgets/status_chip.dart';

class RejectionHistoryView extends StatelessWidget {
  const RejectionHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> history = [
      {
        'date': '10/08/2026 - 14:30',
        'reason': 'Ảnh thẻ sinh viên bị mờ, không rõ Mã số sinh viên và dấu mộc của trường.',
      },
      {
        'date': '02/08/2026 - 09:15',
        'reason': 'Mã số sinh viên FPT nhập không hợp lệ trên hệ thống dữ liệu phòng đào tạo.',
      },
    ];

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
      ),
      body: history.isEmpty
          ? const Center(
              child: Text(
                'Bạn chưa từng bị từ chối hồ sơ',
                style: TextStyle(fontFamily: 'Sora', fontSize: 14, color: AppColors.textMuted),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: history.length,
              itemBuilder: (ctx, index) {
                final item = history[index];
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
                            item['date']!,
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
                      Text(
                        'Lý do từ chối:',
                        style: const TextStyle(fontFamily: 'Chakra Petch', fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.statusDanger),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['reason']!,
                        style: const TextStyle(fontFamily: 'Sora', fontSize: 13, color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
