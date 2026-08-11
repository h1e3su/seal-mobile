import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/di/locator.dart';
import '../../../app/router/route_names.dart';
import '../../common/widgets/app_button.dart';
import '../../common/widgets/app_text_field.dart';
import '../../common/widgets/loading_indicator.dart';
import '../viewmodels/login_viewmodel.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginViewModel>(
      create: (_) => locator<LoginViewModel>(),
      child: const _LoginBody(),
    );
  }
}

class _LoginBody extends StatefulWidget {
  const _LoginBody();

  @override
  State<_LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<_LoginBody> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLoginPressed(LoginViewModel vm) async {
    final success = await vm.login(
      _usernameController.text,
      _passwordController.text,
    );
    if (success && mounted) {
      Navigator.of(context).pushReplacementNamed(RouteNames.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LoginViewModel>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Đăng nhập',
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 24),
              AppTextField(
                controller: _usernameController,
                label: 'Tên đăng nhập',
                errorText: vm.usernameError,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _passwordController,
                label: 'Mật khẩu',
                errorText: vm.passwordError,
                obscureText: true,
              ),
              if (vm.hasError && vm.errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  vm.errorMessage!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
              const SizedBox(height: 24),
              vm.isLoading
                  ? const LoadingIndicator()
                  : AppButton(
                      label: 'Đăng nhập',
                      onPressed: () => _onLoginPressed(vm),
                    ),
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed(RouteNames.register),
                child: const Text('Chưa có tài khoản? Đăng ký'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context)
                    .pushNamed(RouteNames.forgotPassword),
                child: const Text('Quên mật khẩu?'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
