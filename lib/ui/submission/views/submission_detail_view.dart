import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/theme/app_colors.dart';
import '../../common/widgets/app_button.dart';
import '../../common/widgets/app_text_field.dart';
import '../../common/widgets/clipped_container.dart';
import '../viewmodels/submission_viewmodel.dart';

class SubmissionDetailView extends StatefulWidget {
  final bool isClosed;
  const SubmissionDetailView({super.key, this.isClosed = false});

  @override
  State<SubmissionDetailView> createState() => _SubmissionDetailViewState();
}

class _SubmissionDetailViewState extends State<SubmissionDetailView> {
  final _titleController = TextEditingController();
  final _urlController = TextEditingController();
  final _descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final submission = context.read<SubmissionViewModel>().selectedSubmission;
    if (submission != null) {
      _titleController.text = submission.title;
      _urlController.text = submission.submissionUrl;
      _descController.text = submission.description ?? '';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _urlController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _onUpdate(BuildContext context, SubmissionViewModel vm) async {
    final submission = vm.selectedSubmission;
    if (submission == null) return;

    final title = _titleController.text.trim();
    final url = _urlController.text.trim();
    final desc = _descController.text.trim();

    final success = await vm.updateSubmission(
      submission.id,
      title: title,
      description: desc.isNotEmpty ? desc : null,
      submissionUrl: url,
    );

    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cập nhật bài nộp thành công!'), backgroundColor: AppColors.statusSuccess),
      );
      Navigator.of(context).pop();
    } else if (context.mounted && vm.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(vm.errorMessage!), backgroundColor: AppColors.statusDanger),
      );
    }
  }

  void _onDelete(BuildContext context, SubmissionViewModel vm) {
    final submission = vm.selectedSubmission;
    if (submission == null) return;

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
            onPressed: () async {
              Navigator.of(ctx).pop();
              final success = await vm.deleteSubmission(submission.id);
              if (success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã xóa bài nộp thành công!'), backgroundColor: AppColors.statusSuccess),
                );
                Navigator.of(context).pop();
              }
            },
            child: const Text('XÓA BÀI NỘP', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SubmissionViewModel>(
      builder: (context, vm, _) {
        final submission = vm.selectedSubmission;
        final isClosed = widget.isClosed || (submission?.isGraded ?? false);

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
                if (isClosed)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.statusDanger.withValues(alpha: 0.2),
                      border: Border.all(color: AppColors.statusDanger),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.lock_clock, color: AppColors.statusDanger, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Bài nộp đã chấm hoặc đã hết hạn — Toàn bộ chỉnh sửa bị khóa',
                            style: TextStyle(fontFamily: 'Sora', fontSize: 13, color: AppColors.textPrimary),
                          ),
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
                            controller: _titleController,
                            label: 'Tên đề tài / giải pháp',
                            prefixIcon: Icons.title,
                            enabled: !isClosed,
                          ),
                          const SizedBox(height: 16),
                          AppTextField(
                            controller: _urlController,
                            label: 'URL Repository / Presentation Slide',
                            prefixIcon: Icons.link,
                            enabled: !isClosed,
                          ),
                          const SizedBox(height: 16),
                          AppTextField(
                            controller: _descController,
                            label: 'Mô tả ngắn gọn về sản phẩm',
                            prefixIcon: Icons.description,
                            maxLines: 4,
                            enabled: !isClosed,
                          ),
                          if (submission?.finalScore != null) ...[
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                border: Border.all(color: AppColors.primary),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('ĐIỂM TỔNG KẾT:', style: TextStyle(fontFamily: 'Chakra Petch', fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                                  Text('${submission!.finalScore} pts', style: const TextStyle(fontFamily: 'JetBrains Mono', fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary)),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),

                if (!isClosed)
                  Container(
                    padding: const EdgeInsets.all(12),
                    color: AppColors.bgPanel,
                    child: Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            label: '[ CẬP NHẬT ]',
                            isLoading: vm.isLoading,
                            onPressed: () => _onUpdate(context, vm),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => _onDelete(context, vm),
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
      },
    );
  }
}
