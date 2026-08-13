import 'package:flutter/material.dart';
import '../../../app/router/route_names.dart';
import '../../../app/theme/app_colors.dart';
import '../../common/widgets/app_button.dart';
import '../../common/widgets/app_text_field.dart';
import '../../common/widgets/clipped_container.dart';
import '../../common/widgets/hud_card.dart';

class ProfileVerificationView extends StatefulWidget {
  const ProfileVerificationView({super.key});

  @override
  State<ProfileVerificationView> createState() => _ProfileVerificationViewState();
}

class _ProfileVerificationViewState extends State<ProfileVerificationView> {
  int _selectedType = 0; // 0 = FPT, 1 = Non-FPT
  final _mssvController = TextEditingController();
  String? _selectedSchool = 'Đại học Bách Khoa';
  bool _hasUploadedCard = false;
  bool _isPending = false;
  bool _isLoading = false;

  final List<String> _schools = [
    'Đại học Bách Khoa',
    'Đại học Quốc Gia',
    'Đại học Sư Phạm Kỹ Thuật',
    'Đại học Công Nghệ Thông Tin',
  ];

  @override
  void dispose() {
    _mssvController.dispose();
    super.dispose();
  }

  void _onVerify() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (_selectedType == 0) {
      // Auto verify FPT student -> Home
      Navigator.of(context).pushReplacementNamed(RouteNames.home);
    } else {
      // Non-FPT student -> Pending state banner
      setState(() => _isPending = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      appBar: AppBar(
        backgroundColor: AppColors.bgPanel,
        elevation: 0,
        title: const Text(
          'XÁC MINH HỒ SƠ (STEP 1/2)',
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
            if (_isPending)
              Container(
                color: AppColors.statusWarning.withValues(alpha: 0.2),
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.statusWarning),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.hourglass_empty, color: AppColors.statusWarning, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Hồ sơ của bạn đang chờ Ban Tổ Chức phê duyệt.',
                        style: TextStyle(fontFamily: 'Sora', fontSize: 13, color: AppColors.textPrimary),
                      ),
                    ),
                  ],
                ),
              ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'VUI LÒNG CHỌN LOẠI HỒ SƠ',
                      style: TextStyle(
                        fontFamily: 'Chakra Petch',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 14),

                    Row(
                      children: [
                        Expanded(
                          child: HudCard(
                            accentBarColor: _selectedType == 0 ? AppColors.primary : AppColors.borderMuted,
                            backgroundColor: _selectedType == 0 ? AppColors.surfaceContainerHigh : AppColors.bgPanel,
                            onTap: () => setState(() => _selectedType = 0),
                            child: const Column(
                              children: [
                                Icon(Icons.school, color: AppColors.primary, size: 28),
                                SizedBox(height: 8),
                                Text(
                                  'Sinh viên FPT',
                                  style: TextStyle(fontFamily: 'Sora', fontSize: 13, color: AppColors.textPrimary),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: HudCard(
                            accentBarColor: _selectedType == 1 ? AppColors.primary : AppColors.borderMuted,
                            backgroundColor: _selectedType == 1 ? AppColors.surfaceContainerHigh : AppColors.bgPanel,
                            onTap: () => setState(() => _selectedType = 1),
                            child: const Column(
                              children: [
                                Icon(Icons.account_balance, color: AppColors.primary, size: 28),
                                SizedBox(height: 8),
                                Text(
                                  'Trường khác',
                                  style: TextStyle(fontFamily: 'Sora', fontSize: 13, color: AppColors.textPrimary),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    if (_selectedType == 0) ...[
                      ClippedContainer(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppTextField(
                              controller: _mssvController,
                              label: 'Mã số sinh viên FPT (MSSV)',
                              hint: 'Ví dụ: SE170000',
                              prefixIcon: Icons.badge_outlined,
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      ClippedContainer(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Chọn trường đại học',
                              style: TextStyle(fontFamily: 'Sora', fontSize: 13, color: AppColors.textMuted),
                            ),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<String>(
                              initialValue: _selectedSchool,
                              dropdownColor: AppColors.bgPanel,
                              style: const TextStyle(fontFamily: 'Sora', fontSize: 14, color: AppColors.textPrimary),
                              items: _schools.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                              onChanged: (val) => setState(() => _selectedSchool = val),
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: AppColors.bgInput,
                                border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.borderMuted)),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Chụp/Tải ảnh thẻ sinh viên',
                              style: TextStyle(fontFamily: 'Sora', fontSize: 13, color: AppColors.textMuted),
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () => setState(() => _hasUploadedCard = !_hasUploadedCard),
                              child: Container(
                                height: 120,
                                decoration: BoxDecoration(
                                  color: AppColors.bgInput,
                                  border: Border.all(color: _hasUploadedCard ? AppColors.statusSuccess : AppColors.borderMuted, style: BorderStyle.solid),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(_hasUploadedCard ? Icons.check_circle : Icons.camera_alt, color: _hasUploadedCard ? AppColors.statusSuccess : AppColors.primary, size: 32),
                                      const SizedBox(height: 6),
                                      Text(
                                        _hasUploadedCard ? 'Đã đính kèm thẻ SV' : 'Chấm/Tải lên thẻ sinh viên',
                                        style: TextStyle(fontFamily: 'Sora', fontSize: 13, color: _hasUploadedCard ? AppColors.statusSuccess : AppColors.textMuted),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              color: AppColors.bgPanel,
              child: AppButton(
                label: 'XÁC MINH HỒ SƠ >',
                isLoading: _isLoading,
                onPressed: _onVerify,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
