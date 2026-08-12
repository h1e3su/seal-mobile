import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/di/locator.dart';
import '../../../core/context/user_role_context.dart';
import '../../common/widgets/loading_indicator.dart';
import '../../event/views/event_list_view.dart';
import '../../mentor/views/mentor_dashboard_view.dart';
import '../../profile/views/profile_view.dart';
import '../../submission/views/submit_result_view.dart';
import '../../team/views/my_team_view.dart';
import '../viewmodels/home_viewmodel.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeViewModel>(
      create: (_) => locator<HomeViewModel>(),
      child: const _HomeBody(),
    );
  }
}

class _HomeBody extends StatefulWidget {
  const _HomeBody();

  @override
  State<_HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<_HomeBody> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeViewModel>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeVm = context.watch<HomeViewModel>();

    if (homeVm.isLoading) {
      return const Scaffold(
        body: Center(child: LoadingIndicator()),
      );
    }

    return Consumer<UserRoleContext>(
      builder: (context, roleContext, _) {
        final currentRole = roleContext.currentRole;

        final List<_HomeTabItem> tabs = [
          const _HomeTabItem(
            label: 'Sự kiện',
            icon: Icons.event,
            view: EventListView(),
          ),
        ];

        if (currentRole == null || currentRole.type == ActiveRoleType.student) {
          tabs.add(
            const _HomeTabItem(
              label: 'Đội thi',
              icon: Icons.groups,
              view: MyTeamView(),
            ),
          );
          tabs.add(
            const _HomeTabItem(
              label: 'Nộp bài',
              icon: Icons.upload_file,
              view: SubmitResultView(),
            ),
          );
        }

        if (currentRole != null && currentRole.type == ActiveRoleType.mentor) {
          tabs.add(
            const _HomeTabItem(
              label: 'Mentor',
              icon: Icons.supervisor_account,
              view: MentorDashboardView(),
            ),
          );
        }

        tabs.add(
          const _HomeTabItem(
            label: 'Cá nhân',
            icon: Icons.person,
            view: ProfileView(),
          ),
        );

        if (_currentIndex >= tabs.length) {
          _currentIndex = 0;
        }

        return Scaffold(
          appBar: roleContext.hasMultipleRoles
              ? AppBar(
                  title: DropdownButtonHideUnderline(
                    child: DropdownButton<ActiveRole>(
                      value: currentRole,
                      isExpanded: true,
                      items: roleContext.availableRoles.map((role) {
                        final roleName = role.type == ActiveRoleType.mentor
                            ? 'Mentor: ${role.trackName ?? "Hạng mục"}'
                            : 'Thí sinh: ${role.eventName}';
                        return DropdownMenuItem<ActiveRole>(
                          value: role,
                          child: Text(
                            roleName,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        );
                      }).toList(),
                      onChanged: (newRole) {
                        if (newRole != null) {
                          roleContext.switchRole(newRole);
                          setState(() {
                            _currentIndex = 0;
                          });
                        }
                      },
                    ),
                  ),
                )
              : null,
          body: IndexedStack(
            index: _currentIndex,
            children: tabs.map((t) => t.view).toList(),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: Colors.grey,
            items: tabs
                .map(
                  (t) => BottomNavigationBarItem(
                    icon: Icon(t.icon),
                    label: t.label,
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }
}

class _HomeTabItem {
  final String label;
  final IconData icon;
  final Widget view;

  const _HomeTabItem({
    required this.label,
    required this.icon,
    required this.view,
  });
}
