import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/di/locator.dart';
import '../../../core/context/user_role_context.dart';
import '../../common/widgets/loading_indicator.dart';
import '../viewmodels/mentor_dashboard_viewmodel.dart';
import 'mentor_ranking_view.dart';
import 'mentor_team_list_view.dart';

class MentorDashboardView extends StatelessWidget {
  const MentorDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MentorDashboardViewModel>(
      create: (_) => locator<MentorDashboardViewModel>(),
      child: const _MentorDashboardBody(),
    );
  }
}

class _MentorDashboardBody extends StatefulWidget {
  const _MentorDashboardBody();

  @override
  State<_MentorDashboardBody> createState() => _MentorDashboardBodyState();
}

class _MentorDashboardBodyState extends State<_MentorDashboardBody> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentRole = context.read<UserRoleContext>().currentRole;
      if (currentRole?.trackId != null) {
        context.read<MentorDashboardViewModel>().loadDashboard(currentRole!.trackId!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final roleContext = context.watch<UserRoleContext>();
    final vm = context.watch<MentorDashboardViewModel>();
    final currentRole = roleContext.currentRole;
    final theme = Theme.of(context);

    if (currentRole == null || currentRole.type != ActiveRoleType.mentor) {
      return Scaffold(
        appBar: AppBar(title: const Text('Bảng điều khiển Mentor')),
        body: const Center(
          child: Text('Bạn chưa chọn vai trò Mentor.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bảng điều khiển Mentor'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          if (currentRole.trackId != null) {
            await vm.loadDashboard(currentRole.trackId!);
          }
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Track Info Banner
              Card(
                color: theme.colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(Icons.workspace_premium, size: 40, color: theme.colorScheme.onPrimaryContainer),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hạng mục: ${currentRole.trackName ?? "N/A"}',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onPrimaryContainer,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Sự kiện: ${currentRole.eventName}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Text(
                'Chức năng chính',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              if (vm.isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(child: LoadingIndicator()),
                )
              else ...[
                // Action Grid / Cards
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.groups, color: Colors.blue),
                    title: const Text('Danh sách đội thi'),
                    subtitle: Text('Đang theo dõi (${vm.teams.length} đội)'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const MentorTeamListView()),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.leaderboard, color: Colors.orange),
                    title: const Text('Bảng xếp hạng Hạng mục'),
                    subtitle: const Text('Xem xếp hạng sau khi công bố'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => MentorRankingView(roundId: currentRole.trackId ?? ''),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
