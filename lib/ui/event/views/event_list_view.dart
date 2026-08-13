import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/di/locator.dart';
import '../../../app/router/route_names.dart';
import '../../../app/theme/app_colors.dart';
import '../../common/widgets/app_text_field.dart';
import '../../common/widgets/hud_card.dart';
import '../../common/widgets/status_chip.dart';
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
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<EventViewModel>();

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
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search & Filter bar (C4 spec)
          Padding(
            padding: const EdgeInsets.all(16),
            child: AppTextField(
              label: 'Tìm kiếm',
              controller: _searchController,
              hint: 'Tìm kiếm sự kiện...',
              prefixIcon: Icons.search,
              onChanged: (val) => setState(() => _query = val),
            ),
          ),

          Expanded(
            child: vm.isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : vm.events.isEmpty
                    ? const Center(
                        child: Text(
                          'Chưa có sự kiện nào đang mở đăng ký',
                          style: TextStyle(fontFamily: 'Sora', fontSize: 14, color: AppColors.textMuted),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: vm.events.length,
                        itemBuilder: (context, index) {
                          final event = vm.events[index];
                          if (_query.isNotEmpty && !event.name.toLowerCase().contains(_query.toLowerCase())) {
                            return const SizedBox.shrink();
                          }
                          final isOpen = index == 0; // Mock status
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
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        event.name,
                                        style: const TextStyle(
                                          fontFamily: 'Chakra Petch',
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                    StatusChip(
                                      label: isOpen ? 'ĐANG MỞ' : 'ĐÃ ĐÓNG',
                                      variant: isOpen ? StatusChipVariant.success : StatusChipVariant.danger,
                                      fontSize: 9,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  event.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontFamily: 'Sora', fontSize: 13, color: AppColors.textMuted),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today, size: 14, color: AppColors.primary),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Thời gian: 15/08 - 30/09/2026',
                                      style: const TextStyle(fontFamily: 'JetBrains Mono', fontSize: 12, color: AppColors.textMuted),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
