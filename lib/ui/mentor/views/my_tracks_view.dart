import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/router/route_names.dart';
import '../../../app/theme/app_colors.dart';
import '../../common/widgets/hud_card.dart';
import '../../common/widgets/status_chip.dart';
import '../viewmodels/mentor_viewmodel.dart';

class MyTracksView extends StatefulWidget {
  const MyTracksView({super.key});

  @override
  State<MyTracksView> createState() => _MyTracksViewState();
}

class _MyTracksViewState extends State<MyTracksView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MentorViewModel>().loadMyTracks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MentorViewModel>(
      builder: (context, vm, _) {
        final tracks = vm.myTracks;

        return Scaffold(
          backgroundColor: AppColors.bgBase,
          appBar: AppBar(
            backgroundColor: AppColors.bgPanel,
            elevation: 0,
            title: const Text(
              'MY ASSIGNED TRACKS',
              style: TextStyle(
                fontFamily: 'Chakra Petch',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh, color: AppColors.primary),
                onPressed: () => vm.loadMyTracks(),
              ),
            ],
          ),
          body: vm.isLoading && tracks.isEmpty
              ? const Center(child: CircularProgressIndicator(color: AppColors.accentMentor))
              : tracks.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.psychology_outlined, size: 64, color: AppColors.textMuted),
                          const SizedBox(height: 16),
                          const Text(
                            'CHƯA CÓ HẠNG MỤC PHÂN CÔNG',
                            style: TextStyle(fontFamily: 'Chakra Petch', fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Khi Ban tổ chức phân công phụ trách Track, danh sách sẽ hiển thị tại đây.',
                            style: TextStyle(fontFamily: 'Sora', fontSize: 13, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: tracks.length,
                      itemBuilder: (ctx, index) {
                        final t = tracks[index];
                        return HudCard(
                          margin: const EdgeInsets.only(bottom: 12),
                          accentBarColor: AppColors.accentMentor,
                          onTap: () {
                            vm.loadTrackWorkspace(t.id);
                            Navigator.of(context).pushNamed(RouteNames.teamsInTrack);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      t.name.toUpperCase(),
                                      style: const TextStyle(
                                        fontFamily: 'Chakra Petch',
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                  const StatusChip(
                                    label: 'ASSIGNED',
                                    variant: StatusChipVariant.info,
                                    customColor: AppColors.accentMentor,
                                    fontSize: 9,
                                  ),
                                ],
                              ),
                              if (t.description != null && t.description!.isNotEmpty) ...[
                                const SizedBox(height: 6),
                                Text(t.description!, style: const TextStyle(fontFamily: 'Sora', fontSize: 13, color: AppColors.textMuted)),
                              ],
                              const SizedBox(height: 10),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Chạm để xem các đội thi trong Track >', style: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 12, color: AppColors.primary)),
                                  Icon(Icons.chevron_right, color: AppColors.accentMentor),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
        );
      },
    );
  }
}
