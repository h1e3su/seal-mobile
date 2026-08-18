import 'package:flutter/material.dart';
import '../../../app/router/route_names.dart';
import '../../../app/theme/app_colors.dart';
import '../../mentor/views/mentor_home_view.dart';
import '../../mentor/views/my_tracks_view.dart';
import '../../mentor/views/teams_in_track_view.dart';
import '../../notifications/views/notifications_view.dart';

class MentorShellView extends StatefulWidget {
  final int initialTab;
  const MentorShellView({super.key, this.initialTab = 0});

  @override
  State<MentorShellView> createState() => _MentorShellViewState();
}

class _MentorShellViewState extends State<MentorShellView> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab;
  }

  final List<Widget> _pages = const [
    MentorHomeView(),
    MyTracksView(),
    TeamsInTrackView(),
    NotificationsView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      appBar: _currentIndex == 0
          ? AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: AppColors.bgPanel,
              elevation: 0,
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.accentMentor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: AppColors.accentMentor, width: 1),
                    ),
                    child: const Icon(Icons.psychology, size: 16, color: AppColors.accentMentor),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'SEAL :: MENTOR DECK',
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
                  icon: const CircleAvatar(
                    radius: 13,
                    backgroundColor: AppColors.bgInput,
                    child: Icon(Icons.person, size: 16, color: AppColors.accentMentor),
                  ),
                  onPressed: () => Navigator.of(context).pushNamed(RouteNames.profile),
                ),
                const SizedBox(width: 8),
              ],
            )
          : null,
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
          selectedItemColor: AppColors.accentMentor,
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
            _buildNavItem(Icons.dashboard_outlined, Icons.dashboard, 'HOME', 0),
            _buildNavItem(Icons.alt_route_outlined, Icons.alt_route, 'MY TRACKS', 1),
            _buildNavItem(Icons.groups_outlined, Icons.groups, 'TEAMS', 2),
            _buildNavItem(Icons.notifications_outlined, Icons.notifications, 'NOTIFS', 3),
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
              ? const Border(top: BorderSide(color: AppColors.accentMentor, width: 2.0))
              : null,
        ),
        child: Icon(isSelected ? selectedIcon : unselectedIcon),
      ),
      label: label,
    );
  }
}
