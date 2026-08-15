import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/router/route_names.dart';
import '../../../app/theme/app_colors.dart';
import '../../common/widgets/hud_card.dart';
import '../../common/widgets/status_chip.dart';
import '../../team/viewmodels/team_viewmodel.dart';
import '../viewmodels/submission_viewmodel.dart';

class SubmissionListView extends StatefulWidget {
  const SubmissionListView({super.key});

  @override
  State<SubmissionListView> createState() => _SubmissionListViewState();
}

class _SubmissionListViewState extends State<SubmissionListView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final teamId = context.read<TeamViewModel>().myTeam?.id;
      context.read<SubmissionViewModel>().loadSubmissions(teamId: teamId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SubmissionViewModel>(
      builder: (context, vm, _) {
        final submissions = vm.submissions;

        return Scaffold(
          backgroundColor: AppColors.bgBase,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.bgPanel,
            elevation: 0,
            title: const Text(
              'DANH SÁCH BÀI NỘP',
              style: TextStyle(
                fontFamily: 'Chakra Petch',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.add, color: AppColors.primary),
                onPressed: () => Navigator.of(context).pushNamed(RouteNames.submitEntry),
              ),
            ],
          ),
          body: vm.isLoading && submissions.isEmpty
              ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
              : submissions.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.assignment_outlined, size: 64, color: AppColors.textMuted),
                          const SizedBox(height: 16),
                          const Text(
                            'CHƯA CÓ BÀI DỰ THI NÀO ĐƯỢC NỘP',
                            style: TextStyle(fontFamily: 'Chakra Petch', fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Bấm nút bên dưới để tiến hành nộp bài dự thi cho đội của bạn.',
                            style: TextStyle(fontFamily: 'Sora', fontSize: 13, color: AppColors.textMuted),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                            onPressed: () => Navigator.of(context).pushNamed(RouteNames.submitEntry),
                            icon: const Icon(Icons.upload_file, color: AppColors.bgBase),
                            label: const Text('NỘP BÀI MỚI', style: TextStyle(fontFamily: 'Chakra Petch', fontWeight: FontWeight.bold, color: AppColors.bgBase)),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: submissions.length,
                      itemBuilder: (ctx, index) {
                        final item = submissions[index];
                        final isGraded = item.isGraded;

                        return HudCard(
                          margin: const EdgeInsets.only(bottom: 12),
                          accentBarColor: isGraded ? AppColors.accentMentor : AppColors.statusSuccess,
                          onTap: () {
                            vm.selectSubmission(item);
                            Navigator.of(context).pushNamed(RouteNames.submissionDetail);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.title.toUpperCase(),
                                      style: const TextStyle(
                                        fontFamily: 'Chakra Petch',
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                  StatusChip(
                                    label: isGraded ? 'ĐÃ CHẤM' : 'ĐÃ NỘP',
                                    variant: isGraded ? StatusChipVariant.info : StatusChipVariant.success,
                                    fontSize: 9,
                                  ),
                                ],
                              ),
                              if (item.trackName != null && item.trackName!.isNotEmpty) ...[
                                const SizedBox(height: 6),
                                Text(item.trackName!, style: const TextStyle(fontFamily: 'Sora', fontSize: 13, color: AppColors.textMuted)),
                              ],
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.submissionUrl,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontFamily: 'JetBrains Mono', fontSize: 12, color: AppColors.primary),
                                    ),
                                  ),
                                  if (item.finalScore != null)
                                    Text('Điểm: ${item.finalScore}', style: const TextStyle(fontFamily: 'JetBrains Mono', fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primary)),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.chevron_right, color: AppColors.primary, size: 18),
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
