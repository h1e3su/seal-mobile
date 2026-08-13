import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/di/locator.dart';
import '../../../app/theme/app_colors.dart';
import '../../common/widgets/app_button.dart';
import '../../common/widgets/app_text_field.dart';
import '../../common/widgets/clipped_container.dart';
import '../../common/widgets/status_chip.dart';
import '../viewmodels/register_viewmodel.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RegisterViewModel>(
      create: (_) => locator<RegisterViewModel>(),
      child: const _RegisterBody(),
    );
  }
}

class _RegisterBody extends StatefulWidget {
  const _RegisterBody();

  @override
  State<_RegisterBody> createState() => _RegisterBodyState();
}

class _RegisterBodyState extends State<_RegisterBody> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _acceptTerms = false;
  String? _termsError;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _onRegisterPressed(RegisterViewModel vm) async {
    if (!_acceptTerms) {
      setState(() {
        _termsError = 'Bạn phải đồng ý với điều khoản sử dụng';
      });
      return;
    }
    setState(() {
      _termsError = null;
    });

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mật khẩu xác nhận không khớp'),
          backgroundColor: AppColors.statusDanger,
        ),
      );
      return;
    }

    final success = await vm.register(
      _emailController.text,
      _passwordController.text,
      _fullNameController.text,
    );
    if (success && mounted) {
      // Pop back to S2 returning registered email to activate S4 toast state
      Navigator.of(context).pop(_emailController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RegisterViewModel>();

    return Scaffold(
      backgroundColor: AppColors.bgBase,
      appBar: AppBar(
        backgroundColor: AppColors.bgPanel,
        elevation: 0,
        title: const Text(
          'TẠO TÀI KHOẢN MỚI',
          style: TextStyle(
            fontFamily: 'Chakra Petch',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.of(context).pop(),
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
                    ClippedContainer(
                      padding: const EdgeInsets.all(20),
                      backgroundColor: AppColors.bgPanel,
                      borderColor: AppColors.borderMuted,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'REGISTER OPERATIVE',
                                style: TextStyle(
                                  fontFamily: 'JetBrains Mono',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.0,
                                  color: AppColors.primary,
                                ),
                              ),
                              StatusChip(
                                label: 'CONTESTANT',
                                variant: StatusChipVariant.role,
                                fontSize: 9,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          AppTextField(
                            controller: _fullNameController,
                            label: 'Họ và tên',
                            hint: 'Nhập họ và tên',
                            prefixIcon: Icons.badge_outlined,
                            errorText: vm.fullNameError,
                          ),
                          const SizedBox(height: 14),
                          AppTextField(
                            controller: _emailController,
                            label: 'Email sinh viên',
                            hint: 'student@fpt.edu.vn',
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: Icons.email_outlined,
                            errorText: vm.emailError,
                          ),
                          const SizedBox(height: 14),
                          AppTextField(
                            controller: _passwordController,
                            label: 'Mật khẩu',
                            hint: 'Tối thiểu 6 ký tự',
                            prefixIcon: Icons.lock_outline,
                            errorText: vm.passwordError,
                            obscureText: true,
                          ),
                          const SizedBox(height: 14),
                          AppTextField(
                            controller: _confirmPasswordController,
                            label: 'Xác nhận mật khẩu',
                            hint: 'Nhập lại mật khẩu',
                            prefixIcon: Icons.lock_clock_outlined,
                            obscureText: true,
                          ),
                          const SizedBox(height: 16),

                          // Terms Checkbox
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Checkbox(
                                value: _acceptTerms,
                                activeColor: AppColors.primary,
                                checkColor: AppColors.bgBase,
                                onChanged: (val) => setState(() => _acceptTerms = val ?? false),
                              ),
                              const Expanded(
                                child: Text(
                                  'Tôi đồng ý với Điều khoản sử dụng & Quy định cuộc thi',
                                  style: TextStyle(fontFamily: 'Sora', fontSize: 13, color: AppColors.textPrimary),
                                ),
                              ),
                            ],
                          ),
                          if (_termsError != null)
                            Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Text(
                                _termsError!,
                                style: const TextStyle(fontFamily: 'Sora', fontSize: 12, color: AppColors.statusDanger),
                              ),
                            ),

                          if (vm.hasError && vm.errorMessage != null) ...[
                            const SizedBox(height: 14),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.statusDanger.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: AppColors.statusDanger),
                              ),
                              child: Text(
                                vm.errorMessage!,
                                style: const TextStyle(fontFamily: 'Sora', fontSize: 12, color: AppColors.statusDanger),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Fixed Bottom Action Bar (S3 spec)
            Container(
              padding: const EdgeInsets.all(12),
              color: AppColors.bgPanel,
              child: AppButton(
                label: '// TẠO TÀI KHOẢN >',
                isLoading: vm.isLoading,
                onPressed: () => _onRegisterPressed(vm),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
