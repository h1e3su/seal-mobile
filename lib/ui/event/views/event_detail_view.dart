import 'package:flutter/material.dart';
import '../../../app/router/route_names.dart';
import '../../../app/theme/app_colors.dart';
import '../../common/widgets/app_button.dart';
import '../../common/widgets/app_text_field.dart';
import '../../common/widgets/clipped_container.dart';

class EventDetailView extends StatefulWidget {
  const EventDetailView({super.key});

  @override
  State<EventDetailView> createState() => _EventDetailViewState();
}

class _EventDetailViewState extends State<EventDetailView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showJoinTeamBottomSheet() {
    final codeController = TextEditingController();
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgPanel,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'NHẬP MÃ ĐỘI THI',
              style: TextStyle(
                fontFamily: 'Chakra Petch',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: codeController,
              label: 'Mã tham gia (6-8 ký tự)',
              hint: 'Ví dụ: TEAM-8821',
              prefixIcon: Icons.qr_code,
            ),
            const SizedBox(height: 20),
            AppButton(
              label: 'XÁC NHẬN VÀO ĐỘI',
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).pushNamed(RouteNames.myTeam);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      appBar: AppBar(
        backgroundColor: AppColors.bgPanel,
        elevation: 0,
        title: const Text(
          'CHI TIẾT SỰ KIỆN',
          style: TextStyle(
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
            // Event Banner
            Container(
              height: 140,
              width: double.infinity,
              color: AppColors.surfaceContainerHigh,
              child: Stack(
                children: [
                  const Center(
                    child: Icon(Icons.workspace_premium, size: 64, color: AppColors.primary),
                  ),
                  Positioned(
                    bottom: 12,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      color: AppColors.bgBase.withValues(alpha: 0.8),
                      child: const Text(
                        'SEAL HACKATHON 2026',
                        style: TextStyle(fontFamily: 'Chakra Petch', fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Sub-tabs (Luật chơi | Timeline | Hạng mục)
            Container(
              color: AppColors.bgPanel,
              child: TabBar(
                controller: _tabController,
                indicatorColor: AppColors.primary,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textMuted,
                labelStyle: const TextStyle(fontFamily: 'Chakra Petch', fontWeight: FontWeight.bold, fontSize: 13),
                tabs: const [
                  Tab(text: 'LUẬT CHƠI'),
                  Tab(text: 'TIMELINE'),
                  Tab(text: 'HẠNG MỤC (TRACK)'),
                ],
              ),
            ),

            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Tab 1: Rules
                  ListView(
                    padding: const EdgeInsets.all(16),
                    children: const [
                      ClippedContainer(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Quy định đội thi:', style: TextStyle(fontFamily: 'Chakra Petch', fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary)),
                            SizedBox(height: 8),
                            Text('• Mỗi đội từ 3 đến 5 thành viên.\n• Tất cả thành viên phải hoàn tất xác minh hồ sơ sinh viên.\n• Không được nộp sản phẩm trùng lặp.', style: TextStyle(fontFamily: 'Sora', fontSize: 13, color: AppColors.textPrimary)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Tab 2: Timeline
                  ListView(
                    padding: const EdgeInsets.all(16),
                    children: const [
                      ClippedContainer(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Lịch trình chính:', style: TextStyle(fontFamily: 'Chakra Petch', fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary)),
                            SizedBox(height: 8),
                            Text('• Mở đăng ký: 15/08/2026\n• Hạn chốt đội: 25/08/2026\n• Vòng 1 Nộp bài: 05/09/2026\n• Chung kết: 30/09/2026', style: TextStyle(fontFamily: 'Sora', fontSize: 13, color: AppColors.textPrimary)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Tab 3: Tracks
                  ListView(
                    padding: const EdgeInsets.all(16),
                    children: const [
                      ClippedContainer(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Các Hạng Mục (Tracks):', style: TextStyle(fontFamily: 'Chakra Petch', fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary)),
                            SizedBox(height: 8),
                            Text('1. AI & Machine Learning Innovations\n2. Smart IoT & Embedded Systems\n3. Web3 & Blockchain Applications', style: TextStyle(fontFamily: 'Sora', fontSize: 13, color: AppColors.textPrimary)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Fixed Bottom Action Bar (C5 spec)
            Container(
              padding: const EdgeInsets.all(12),
              color: AppColors.bgPanel,
              child: Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: '[ TẠO ĐỘI ]',
                      onPressed: () => Navigator.of(context).pushNamed(RouteNames.myTeam),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppButton(
                      label: '[ VÀO ĐỘI ]',
                      variant: AppButtonVariant.secondary,
                      onPressed: _showJoinTeamBottomSheet,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
