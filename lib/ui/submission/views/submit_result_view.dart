import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/di/locator.dart';
import '../../../app/theme/app_colors.dart';
import '../../common/widgets/app_button.dart';
import '../../common/widgets/app_text_field.dart';
import '../../common/widgets/clipped_container.dart';
import '../../common/widgets/hud_card.dart';
import '../../common/widgets/status_chip.dart';
import '../viewmodels/submission_viewmodel.dart';

class SubmitResultView extends StatelessWidget {
  const SubmitResultView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SubmissionViewModel>(
      create: (_) => locator<SubmissionViewModel>(),
      child: const _SubmitResultBody(),
    );
  }
}

class _SubmitResultBody extends StatefulWidget {
  const _SubmitResultBody();

  @override
  State<_SubmitResultBody> createState() => _SubmitResultBodyState();
}

class _SubmitResultBodyState extends State<_SubmitResultBody> {
  final _repoController = TextEditingController(text: 'https://github.com/seal-mobile/cyber-shield-ai');
  final _demoController = TextEditingController(text: 'https://cyber-shield.app.fpt.edu.vn');
  final _descController = TextEditingController(text: 'Ứng dụng di động giám sát hoạt động sinh viên tích hợp AI agent.');

  @override
  void dispose() {
    _repoController.dispose();
    _demoController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // C11 - Submit New Entry Form
              ClippedContainer(
                padding: const EdgeInsets.all(18),
                backgroundColor: AppColors.bgPanel,
                borderColor: AppColors.borderMuted,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'SUBMIT NEW ENTRY (C11)',
                          style: TextStyle(
                            fontFamily: 'JetBrains Mono',
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.0,
                            color: AppColors.primary,
                          ),
                        ),
                        StatusChip(
                          label: 'VÒNG 1',
                          variant: StatusChipVariant.info,
                          fontSize: 9,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _repoController,
                      label: 'Source Code Repository (GitHub/GitLab)',
                      hint: 'https://github.com/org/repo',
                      prefixIcon: Icons.code_rounded,
                    ),
                    const SizedBox(height: 14),
                    AppTextField(
                      controller: _demoController,
                      label: 'Demo Video / Live App URL',
                      hint: 'https://demo.app.com',
                      prefixIcon: Icons.link_rounded,
                    ),
                    const SizedBox(height: 14),
                    AppTextField(
                      controller: _descController,
                      label: 'Mô tả ngắn dự án & Công nghệ',
                      hint: 'Tóm tắt giải pháp, công nghệ sử dụng...',
                      maxLines: 3,
                      prefixIcon: Icons.notes_rounded,
                    ),
                    const SizedBox(height: 20),
                    AppButton(
                      label: 'NỘP BÀI THI / CẬP NHẬT',
                      icon: Icons.cloud_upload_outlined,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Bài thi đã được lưu và tải lên thành công!'),
                            backgroundColor: AppColors.statusSuccess,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // C9 - Submission History List
              const Text(
                'LỊCH SỬ NỘP BÀI (SUBMISSION LOGS)',
                style: TextStyle(
                  fontFamily: 'JetBrains Mono',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),

              const HudCard(
                accentBarColor: AppColors.statusSuccess,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'VERSION 1.2 (CHÍNH THỨC)',
                          style: TextStyle(
                            fontFamily: 'JetBrains Mono',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        StatusChip(
                          label: 'THÀNH CÔNG',
                          variant: StatusChipVariant.success,
                          fontSize: 8,
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Thời gian: 13/08/2026 - 02:15 AM',
                      style: TextStyle(
                        fontFamily: 'JetBrains Mono',
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
