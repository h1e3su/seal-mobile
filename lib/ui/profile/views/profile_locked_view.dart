import 'dart:async';
import 'package:flutter/material.dart';
import '../../../app/router/route_names.dart';
import '../../../app/theme/app_colors.dart';
import '../../common/widgets/app_button.dart';
import '../../common/widgets/clipped_container.dart';
import '../../common/widgets/status_chip.dart';

class ProfileLockedView extends StatefulWidget {
  const ProfileLockedView({super.key});

  @override
  State<ProfileLockedView> createState() => _ProfileLockedViewState();
}

class _ProfileLockedViewState extends State<ProfileLockedView> {
  bool _isRequested = false;
  Timer? _timer;
  Duration _countdown = const Duration(hours: 23, minutes: 59, seconds: 12);

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _onRequestUnblock() {
    setState(() {
      _isRequested = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_countdown.inSeconds > 0) {
        if (mounted) {
          setState(() {
            _countdown = _countdown - const Duration(seconds: 1);
          });
        }
      }
    });
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(d.inHours);
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Center(
                child: ClippedContainer(
                  width: 80,
                  height: 80,
                  backgroundColor: AppColors.statusWarning.withValues(alpha: 0.1),
                  borderColor: AppColors.statusWarning,
                  borderWidth: 2,
                  child: const Icon(Icons.warning_amber_rounded, size: 48, color: AppColors.statusWarning),
                ),
              ),
              const SizedBox(height: 24),
              const Center(
                child: StatusChip(
                  label: 'PROFILE LOCKED',
                  variant: StatusChipVariant.danger,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'HỒ SƠ BỊ KHÓA HỆ THỐNG',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Chakra Petch',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Hồ sơ đăng ký của bạn đã bị từ chối 2 lần trở lên. Bạn không thể thực hiện các thao tác trong cuộc thi cho đến khi được duyệt mở khóa.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Sora',
                  fontSize: 14,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 32),

              if (!_isRequested)
                AppButton(
                  label: '[ REQUEST UNBLOCK ]',
                  onPressed: _onRequestUnblock,
                )
              else
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.bgPanel,
                    border: Border.all(color: AppColors.statusWarning),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'ĐANG CHỜ BAN TỔ CHỨC XỬ LÝ',
                        style: TextStyle(fontFamily: 'Chakra Petch', fontSize: 13, color: AppColors.statusWarning, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Đang chờ xử lý — ${_formatDuration(_countdown)}',
                        style: const TextStyle(fontFamily: 'JetBrains Mono', fontSize: 16, color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 20),

              TextButton(
                onPressed: () => Navigator.of(context).pushNamed(RouteNames.rejectionHistory),
                child: const Text(
                  'Xem lịch sử từ chối hồ sơ',
                  style: TextStyle(fontFamily: 'Sora', fontSize: 13, color: AppColors.primary),
                ),
              ),

              const Spacer(),

              TextButton(
                onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(RouteNames.login, (r) => false),
                child: const Text(
                  'ĐĂNG XUẤT HỆ THỐNG',
                  style: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 12, color: AppColors.statusDanger),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
