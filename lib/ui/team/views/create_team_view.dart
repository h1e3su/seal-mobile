import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/di/locator.dart';
import '../../../app/theme/app_colors.dart';
import '../../common/widgets/app_button.dart';
import '../../common/widgets/app_text_field.dart';
import '../../common/widgets/clipped_container.dart';
import '../../common/widgets/status_chip.dart';
import '../viewmodels/team_viewmodel.dart';

class CreateTeamView extends StatelessWidget {
  const CreateTeamView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TeamViewModel>(
      create: (_) => locator<TeamViewModel>(),
      child: const _CreateTeamBody(),
    );
  }
}

class _CreateTeamBody extends StatefulWidget {
  const _CreateTeamBody();

  @override
  State<_CreateTeamBody> createState() => _CreateTeamBodyState();
}

class _CreateTeamBodyState extends State<_CreateTeamBody> {
  final _teamNameController = TextEditingController();
  String _selectedTrack = 'Track 1: AI & Machine Learning';

  final List<String> _tracks = [
    'Track 1: AI & Machine Learning',
    'Track 2: Mobile App Architecture',
    'Track 3: Web3 & Blockchain Systems',
  ];

  @override
  void dispose() {
    _teamNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      appBar: AppBar(
        title: const Text('TẠO ĐỘI THI MỚI'),
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
                    const Text(
                      'HẠNG MỤC THAM GIA (TRACK)',
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
                          value: _selectedTrack,
                          isExpanded: true,
                          dropdownColor: AppColors.bgPanel,
                          items: _tracks.map((t) {
                            return DropdownMenuItem<String>(
                              value: t,
                              child: Text(
                                t,
                                style: const TextStyle(
                                  fontFamily: 'Sora',
                                  fontSize: 13,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedTrack = val);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    AppButton(
                      label: 'XÁC NHẬN TẠO ĐỘI THI',
                      onPressed: () {
                        if (_teamNameController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Vui lòng nhập tên đội thi!'),
                              backgroundColor: AppColors.statusDanger,
                            ),
                          );
                          return;
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Đã tạo đội thi thành công!'),
                            backgroundColor: AppColors.statusSuccess,
                          ),
                        );
                        Navigator.of(context).pop();
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
