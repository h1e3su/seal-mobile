import 'package:flutter/material.dart';
import '../../app/router/route_names.dart';
import '../../app/theme/app_colors.dart';
import '../../ui/profile/viewmodels/profile_viewmodel.dart';

class StudentVerificationGuard {
  static Future<bool> ensureVerified(
    BuildContext context,
    ProfileViewModel profileVm, {
    String actionName = 'tạo đội hoặc tham gia sự kiện',
  }) async {
    if (profileVm.profile == null) {
      await profileVm.fetchProfile();
    }

    final profile = profileVm.profile;

    if (profile == null || !profile.isApproved) {
      if (!context.mounted) return false;

      final isPending = profile?.isPending ?? false;

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppColors.bgPanel,
          title: Row(
            children: [
              Icon(
                isPending ? Icons.hourglass_top : Icons.gpp_maybe,
                color: isPending ? AppColors.statusWarning : AppColors.statusDanger,
                size: 22,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'YÊU CẦU XÁC MINH',
                  style: TextStyle(
                    fontFamily: 'Chakra Petch',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            isPending
                ? 'Hồ sơ sinh viên của bạn đang chờ Ban Tổ Chức phê duyệt. Bạn sẽ có thể $actionName sau khi hồ sơ được duyệt.'
                : 'Bạn cần hoàn tất xác minh hồ sơ sinh viên để được $actionName.',
            style: const TextStyle(
              fontFamily: 'Sora',
              fontSize: 13,
              color: AppColors.textPrimary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('ĐỂ SAU', style: TextStyle(fontFamily: 'Sora', color: AppColors.textMuted)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).pushNamed(RouteNames.profileVerification);
              },
              child: Text(
                isPending ? 'XEM HỒ SƠ' : 'XÁC MINH NGAY',
                style: const TextStyle(fontFamily: 'Sora', fontWeight: FontWeight.bold, color: AppColors.bgBase),
              ),
            ),
          ],
        ),
      );
      return false;
    }

    return true;
  }
}
