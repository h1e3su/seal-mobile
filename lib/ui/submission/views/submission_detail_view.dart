import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../common/widgets/app_button.dart';
import '../../common/widgets/app_text_field.dart';
import '../../common/widgets/clipped_container.dart';

class SubmissionDetailView extends StatefulWidget {
  final bool isClosed;
  const SubmissionDetailView({super.key, this.isClosed = false});

  @override
  State<SubmissionDetailView> createState() => _SubmissionDetailViewState();
}

class _SubmissionDetailViewState extends State<SubmissionDetailView> {
  final _urlController = TextEditingController(text: 'https://github.com/seal-project/mobile-app');
  final _descController = TextEditingController(text: 'Hệ thống quản lý vòng đời sự kiện SEAL Mobile với giao diện HUD Tactical.');
  bool _isLoading = false;

  @override
  void dispose() {
    _urlController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _onUpdate() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cập nhật bài nộp thành công!'), backgroundColor: AppColors.statusSuccess),
    );
  }

  void _onDelete() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgPanel,
        title: const Text('XÁC NHẬN XÓA BÀI NỘP', style: TextStyle(fontFamily: 'Chakra Petch', color: AppColors.statusDanger)),
        content: const Text('Bạn có chắc chắn muốn xóa bài nộp này không? Thao tác này không thể hoàn tác.', style: TextStyle(fontFamily: 'Sora', color: AppColors.textPrimary)),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('HỦY BỎ', style: TextStyle(color: AppColors.textMuted))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.statusDanger),
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
            child: const Text('XÓA BÀI NỘP', style: TextStyle(color: Colors.white)),
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
          'CHI TIẾT BÀI NỘP',
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
            if (widget.isClosed)
              Container(
                color: AppColors.statusDanger.withValues(alpha: 0.2),
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.statusDanger),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.lock_clock, color: AppColors.statusDanger, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Đã hết hạn nộp bài — Toàn bộ chỉnh sửa bị khóa',
                      style: TextStyle(fontFamily: 'Sora', fontSize: 13, color: AppColors.textPrimary),
                    ),
                  ],
                ),
              ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: ClippedContainer(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppTextField(
                        controller: _urlController,
                        label: 'URL Repository / Presentation Slide',
                        prefixIcon: Icons.link,
                        enabled: !widget.isClosed,
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.content_paste, color: AppColors.primary, size: 18),
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        controller: _descController,
                        label: 'Mô tả ngắn gọn về sản phẩm',
                        prefixIcon: Icons.description,
                        maxLines: 4,
                        enabled: !widget.isClosed,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            if (!widget.isClosed)
              Container(
                padding: const EdgeInsets.all(12),
                color: AppColors.bgPanel,
                child: Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        label: '[ CẬP NHẬT ]',
                        isLoading: _isLoading,
                        onPressed: _onUpdate,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _onDelete,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.statusDanger),
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        child: const Text(
                          '[ XÓA BÀI NỘP ]',
                          style: TextStyle(fontFamily: 'Chakra Petch', fontSize: 13, color: AppColors.statusDanger),
                        ),
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
