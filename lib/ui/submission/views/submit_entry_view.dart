import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/theme/app_colors.dart';
import '../../common/widgets/app_button.dart';
import '../../common/widgets/app_text_field.dart';
import '../../common/widgets/clipped_container.dart';
import '../../event/viewmodels/event_viewmodel.dart';
import '../../team/viewmodels/team_viewmodel.dart';
import '../viewmodels/submission_viewmodel.dart';

class SubmitEntryView extends StatefulWidget {
  const SubmitEntryView({super.key});

  @override
  State<SubmitEntryView> createState() => _SubmitEntryViewState();
}

class _SubmitEntryViewState extends State<SubmitEntryView> {
  final _titleController = TextEditingController();
  final _urlController = TextEditingController();
  final _descController = TextEditingController();
  String? _selectedTrackId;
  String? _urlError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final team = context.read<TeamViewModel>().myTeam;
      if (team?.eventId != null) {
        context.read<EventViewModel>().loadEventDetails(team!.eventId!);
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _urlController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _onSubmit() async {
    final title = _titleController.text.trim();
    final url = _urlController.text.trim();
    final desc = _descController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập tên đề tài/dự án!'), backgroundColor: AppColors.statusDanger),
      );
      return;
    }

    if (!SubmissionViewModel.isValidUrl(url)) {
      setState(() {
        _urlError = 'URL không đúng định dạng (phải bắt đầu bằng http:// hoặc https://)';
      });
      return;
    }
    setState(() => _urlError = null);

    final teamVm = context.read<TeamViewModel>();
    final submissionVm = context.read<SubmissionViewModel>();
    final eventVm = context.read<EventViewModel>();

    final teamId = teamVm.myTeam?.id ?? 'team_demo';
    final trackId = _selectedTrackId ?? (eventVm.selectedEventTracks.isNotEmpty ? eventVm.selectedEventTracks.first.id : 'trk_01');

    final success = await submissionVm.submitEntry(
      teamId: teamId,
      trackId: trackId,
      title: title,
      description: desc.isNotEmpty ? desc : null,
      submissionUrl: url,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nộp bài dự thi thành công!'), backgroundColor: AppColors.statusSuccess),
      );
      Navigator.of(context).pop();
    } else if (mounted && submissionVm.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(submissionVm.errorMessage!), backgroundColor: AppColors.statusDanger),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventVm = context.watch<EventViewModel>();
    final submissionVm = context.watch<SubmissionViewModel>();
    final tracks = eventVm.selectedEventTracks;

    if (_selectedTrackId == null && tracks.isNotEmpty) {
      _selectedTrackId = tracks.first.id;
    }

    return Scaffold(
      backgroundColor: AppColors.bgBase,
      appBar: AppBar(
        backgroundColor: AppColors.bgPanel,
        elevation: 0,
        title: const Text(
          'NỘP BÀI DỰ THI',
          style: TextStyle(
            fontFamily: 'Chakra Petch',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: ClippedContainer(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppTextField(
                        controller: _titleController,
                        label: 'Tên đề tài / giải pháp bài thi',
                        hint: 'Ví dụ: Hệ thống phân loại thông minh',
                        prefixIcon: Icons.title,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'HẠNG MỤC (TRACK) THI ĐẤU',
                        style: TextStyle(fontFamily: 'JetBrains Mono', fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.onSurfaceVariant),
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
                            value: _selectedTrackId,
                            isExpanded: true,
                            dropdownColor: AppColors.bgPanel,
                            hint: const Text('Chọn hạng mục', style: TextStyle(color: AppColors.textMuted)),
                            items: tracks.isNotEmpty
                                ? tracks.map((t) {
                                    return DropdownMenuItem<String>(
                                      value: t.id,
                                      child: Text(
                                        t.name,
                                        style: const TextStyle(
                                          fontFamily: 'Sora',
                                          fontSize: 13,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    );
                                  }).toList()
                                : const [
                                    DropdownMenuItem<String>(
                                      value: 'trk_01',
                                      child: Text('Track 1: AI Innovation', style: TextStyle(color: AppColors.textPrimary)),
                                    ),
                                    DropdownMenuItem<String>(
                                      value: 'trk_02',
                                      child: Text('Track 2: Mobile App Development', style: TextStyle(color: AppColors.textPrimary)),
                                    ),
                                  ],
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedTrackId = val);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        controller: _urlController,
                        label: 'URL Link Bài nộp (Github/Figma/Drive/Youtube)',
                        hint: 'https://github.com/team/project',
                        prefixIcon: Icons.link,
                        errorText: _urlError,
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        controller: _descController,
                        label: 'Mô tả tóm tắt giải pháp',
                        hint: 'Mô tả ngắn về kiến trúc và tính năng nổi bật...',
                        prefixIcon: Icons.description,
                        maxLines: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              color: AppColors.bgPanel,
              child: AppButton(
                label: '// NỘP BÀI >',
                isLoading: submissionVm.isLoading,
                onPressed: _onSubmit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
