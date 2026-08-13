import 'package:flutter/material.dart';
import '../../../app/router/route_names.dart';
import '../../../app/theme/app_colors.dart';
import '../../common/widgets/app_button.dart';

class TeamInviteBottomSheet extends StatelessWidget {
  final String teamName;
  final String inviterName;

  const TeamInviteBottomSheet({
    super.key,
    this.teamName = 'CYBER OPERATIVES',
    this.inviterName = 'Lê Văn A',
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
            'LỜI MỜI THAM GIA ĐỘI THI',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Chakra Petch',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '$inviterName đã mời bạn tham gia vào đội thi $teamName.',
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
                    Navigator.of(context).pushNamed(RouteNames.myTeam);
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
