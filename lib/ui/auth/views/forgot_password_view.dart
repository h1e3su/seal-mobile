import 'package:flutter/material.dart';
import '../../../app/router/route_names.dart';
import '../../../app/theme/app_colors.dart';
import '../../common/widgets/app_button.dart';
import '../../common/widgets/app_text_field.dart';
import '../../common/widgets/clipped_container.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  int _step = 1;
  final _emailController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSendResetRequest() async {
    if (_emailController.text.trim().isEmpty) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _step = 2;
    });
  }

  void _onResetPassword() async {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mật khẩu xác nhận không khớp'),
          backgroundColor: AppColors.statusDanger,
        ),
      );
      return;
    }
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;

    Navigator.of(context).pushNamedAndRemoveUntil(
      RouteNames.login,
      (route) => false,
      arguments: {'isActivatedSuccess': true},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      appBar: AppBar(
        backgroundColor: AppColors.bgPanel,
        elevation: 0,
        title: Text(
          _step == 1 ? 'QUÊN MẬT KHẨU (BƯỚC 1/2)' : 'ĐẶT LẠI MẬT KHẨU (BƯỚC 2/2)',
          style: const TextStyle(
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_step == 1) ...[
                      ClippedContainer(
                        padding: const EdgeInsets.all(20),
                        backgroundColor: AppColors.bgPanel,
                        borderColor: AppColors.borderMuted,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'GỬI YÊU CẦU ĐẶT LẠI MẬT KHẨU',
                              style: TextStyle(
                                fontFamily: 'Chakra Petch',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Nhập email đã đăng ký tài khoản để nhận mã xác nhận / link khôi phục.',
                              style: TextStyle(fontFamily: 'Sora', fontSize: 13, color: AppColors.textMuted),
                            ),
                            const SizedBox(height: 20),
                            AppTextField(
                              controller: _emailController,
                              label: 'Email tài khoản',
                              hint: 'student@fpt.edu.vn',
                              prefixIcon: Icons.email_outlined,
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      ClippedContainer(
                        padding: const EdgeInsets.all(20),
                        backgroundColor: AppColors.bgPanel,
                        borderColor: AppColors.borderMuted,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'NHẬP MẬT KHẨU MỚI',
                              style: TextStyle(
                                fontFamily: 'Chakra Petch',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 20),
                            AppTextField(
                              controller: _newPasswordController,
                              label: 'Mật khẩu mới',
                              hint: 'Tối thiểu 6 ký tự',
                              prefixIcon: Icons.lock_outline,
                              obscureText: true,
                            ),
                            const SizedBox(height: 14),
                            AppTextField(
                              controller: _confirmPasswordController,
                              label: 'Xác nhận mật khẩu mới',
                              hint: 'Nhập lại mật khẩu mới',
                              prefixIcon: Icons.lock_clock_outlined,
                              obscureText: true,
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
                label: _step == 1 ? 'GỬI YÊU CẦU >' : 'ĐẶT LẠI MẬT KHẨU >',
                isLoading: _isLoading,
                onPressed: _step == 1 ? _onSendResetRequest : _onResetPassword,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
