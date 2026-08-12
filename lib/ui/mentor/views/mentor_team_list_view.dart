import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/di/locator.dart';
import '../../../core/context/user_role_context.dart';
import '../../common/widgets/loading_indicator.dart';
import '../viewmodels/mentor_dashboard_viewmodel.dart';
import 'team_score_breakdown_view.dart';

class MentorTeamListView extends StatelessWidget {
  const MentorTeamListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MentorDashboardViewModel>(
      create: (_) => locator<MentorDashboardViewModel>(),
      child: const _MentorTeamListBody(),
    );
  }
}

class _MentorTeamListBody extends StatefulWidget {
  const _MentorTeamListBody();

  @override
  State<_MentorTeamListBody> createState() => _MentorTeamListBodyState();
}

class _MentorTeamListBodyState extends State<_MentorTeamListBody> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final roleContext = context.read<UserRoleContext>();
      final trackId = roleContext.currentRole?.trackId;
      if (trackId != null) {
        context.read<MentorDashboardViewModel>().loadDashboard(trackId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MentorDashboardViewModel>();
    final theme = Theme.of(context);

    if (vm.isLoading) {
      return const Scaffold(
        body: Center(child: LoadingIndicator()),
      );
    }

    if (vm.hasError) {
      return Scaffold(
        appBar: AppBar(title: const Text('Đội thi Hạng mục')),
        body: Center(
          child: Text(vm.errorMessage ?? 'Đã có lỗi xảy ra', style: TextStyle(color: theme.colorScheme.error)),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Đội thi trong Hạng mục'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final trackId = context.read<UserRoleContext>().currentRole?.trackId;
          if (trackId != null) {
            await vm.loadDashboard(trackId);
          }
        },
        child: vm.teams.isEmpty
            ? const Center(child: Text('Chưa có đội thi nào trong Hạng mục này.'))
            : ListView.separated(
                padding: const EdgeInsets.all(16.0),
                itemCount: vm.teams.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final team = vm.teams[index];
                  return Card(
                    child: ListTile(
                      title: Text(
                        team.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('Trưởng nhóm: ${team.leaderName ?? "Chưa rõ"} • Trạng thái: ${team.status}'),
                      trailing: ElevatedButton.icon(
                        icon: const Icon(Icons.analytics, size: 18),
                        label: const Text('Xem điểm'),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => TeamScoreBreakdownView(teamId: team.id),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
