import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../common/widgets/clipped_container.dart';
import '../../common/widgets/hud_card.dart';
import '../../common/widgets/status_chip.dart';

class TeamViewerView extends StatelessWidget {
  const TeamViewerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      appBar: AppBar(
        backgroundColor: AppColors.bgPanel,
        elevation: 0,
        title: const Text(
          'TEAM & SUBMISSION VIEWER',
          style: TextStyle(
            fontFamily: 'Chakra Petch',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Team Read-only Roster Card
            HudCard(
              accentBarColor: AppColors.accentMentor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('CYBER OPERATIVES', style: TextStyle(fontFamily: 'Chakra Petch', fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                      StatusChip(label: 'READ ONLY', variant: StatusChipVariant.info, fontSize: 9),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text('Mã tham gia: TEAM-8821', style: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 12, color: AppColors.textMuted)),
                  const SizedBox(height: 12),
                  const Text('DANH SÁCH THÀNH VIÊN (READ-ONLY)', style: TextStyle(fontFamily: 'Chakra Petch', fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.accentMentor)),
                  const SizedBox(height: 8),
                  _buildMemberRow('Lê Văn A', 'Trưởng nhóm'),
                  _buildMemberRow('Nguyễn Văn B', 'Thành viên'),
                  _buildMemberRow('Trần Thị C', 'Thành viên'),
                  _buildMemberRow('Phạm Văn D', 'Thành viên'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Submission Progress Card (M4 spec: strictly no edit/grading buttons)
            ClippedContainer(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('TIẾN ĐỘ NỘP BÀI THUỘC TRACK', style: TextStyle(fontFamily: 'Chakra Petch', fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                      StatusChip(label: 'SUBMITTED', variant: StatusChipVariant.success, fontSize: 9),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('Repository:', style: TextStyle(fontFamily: 'Sora', fontSize: 12, color: AppColors.textMuted)),
                  const SizedBox(height: 2),
                  const Text('https://github.com/seal-project/mobile-app', style: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 13, color: AppColors.primary)),
                  const SizedBox(height: 10),
                  const Text('Mô tả sản phẩm:', style: TextStyle(fontFamily: 'Sora', fontSize: 12, color: AppColors.textMuted)),
                  const SizedBox(height: 2),
                  const Text('Hệ thống quản lý vòng đời sự kiện SEAL Mobile với giao diện Tactical HUD.', style: TextStyle(fontFamily: 'Sora', fontSize: 13, color: AppColors.textPrimary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberRow(String name, String role) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          const Icon(Icons.person_outline, size: 14, color: AppColors.textMuted),
          const SizedBox(width: 6),
          Text(name, style: const TextStyle(fontFamily: 'Sora', fontSize: 13, color: AppColors.textPrimary)),
          const Spacer(),
          Text(role, style: const TextStyle(fontFamily: 'Sora', fontSize: 11, color: AppColors.textMuted)),
        ],
      ),
    );
  }
}
