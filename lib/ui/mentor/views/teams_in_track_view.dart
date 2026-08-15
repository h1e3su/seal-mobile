import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/router/route_names.dart';
import '../../../app/theme/app_colors.dart';
import '../../common/widgets/hud_card.dart';
import '../../common/widgets/status_chip.dart';
import '../viewmodels/mentor_viewmodel.dart';

class TeamsInTrackView extends StatelessWidget {
  const TeamsInTrackView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MentorViewModel>(
      builder: (context, vm, _) {
        final teams = vm.teams;
        final trackName = vm.currentTrack?.name ?? 'TRACK';

        return Scaffold(
          backgroundColor: AppColors.bgBase,
          appBar: AppBar(
            backgroundColor: AppColors.bgPanel,
            elevation: 0,
            title: Text(
              'TEAMS :: ${trackName.toUpperCase()}',
              style: const TextStyle(
                fontFamily: 'Chakra Petch',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          body: vm.isLoading && teams.isEmpty
              ? const Center(child: CircularProgressIndicator(color: AppColors.accentMentor))
              : teams.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.groups_outlined, size: 64, color: AppColors.textMuted),
                          const SizedBox(height: 16),
                          const Text(
                            'CHƯA CÓ ĐỘI THI TRONG HẠNG MỤC NÀY',
                            style: TextStyle(fontFamily: 'Chakra Petch', fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Các đội thi đăng ký hạng mục này sẽ xuất hiện tại đây.',
                            style: TextStyle(fontFamily: 'Sora', fontSize: 13, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: teams.length,
                      itemBuilder: (ctx, index) {
                        final t = teams[index];
                        final isRegistered = t.isRegistered;
                        final members = t.members;

                        return HudCard(
                          margin: const EdgeInsets.only(bottom: 12),
                          accentBarColor: isRegistered ? AppColors.accentMentor : AppColors.statusWarning,
                          onTap: () {
                            Navigator.of(context).pushNamed(RouteNames.teamViewer, arguments: t);
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
                                      style: const TextStyle(fontFamily: 'Chakra Petch', fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                                    ),
                                  ),
                                  StatusChip(
                                    label: t.status.toUpperCase(),
                                    variant: isRegistered ? StatusChipVariant.success : StatusChipVariant.warning,
                                    fontSize: 9,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              // Avatar Stack of Members
                              Row(
                                children: [
                                  if (members.isEmpty)
                                    const Text('Chưa có thành viên', style: TextStyle(fontFamily: 'Sora', fontSize: 11, color: AppColors.textMuted))
                                  else ...[
                                    ...members.take(4).map((m) => Padding(
                                          padding: const EdgeInsets.only(right: 6),
                                          child: CircleAvatar(
                                            radius: 12,
                                            backgroundColor: AppColors.surfaceContainerHigh,
                                            child: Text(
                                              m.fullName.isNotEmpty ? m.fullName[0] : 'U',
                                              style: const TextStyle(fontFamily: 'Sora', fontSize: 10, color: AppColors.textPrimary),
                                            ),
                                          ),
                                        )),
                                    if (members.length > 4)
                                      CircleAvatar(
                                        radius: 12,
                                        backgroundColor: AppColors.bgInput,
                                        child: Text('+${members.length - 4}', style: const TextStyle(fontFamily: 'JetBrains Mono', fontSize: 10, color: AppColors.primary)),
                                      ),
                                  ],
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
