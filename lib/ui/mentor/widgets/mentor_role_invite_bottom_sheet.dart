import 'package:flutter/material.dart';
import '../../../app/router/route_names.dart';
import '../../../app/theme/app_colors.dart';
import '../../common/widgets/app_button.dart';

class MentorRoleInviteBottomSheet extends StatelessWidget {
  final String eventName;
  final String trackName;

  const MentorRoleInviteBottomSheet({
    super.key,
    this.eventName = 'SEAL Hackathon 2026',
    this.trackName = 'Track 1: AI & Data Science',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.bgPanel,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: AppColors.borderMuted, borderRadius: BorderRadius.all(Radius.circular(2))),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'LỜI MỜI THAM GIA MENTOR',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Chakra Petch',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.accentMentor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Ban Tổ Chức trân trọng mời bạn tham gia hướng dẫn (Mentor) cho sự kiện $eventName thuộc $trackName.',
            textAlign: TextAlign.center,
            style: const TextStyle(fontFamily: 'Sora', fontSize: 14, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: '[ CHẤP NHẬN ]',
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(RouteNames.mentorDashboard);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.statusDanger),
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: const Text(
                    '[ TỪ CHỐI ]',
                    style: TextStyle(fontFamily: 'Chakra Petch', fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.statusDanger),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
