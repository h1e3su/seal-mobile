import 'package:flutter/material.dart';
import '../../../app/router/route_names.dart';
import '../../../app/theme/app_colors.dart';
import '../../home/views/home_view.dart';
import '../../team/views/my_team_view.dart';
import '../../submission/views/submission_list_view.dart';
import '../../leaderboard/views/leaderboard_view.dart';

class ContestantShellView extends StatefulWidget {
  final int initialTab;
  const ContestantShellView({super.key, this.initialTab = 0});

  @override
  State<ContestantShellView> createState() => _ContestantShellViewState();
}

class _ContestantShellViewState extends State<ContestantShellView> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab;
  }

  final List<Widget> _pages = const [
    HomeView(),
    MyTeamView(),
    SubmissionListView(),
    LeaderboardView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.bgPanel,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: AppColors.primary, width: 1),
              ),
              child: const Icon(Icons.shield, size: 16, color: AppColors.primary),
            ),
            const SizedBox(width: 10),
            const Text(
              'SEAL :: CONTESTANT',
              style: TextStyle(
                fontFamily: 'Chakra Petch',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: AppColors.primary),
            onPressed: () => Navigator.of(context).pushNamed(RouteNames.notifications),
          ),
          IconButton(
            icon: const CircleAvatar(
              radius: 13,
              backgroundColor: AppColors.bgInput,
              child: Icon(Icons.person, size: 16, color: AppColors.accentTeam),
            ),
            onPressed: () => Navigator.of(context).pushNamed(RouteNames.profile),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.bgPanel,
          border: Border(
            top: BorderSide(color: AppColors.borderMuted, width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: AppColors.bgPanel,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textMuted,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(
            fontFamily: 'JetBrains Mono',
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: const TextStyle(
            fontFamily: 'JetBrains Mono',
            fontSize: 10,
          ),
          items: [
            _buildNavItem(Icons.grid_view_outlined, Icons.grid_view, 'HOME', 0),
            _buildNavItem(Icons.groups_outlined, Icons.groups, 'MY TEAM', 1),
            _buildNavItem(Icons.file_present_outlined, Icons.file_present, 'SUBMIT', 2),
            _buildNavItem(Icons.leaderboard_outlined, Icons.leaderboard, 'RANKING', 3),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(IconData unselectedIcon, IconData selectedIcon, String label, int index) {
    final isSelected = _currentIndex == index;
    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.only(top: 4),
        decoration: BoxDecoration(
          border: isSelected
              ? const Border(top: BorderSide(color: AppColors.primary, width: 2.0))
              : null,
        ),
        child: Icon(isSelected ? selectedIcon : unselectedIcon),
      ),
      label: label,
    );
  }
}
