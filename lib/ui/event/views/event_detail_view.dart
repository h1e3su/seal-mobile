import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/router/route_names.dart';
import '../../../app/theme/app_colors.dart';
import '../../common/widgets/app_button.dart';
import '../../common/widgets/app_text_field.dart';
import '../../common/widgets/clipped_container.dart';
import '../../../data/models/event/event_model.dart';
import '../../../core/utils/student_verification_guard.dart';
import '../../profile/viewmodels/profile_viewmodel.dart';
import '../viewmodels/event_viewmodel.dart';

class EventDetailView extends StatefulWidget {
  final EventModel? event;
  const EventDetailView({super.key, this.event});

  @override
  State<EventDetailView> createState() => _EventDetailViewState();
}

class _EventDetailViewState extends State<EventDetailView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final eventId = widget.event?.id ?? 'evt_001';
      context.read<EventViewModel>().loadEventDetails(eventId);
    });
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
    final eventVm = context.watch<EventViewModel>();
    final event = widget.event ?? eventVm.selectedEvent ?? const EventModel(
      id: 'evt_001',
      title: 'SEAL HACKATHON 2026',
      description: 'Cuộc thi phát triển giải pháp công nghệ số cho sinh viên toàn quốc.',
    );

    final rounds = eventVm.selectedEventRounds;
    final tracks = eventVm.selectedEventTracks;

    return Scaffold(
      backgroundColor: AppColors.bgBase,
      appBar: AppBar(
        backgroundColor: AppColors.bgPanel,
        elevation: 0,
        title: Text(
          event.title.toUpperCase(),
          style: const TextStyle(
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
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      color: AppColors.bgBase.withValues(alpha: 0.8),
                      child: Text(
                        event.title.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontFamily: 'Chakra Petch', fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
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
                  // Tab 1: Rules & Description
                  ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      ClippedContainer(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Mô tả sự kiện:', style: TextStyle(fontFamily: 'Chakra Petch', fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary)),
                            const SizedBox(height: 8),
                            Text(event.description, style: const TextStyle(fontFamily: 'Sora', fontSize: 13, color: AppColors.textPrimary)),
                            const SizedBox(height: 16),
                            const Text('Quy định đội thi:', style: TextStyle(fontFamily: 'Chakra Petch', fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary)),
                            const SizedBox(height: 8),
                            const Text('• Mỗi đội từ 3 đến 5 thành viên.\n• 100% thành viên phải hoàn tất duyệt hồ sơ sinh viên.\n• Không được nộp sản phẩm sao chép hoặc trùng lặp.', style: TextStyle(fontFamily: 'Sora', fontSize: 13, color: AppColors.textPrimary)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Tab 2: Timeline / Rounds
                  ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      if (rounds.isEmpty)
                        const ClippedContainer(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            '• Mở đăng ký: 15/08/2026\n• Vòng 1 (Sơ loại): 05/09/2026\n• Vòng 2 (Chung kết): 30/09/2026',
                            style: TextStyle(fontFamily: 'Sora', fontSize: 13, color: AppColors.textPrimary),
                          ),
                        )
                      else
                        ...rounds.map((r) => ClippedContainer(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${r.order}. ${r.roundName.toUpperCase()}',
                                    style: const TextStyle(fontFamily: 'Chakra Petch', fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary),
                                  ),
                                  if (r.advancementRule != null) ...[
                                    const SizedBox(height: 6),
                                    Text('Điều kiện: ${r.advancementRule}', style: const TextStyle(fontFamily: 'Sora', fontSize: 12, color: AppColors.textMuted)),
                                  ],
                                ],
                              ),
                            )),
                    ],
                  ),
                  // Tab 3: Tracks
                  ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      if (tracks.isEmpty)
                        const ClippedContainer(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            '1. AI Innovation & Machine Learning\n2. Mobile App Architecture\n3. Web3 & Blockchain Systems',
                            style: TextStyle(fontFamily: 'Sora', fontSize: 13, color: AppColors.textPrimary),
                          ),
                        )
                      else
                        ...tracks.map((t) => ClippedContainer(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    t.name.toUpperCase(),
                                    style: const TextStyle(fontFamily: 'Chakra Petch', fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary),
                                  ),
                                  if (t.description != null && t.description!.isNotEmpty) ...[
                                    const SizedBox(height: 6),
                                    Text(t.description!, style: const TextStyle(fontFamily: 'Sora', fontSize: 12, color: AppColors.textMuted)),
                                  ],
                                ],
                              ),
                            )),
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
                      onPressed: () async {
                        final profileVm = context.read<ProfileViewModel>();
                        final canProceed = await StudentVerificationGuard.ensureVerified(
                          context,
                          profileVm,
                          actionName: 'tạo đội thi cho sự kiện này',
                        );
                        if (canProceed && context.mounted) {
                          Navigator.of(context).pushNamed(RouteNames.createTeam);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppButton(
                      label: '[ VÀO ĐỘI ]',
                      variant: AppButtonVariant.secondary,
                      onPressed: () async {
                        final profileVm = context.read<ProfileViewModel>();
                        final canProceed = await StudentVerificationGuard.ensureVerified(
                          context,
                          profileVm,
                          actionName: 'gia nhập đội thi sự kiện này',
                        );
                        if (canProceed && context.mounted) {
                          _showJoinTeamBottomSheet();
                        }
                      },
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
