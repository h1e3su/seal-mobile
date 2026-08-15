import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/router/route_names.dart';
import '../../../app/theme/app_colors.dart';
import '../../common/widgets/app_text_field.dart';
import '../../common/widgets/clipped_container.dart';
import '../../common/widgets/status_chip.dart';
import '../viewmodels/profile_viewmodel.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final _nameController = TextEditingController();
  String _lang = 'VI'; // EN / VI toggle

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<ProfileViewModel>();
      vm.fetchProfile().then((_) {
        if (vm.profile != null) {
          _nameController.text = vm.profile!.fullName;
        }
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _showLogoutDialog(BuildContext context, ProfileViewModel vm) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgPanel,
        title: const Text('XÁC NHẬN ĐĂNG XUẤT', style: TextStyle(fontFamily: 'Chakra Petch', color: AppColors.statusDanger)),
        content: const Text('Bạn có muốn đăng xuất khỏi hệ thống SEAL Mobile?', style: TextStyle(fontFamily: 'Sora', color: AppColors.textPrimary)),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('HỦY BỎ', style: TextStyle(color: AppColors.textMuted))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.statusDanger),
            onPressed: () async {
              Navigator.of(ctx).pop();
              await vm.logout();
              if (context.mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(RouteNames.login, (r) => false);
              }
            },
            child: const Text('ĐĂNG XUẤT', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(
      builder: (context, vm, _) {
        final profile = vm.profile;

        return Scaffold(
          backgroundColor: AppColors.bgBase,
          appBar: AppBar(
            backgroundColor: AppColors.bgPanel,
            elevation: 0,
            title: const Text(
              'PROFILE & SETTINGS',
              style: TextStyle(
                fontFamily: 'Chakra Petch',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          body: SafeArea(
            child: vm.isLoading && profile == null
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Avatar & Change Photo
                              Center(
                                child: Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 44,
                                      backgroundColor: AppColors.surfaceContainerHigh,
                                      child: Text(
                                        profile != null && profile.fullName.isNotEmpty ? profile.fullName[0] : 'U',
                                        style: const TextStyle(fontFamily: 'Chakra Petch', fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primary),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                                        child: const Icon(Icons.camera_alt, size: 16, color: AppColors.bgBase),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),

                              if (profile != null) ...[
                                Center(
                                  child: Text(
                                    profile.fullName,
                                    style: const TextStyle(fontFamily: 'Chakra Petch', fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Center(
                                  child: Text(
                                    profile.email,
                                    style: const TextStyle(fontFamily: 'JetBrains Mono', fontSize: 12, color: AppColors.textMuted),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Center(
                                  child: StatusChip(
                                    label: profile.registrationStatus.toUpperCase(),
                                    variant: profile.isApproved
                                        ? StatusChipVariant.success
                                        : (profile.isRejected ? StatusChipVariant.danger : StatusChipVariant.warning),
                                    fontSize: 9,
                                  ),
                                ),
                              ],

                              const SizedBox(height: 20),

                              ClippedContainer(
                                padding: const EdgeInsets.all(18),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    AppTextField(
                                      controller: _nameController,
                                      label: 'Tên hiển thị',
                                      prefixIcon: Icons.badge,
                                    ),
                                    const SizedBox(height: 16),
                                    ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      leading: const Icon(Icons.school_outlined, color: AppColors.primary),
                                      title: const Text('Xác minh hồ sơ sinh viên', style: TextStyle(fontFamily: 'Sora', fontSize: 14, color: AppColors.textPrimary)),
                                      subtitle: Text(
                                        profile?.schoolName ?? 'Chưa xác minh trường học',
                                        style: const TextStyle(fontFamily: 'Sora', fontSize: 12, color: AppColors.textMuted),
                                      ),
                                      trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
                                      onTap: () => Navigator.of(context).pushNamed(RouteNames.profileVerification),
                                    ),
                                    const Divider(color: AppColors.borderMuted),
                                    ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      leading: const Icon(Icons.lock_reset, color: AppColors.primary),
                                      title: const Text('Đổi mật khẩu', style: TextStyle(fontFamily: 'Sora', fontSize: 14, color: AppColors.textPrimary)),
                                      trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
                                      onTap: () => Navigator.of(context).pushNamed(RouteNames.forgotPassword),
                                    ),
                                    const Divider(color: AppColors.borderMuted),
                                    ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      leading: const Icon(Icons.history, color: AppColors.primary),
                                      title: const Text('Lịch sử từ chối hồ sơ', style: TextStyle(fontFamily: 'Sora', fontSize: 14, color: AppColors.textPrimary)),
                                      trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
                                      onTap: () => Navigator.of(context).pushNamed(RouteNames.rejectionHistory),
                                    ),
                                    const Divider(color: AppColors.borderMuted),

                                    // EN / VI Text Toggle Pill
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('Ngôn ngữ hiển thị', style: TextStyle(fontFamily: 'Sora', fontSize: 14, color: AppColors.textPrimary)),
                                        Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(color: AppColors.bgInput, borderRadius: BorderRadius.circular(20)),
                                          child: Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () => setState(() => _lang = 'VI'),
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: _lang == 'VI' ? AppColors.primary : Colors.transparent,
                                                    borderRadius: BorderRadius.circular(16),
                                                  ),
                                                  child: Text('VI', style: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 12, fontWeight: FontWeight.bold, color: _lang == 'VI' ? AppColors.bgBase : AppColors.textMuted)),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () => setState(() => _lang = 'EN'),
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: _lang == 'EN' ? AppColors.primary : Colors.transparent,
                                                    borderRadius: BorderRadius.circular(16),
                                                  ),
                                                  child: Text('EN', style: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 12, fontWeight: FontWeight.bold, color: _lang == 'EN' ? AppColors.bgBase : AppColors.textMuted)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Red Ghost Logout Button
                      Container(
                        padding: const EdgeInsets.all(12),
                        color: AppColors.bgPanel,
                        child: OutlinedButton(
                          onPressed: () => _showLogoutDialog(context, vm),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.statusDanger),
                            minimumSize: const Size(double.infinity, 48),
                          ),
                          child: const Text(
                            '[ ĐĂNG XUẤT ]',
                            style: TextStyle(fontFamily: 'Chakra Petch', fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.statusDanger),
                          ),
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
