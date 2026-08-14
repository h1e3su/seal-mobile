import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/theme/app_colors.dart';
import '../../common/widgets/app_button.dart';
import '../../common/widgets/app_text_field.dart';
import '../../common/widgets/clipped_container.dart';
import '../../common/widgets/status_chip.dart';
import '../../../core/utils/student_verification_guard.dart';
import '../../profile/viewmodels/profile_viewmodel.dart';
import '../../event/viewmodels/event_viewmodel.dart';
import '../viewmodels/team_viewmodel.dart';

class CreateTeamView extends StatefulWidget {
  const CreateTeamView({super.key});

  @override
  State<CreateTeamView> createState() => _CreateTeamViewState();
}

class _CreateTeamViewState extends State<CreateTeamView> {
  final _teamNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedEventId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EventViewModel>().loadEvents();
    });
  }

  @override
  void dispose() {
    _teamNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eventVm = context.watch<EventViewModel>();
    final teamVm = context.watch<TeamViewModel>();
    final events = eventVm.events;

    if (_selectedEventId == null && events.isNotEmpty) {
      _selectedEventId = events.first.id;
    }

    return Scaffold(
      backgroundColor: AppColors.bgBase,
      appBar: AppBar(
        title: const Text('TẠO ĐỘI THI MỚI'),
        backgroundColor: AppColors.bgPanel,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClippedContainer(
                padding: const EdgeInsets.all(20),
                backgroundColor: AppColors.bgPanel,
                borderColor: AppColors.borderMuted,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'CREATE NEW TEAM SQUAD',
                          style: TextStyle(
                            fontFamily: 'JetBrains Mono',
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.0,
                            color: AppColors.primary,
                          ),
                        ),
                        StatusChip(
                          label: 'LEADER',
                          variant: StatusChipVariant.info,
                          fontSize: 9,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    AppTextField(
                      controller: _teamNameController,
                      label: 'Tên đội thi',
                      hint: 'Ví dụ: Cyber Shield Squad',
                      prefixIcon: Icons.groups_outlined,
                    ),
                    const SizedBox(height: 18),
                    AppTextField(
                      controller: _descriptionController,
                      label: 'Mô tả tóm tắt (Tùy chọn)',
                      hint: 'Mục tiêu & định hướng dự án...',
                      prefixIcon: Icons.description_outlined,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'SỰ KIỆN THI ĐẤU',
                      style: TextStyle(
                        fontFamily: 'JetBrains Mono',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppColors.bgInput,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: AppColors.borderMuted),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedEventId,
                          isExpanded: true,
                          dropdownColor: AppColors.bgPanel,
                          hint: const Text('Chọn sự kiện', style: TextStyle(color: AppColors.textMuted)),
                          items: events.map((e) {
                            return DropdownMenuItem<String>(
                              value: e.id,
                              child: Text(
                                e.title,
                                style: const TextStyle(
                                  fontFamily: 'Sora',
                                  fontSize: 13,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedEventId = val);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    AppButton(
                      label: 'XÁC NHẬN TẠO ĐỘI THI',
                      isLoading: teamVm.isLoading,
                      onPressed: () async {
                        final messenger = ScaffoldMessenger.of(context);
                        final nav = Navigator.of(context);
                        final profileVm = context.read<ProfileViewModel>();

                        final canProceed = await StudentVerificationGuard.ensureVerified(
                          context,
                          profileVm,
                          actionName: 'tạo đội thi',
                        );
                        if (!canProceed) return;

                        final name = _teamNameController.text.trim();
                        if (name.isEmpty) {
                          messenger.showSnackBar(
                            const SnackBar(
                              content: Text('Vui lòng nhập tên đội thi!'),
                              backgroundColor: AppColors.statusDanger,
                            ),
                          );
                          return;
                        }

                        final eventId = _selectedEventId ?? (events.isNotEmpty ? events.first.id : '1');
                        final success = await teamVm.createTeam(
                          name: name,
                          eventId: eventId,
                          description: _descriptionController.text.trim(),
                        );

                        if (success) {
                          messenger.showSnackBar(
                            const SnackBar(
                              content: Text('Đã tạo đội thi thành công! Bạn là Trưởng nhóm.'),
                              backgroundColor: AppColors.statusSuccess,
                            ),
                          );
                          nav.pop();
                        } else if (teamVm.errorMessage != null) {
                          messenger.showSnackBar(
                            SnackBar(
                              content: Text(teamVm.errorMessage!),
                              backgroundColor: AppColors.statusDanger,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
