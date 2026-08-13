import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/di/locator.dart';
import '../../../app/router/route_names.dart';
import '../../../app/theme/app_colors.dart';
import '../../common/viewmodels/user_role_viewmodel.dart';
import '../../common/widgets/app_button.dart';
import '../../common/widgets/app_text_field.dart';
import '../../common/widgets/clipped_container.dart';
import '../../common/widgets/status_chip.dart';
import '../viewmodels/login_viewmodel.dart';

class LoginView extends StatelessWidget {
  final String? registeredEmail;
  final bool isActivatedSuccess;
  const LoginView({
    super.key,
    this.registeredEmail,
    this.isActivatedSuccess = false,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginViewModel>(
      create: (_) => locator<LoginViewModel>(),
      child: _LoginBody(
        registeredEmail: registeredEmail,
        isActivatedSuccess: isActivatedSuccess,
      ),
    );
  }
}

class _LoginBody extends StatefulWidget {
  final String? registeredEmail;
  final bool isActivatedSuccess;
  const _LoginBody({
    this.registeredEmail,
    this.isActivatedSuccess = false,
  });

  @override
  State<_LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<_LoginBody> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _showPassword = false;
  String? _bannerEmail;
  bool _bannerActivated = false;

  Timer? _resendTimer;
  int _resendCountdown = 59;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _bannerEmail = widget.registeredEmail;
    _bannerActivated = widget.isActivatedSuccess;
    if (_bannerEmail != null && !_bannerActivated) {
      _startResendTimer();
    }
  }

  void _startResendTimer() {
    setState(() {
      _resendCountdown = 59;
      _canResend = false;
    });
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown <= 1) {
        timer.cancel();
        if (mounted) {
          setState(() {
            _canResend = true;
            _resendCountdown = 0;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _resendCountdown--;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLoginPressed(LoginViewModel vm) async {
    final success = await vm.login(
      _emailController.text,
      _passwordController.text,
    );
    if (success && mounted) {
      final userRoleVM = context.read<UserRoleViewModel>();
      await userRoleVM.fetchUserRoles();
      if (!mounted) return;

      if (userRoleVM.roles.length >= 2) {
        Navigator.of(context).pushReplacementNamed(RouteNames.roleCheck);
      } else if (userRoleVM.isMentor) {
        Navigator.of(context).pushReplacementNamed(RouteNames.mentorDashboard);
      } else {
        Navigator.of(context).pushReplacementNamed(RouteNames.home);
      }
    }
  }

  Future<void> _onGoogleLoginPressed(LoginViewModel vm) async {
    final success = await vm.loginWithGoogle();
    if (success && mounted) {
      final userRoleVM = context.read<UserRoleViewModel>();
      await userRoleVM.fetchUserRoles();
      if (!mounted) return;

      if (userRoleVM.roles.length >= 2) {
        Navigator.of(context).pushReplacementNamed(RouteNames.roleCheck);
      } else if (userRoleVM.isMentor) {
        Navigator.of(context).pushReplacementNamed(RouteNames.mentorDashboard);
      } else {
        Navigator.of(context).pushReplacementNamed(RouteNames.home);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LoginViewModel>();

    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: SafeArea(
        child: Column(
          children: [
            // Top Toast / Banner Overlay (S4 State)
            if (_bannerActivated)
              Container(
                color: AppColors.statusSuccess,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        '✔ Kích hoạt thành công, hãy đăng nhập',
                        style: TextStyle(fontFamily: 'Sora', fontSize: 13, color: Colors.white),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white, size: 18),
                      onPressed: () => setState(() => _bannerActivated = false),
                    ),
                  ],
                ),
              )
            else if (_bannerEmail != null)
              Container(
                color: AppColors.bgPanel,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.statusWarning),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.mark_email_unread_outlined, color: AppColors.statusWarning, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Kiểm tra hộp thư [$_bannerEmail] và bấm vào link kích hoạt để hoàn tất đăng ký',
                            style: const TextStyle(fontFamily: 'Sora', fontSize: 13, color: AppColors.textPrimary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (!_canResend)
                          Text(
                            'Gửi lại sau 00:${_resendCountdown.toString().padLeft(2, '0')}',
                            style: const TextStyle(fontFamily: 'JetBrains Mono', fontSize: 12, color: AppColors.textMuted),
                          )
                        else
                          TextButton(
                            onPressed: _startResendTimer,
                            child: const Text(
                              'Không nhận được email? Gửi lại',
                              style: TextStyle(fontFamily: 'Sora', fontSize: 12, color: AppColors.primary),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    Center(
                      child: ClippedContainer(
                        width: 64,
                        height: 64,
                        backgroundColor: AppColors.surfaceContainerLowest,
                        borderColor: AppColors.primary,
                        child: const Icon(Icons.shield_outlined, size: 32, color: AppColors.primary),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'SEAL MOBILE',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Chakra Petch',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Center(
                      child: StatusChip(label: 'COMMAND DECK ACCESS', variant: StatusChipVariant.info, fontSize: 10),
                    ),
                    const SizedBox(height: 28),

                    // Login Panel
                    ClippedContainer(
                      padding: const EdgeInsets.all(18),
                      backgroundColor: AppColors.bgPanel,
                      borderColor: AppColors.borderMuted,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'TÀI KHOẢN HỆ THỐNG',
                            style: TextStyle(
                              fontFamily: 'Chakra Petch',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          AppTextField(
                            controller: _emailController,
                            label: 'Email sinh viên',
                            hint: 'student@fpt.edu.vn',
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: Icons.email_outlined,
                            errorText: vm.usernameError,
                          ),
                          const SizedBox(height: 14),
                          AppTextField(
                            controller: _passwordController,
                            label: 'Mật khẩu',
                            hint: '••••••••',
                            prefixIcon: Icons.lock_outline,
                            errorText: vm.passwordError,
                            obscureText: !_showPassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _showPassword ? Icons.visibility : Icons.visibility_off,
                                color: AppColors.textMuted,
                                size: 20,
                              ),
                              onPressed: () => setState(() => _showPassword = !_showPassword),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () => Navigator.of(context).pushNamed(RouteNames.forgotPassword),
                              child: const Text(
                                'Quên mật khẩu?',
                                style: TextStyle(fontFamily: 'Sora', fontSize: 13, color: AppColors.textMuted),
                              ),
                            ),
                          ),
                          if (vm.hasError && vm.errorMessage != null) ...[
                            const SizedBox(height: 10),
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
                    const SizedBox(height: 20),

                    // Google Login Ghost Button
                    OutlinedButton.icon(
                      onPressed: vm.isLoading ? null : () => _onGoogleLoginPressed(vm),
                      icon: const Icon(Icons.g_mobiledata, size: 24, color: AppColors.textPrimary),
                      label: const Text(
                        'Đăng nhập với Google',
                        style: TextStyle(fontFamily: 'Sora', fontSize: 14, color: AppColors.textPrimary),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.borderMuted),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Chưa có tài khoản? ', style: TextStyle(fontFamily: 'Sora', fontSize: 13, color: AppColors.textMuted)),
                        GestureDetector(
                          onTap: () async {
                            final email = await Navigator.of(context).pushNamed(RouteNames.register);
                            if (email is String && mounted) {
                              setState(() {
                                _bannerEmail = email;
                                _bannerActivated = false;
                              });
                              _startResendTimer();
                            }
                          },
                          child: const Text(
                            'Đăng ký',
                            style: TextStyle(fontFamily: 'Sora', fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Fixed Bottom CTA Action Bar (48pt height)
            Container(
              padding: const EdgeInsets.all(12),
              color: AppColors.bgPanel,
              child: AppButton(
                label: '// ĐĂNG NHẬP >',
                isLoading: vm.isLoading,
                onPressed: () => _onLoginPressed(vm),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
