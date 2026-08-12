import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/di/locator.dart';
import '../../../core/context/user_role_context.dart';
import '../../common/widgets/loading_indicator.dart';
import '../viewmodels/mentor_ranking_viewmodel.dart';

class MentorRankingView extends StatelessWidget {
  final String roundId;

  const MentorRankingView({
    super.key,
    required this.roundId,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MentorRankingViewModel>(
      create: (_) => locator<MentorRankingViewModel>(),
      child: _MentorRankingBody(roundId: roundId),
    );
  }
}

class _MentorRankingBody extends StatefulWidget {
  final String roundId;

  const _MentorRankingBody({required this.roundId});

  @override
  State<_MentorRankingBody> createState() => _MentorRankingBodyState();
}

class _MentorRankingBodyState extends State<_MentorRankingBody> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final trackId = context.read<UserRoleContext>().currentRole?.trackId ?? '';
      context.read<MentorRankingViewModel>().loadRanking(widget.roundId, trackId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MentorRankingViewModel>();
    final theme = Theme.of(context);

    if (vm.isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Bảng xếp hạng Hạng mục')),
        body: const Center(child: LoadingIndicator()),
      );
    }

    if (vm.hasError) {
      return Scaffold(
        appBar: AppBar(title: const Text('Bảng xếp hạng Hạng mục')),
        body: Center(
          child: Text(
            vm.errorMessage ?? 'Đã có lỗi xảy ra',
            style: TextStyle(color: theme.colorScheme.error),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bảng xếp hạng Hạng mục'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final trackId = context.read<UserRoleContext>().currentRole?.trackId ?? '';
          await vm.loadRanking(widget.roundId, trackId);
        },
        child: vm.results.isEmpty
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Text(
                    'Chưa có bảng xếp hạng được công bố cho Hạng mục này.',
                    style: TextStyle(fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16.0),
                itemCount: vm.results.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final result = vm.results[index];

                  Color rankColor = Colors.grey;
                  if (result.rank == 1) rankColor = Colors.amber;
                  if (result.rank == 2) rankColor = Colors.grey.shade400;
                  if (result.rank == 3) rankColor = Colors.brown.shade300;

                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: rankColor,
                        child: Text(
                          '#${result.rank}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        'Đội: ${result.teamId}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Điểm chung cuộc: ${result.finalScore.toStringAsFixed(2)}${result.isAdvanced ? " • Đi tiếp" : ""}',
                      ),
                      trailing: result.isAdvanced
                          ? const Icon(Icons.star, color: Colors.amber)
                          : null,
                    ),
                  );
                },
              ),
      ),
    );
  }
}
