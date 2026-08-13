import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../common/widgets/app_button.dart';
import '../../common/widgets/app_text_field.dart';
import '../../common/widgets/hud_card.dart';
import '../../common/widgets/status_chip.dart';

class AppealsView extends StatefulWidget {
  const AppealsView({super.key});

  @override
  State<AppealsView> createState() => _AppealsViewState();
}

class _AppealsViewState extends State<AppealsView> {
  final List<Map<String, dynamic>> _appeals = [
    {
      'title': 'Phúc khảo điểm Tiêu chí 2 - Track AI',
      'date': '12/08/2026',
      'status': 'PENDING',
      'reason':
          'Em xin phúc khảo lại tiêu chí Kiến trúc công nghệ do video demo chưa hiển thị hết tính năng.',
    },
    {
      'title': 'Phúc khảo điểm Vòng 1',
      'date': '05/08/2026',
      'status': 'ACCEPTED',
      'reason':
          'Ban Giám khảo đã cập nhật lại điểm +3.0 sau khi kiểm tra lại repository.',
    },
  ];

  void _showNewAppealBottomSheet() {
    final reasonController = TextEditingController();
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
              onPressed: () {
                Navigator.of(ctx).pop();
                setState(() {
                  _appeals.insert(0, {
                    'title': 'Phúc khảo điểm vừa gửi',
                    'date': '13/08/2026',
                    'status': 'PENDING',
                    'reason': reasonController.text.isEmpty
                        ? 'Đang cập nhật nội dung'
                        : reasonController.text,
                  });
                });
              },
            ),
          ],
        ),
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
          'YÊU CẦU PHÚC KHẢO (APPEALS)',
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
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _appeals.length,
                itemBuilder: (ctx, index) {
                  final item = _appeals[index];
                  final status = item['status'];
                  StatusChipVariant variant = StatusChipVariant.warning;
                  if (status == 'ACCEPTED') variant = StatusChipVariant.success;
                  if (status == 'REJECTED') variant = StatusChipVariant.danger;

                  return HudCard(
                    margin: const EdgeInsets.only(bottom: 12),
                    accentBarColor: status == 'ACCEPTED'
                        ? AppColors.statusSuccess
                        : AppColors.statusWarning,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                item['title'],
                                style: const TextStyle(
                                  fontFamily: 'Chakra Petch',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            StatusChip(
                              label: status,
                              variant: variant,
                              fontSize: 9,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Ngày gửi: ${item['date']}',
                          style: const TextStyle(
                            fontFamily: 'JetBrains Mono',
                            fontSize: 11,
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item['reason'],
                          style: const TextStyle(
                            fontFamily: 'Sora',
                            fontSize: 13,
                            color: AppColors.textPrimary,
                          ),
                        ),
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
                onPressed: _showNewAppealBottomSheet,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
