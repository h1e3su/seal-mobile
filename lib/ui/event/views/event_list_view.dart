import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/di/locator.dart';
import '../../../app/router/route_names.dart';
import '../../../app/theme/app_colors.dart';
import '../../common/widgets/app_text_field.dart';
import '../../common/widgets/hud_card.dart';
import '../../common/widgets/status_chip.dart';
import '../../../data/models/event/event_model.dart';
import '../viewmodels/event_viewmodel.dart';

class EventListView extends StatelessWidget {
  const EventListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EventViewModel>(
      create: (_) => locator<EventViewModel>()..loadEvents(),
      child: const _EventListBody(),
    );
  }
}

class _EventListBody extends StatefulWidget {
  const _EventListBody();

  @override
  State<_EventListBody> createState() => _EventListBodyState();
}

class _EventListBodyState extends State<_EventListBody> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return '';
    final d = dt.day.toString().padLeft(2, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final y = dt.year.toString();
    return '$d/$m/$y';
  }

  String _getEventTimeRange(EventModel event) {
    if (event.startDate != null && event.endDate != null) {
      return '${_formatDate(event.startDate)} - ${_formatDate(event.endDate)}';
    } else if (event.startDate != null) {
      return 'Bắt đầu: ${_formatDate(event.startDate)}';
    }
    return '15/08/2026 - 30/09/2026';
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<EventViewModel>();
    final events = vm.events;

    return Scaffold(
      backgroundColor: AppColors.bgBase,
      appBar: AppBar(
        backgroundColor: AppColors.bgPanel,
        elevation: 0,
        title: const Text(
          'DANH SÁCH SỰ KIỆN',
          style: TextStyle(
            fontFamily: 'Chakra Petch',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: AppTextField(
              label: 'Tìm kiếm sự kiện',
              controller: _searchController,
              hint: 'Tìm theo tên, nội dung hoặc địa điểm...',
              prefixIcon: Icons.search,
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 18, color: AppColors.textMuted),
                      onPressed: () {
                        _searchController.clear();
                        vm.setSearchQuery('');
                      },
                    )
                  : null,
              onChanged: (val) => vm.setSearchQuery(val),
            ),
          ),

          // Status Filter Tabs / Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildFilterChip(
                  label: 'TẤT CẢ',
                  isSelected: vm.selectedStatusFilter == 'ALL',
                  onTap: () => vm.setStatusFilter('ALL'),
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  label: 'ĐANG MỞ',
                  isSelected: vm.selectedStatusFilter == 'OPEN',
                  onTap: () => vm.setStatusFilter('OPEN'),
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  label: 'ĐÃ ĐÓNG',
                  isSelected: vm.selectedStatusFilter == 'CLOSED',
                  onTap: () => vm.setStatusFilter('CLOSED'),
                ),
              ],
            ),
          ),

          // Events List with Pull-to-refresh
          Expanded(
            child: RefreshIndicator(
              color: AppColors.primary,
              backgroundColor: AppColors.bgPanel,
              onRefresh: () => vm.refreshEvents(),
              child: vm.isLoading && events.isEmpty
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                  : events.isEmpty
                      ? ListView(
                          children: [
                            SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                            Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.event_busy, size: 48, color: AppColors.textMuted),
                                  const SizedBox(height: 12),
                                  Text(
                                    vm.searchQuery.isNotEmpty
                                        ? 'Không tìm thấy sự kiện phù hợp với "${vm.searchQuery}"'
                                        : 'Chưa có sự kiện nào trong danh mục này',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontFamily: 'Sora',
                                      fontSize: 14,
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  TextButton.icon(
                                    onPressed: () {
                                      _searchController.clear();
                                      vm.setSearchQuery('');
                                      vm.setStatusFilter('ALL');
                                      vm.loadEvents();
                                    },
                                    icon: const Icon(Icons.refresh, size: 16, color: AppColors.primary),
                                    label: const Text(
                                      'Tải lại danh sách',
                                      style: TextStyle(fontFamily: 'Sora', color: AppColors.primary),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          itemCount: events.length,
                          itemBuilder: (context, index) {
                            final event = events[index];
                            final isOpen = event.isOpen;

                            return HudCard(
                              margin: const EdgeInsets.only(bottom: 12),
                              accentBarColor: isOpen ? AppColors.primary : AppColors.textMuted,
                              onTap: () => Navigator.of(context).pushNamed(
                                RouteNames.eventDetail,
                                arguments: event,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          event.title.toUpperCase(),
                                          style: const TextStyle(
                                            fontFamily: 'Chakra Petch',
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      StatusChip(
                                        label: isOpen ? 'ĐANG MỞ' : 'ĐÃ ĐÓNG',
                                        variant: isOpen ? StatusChipVariant.success : StatusChipVariant.danger,
                                        fontSize: 9,
                                      ),
                                    ],
                                  ),
                                  if (event.description.isNotEmpty) ...[
                                    const SizedBox(height: 6),
                                    Text(
                                      event.description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontFamily: 'Sora',
                                        fontSize: 13,
                                        color: AppColors.textMuted,
                                      ),
                                    ),
                                  ],
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      const Icon(Icons.calendar_today, size: 14, color: AppColors.primary),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          _getEventTimeRange(event),
                                          style: const TextStyle(
                                            fontFamily: 'JetBrains Mono',
                                            fontSize: 12,
                                            color: AppColors.textMuted,
                                          ),
                                        ),
                                      ),
                                      if (event.totalTeams > 0) ...[
                                        const SizedBox(width: 8),
                                        const Icon(Icons.groups_outlined, size: 14, color: AppColors.accentTeam),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${event.totalTeams} đội',
                                          style: const TextStyle(
                                            fontFamily: 'JetBrains Mono',
                                            fontSize: 11,
                                            color: AppColors.accentTeam,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  if (event.location != null && event.location!.isNotEmpty) ...[
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textMuted),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            event.location!,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontFamily: 'Sora',
                                              fontSize: 11,
                                              color: AppColors.textMuted,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            );
                          },
                        ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.15) : AppColors.bgInput,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderMuted,
            width: isSelected ? 1.5 : 1.0,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Chakra Petch',
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            color: isSelected ? AppColors.primary : AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}
