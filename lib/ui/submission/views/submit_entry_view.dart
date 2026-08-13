import 'package:flutter/material.dart';
import '../../../app/router/route_names.dart';
import '../../../app/theme/app_colors.dart';
import '../../common/widgets/app_button.dart';
import '../../common/widgets/app_text_field.dart';
import '../../common/widgets/clipped_container.dart';

class SubmitEntryView extends StatefulWidget {
  const SubmitEntryView({super.key});

  @override
  State<SubmitEntryView> createState() => _SubmitEntryViewState();
}

class _SubmitEntryViewState extends State<SubmitEntryView> {
  String _selectedTrack = 'Track 1: AI & Data Science';
  final _urlController = TextEditingController();
  final _descController = TextEditingController();
  String? _urlError;
  bool _isLoading = false;

  final List<String> _tracks = [
    'Track 1: AI & Data Science',
    'Track 2: IoT & Embedded Hardware',
    'Track 3: Blockchain Security',
  ];

  @override
  void dispose() {
    _urlController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _onSubmit() async {
    final url = _urlController.text.trim();
    final urlRegex = RegExp(r'^(http|https):\/\/[^\s$.?#].[^\s]*$');

    if (url.isEmpty || !urlRegex.hasMatch(url)) {
      setState(() {
        _urlError = 'URL không đúng định dạng (phải bắt đầu bằng http:// hoặc https://)';
      });
      return;
    }
    setState(() => _urlError = null);

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() => _isLoading = false);

    Navigator.of(context).pushReplacementNamed(RouteNames.submissionDetail);
  }

  @override
  Widget build(BuildContext context) {
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
                      const Text(
                        'Chọn Track thi đấu',
                        style: TextStyle(fontFamily: 'Sora', fontSize: 13, color: AppColors.textMuted),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedTrack,
                        dropdownColor: AppColors.bgPanel,
                        style: const TextStyle(fontFamily: 'Sora', fontSize: 14, color: AppColors.textPrimary),
                        items: _tracks.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedTrack = val);
                        },
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: AppColors.bgInput,
                          border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.borderMuted)),
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
                isLoading: _isLoading,
                onPressed: _onSubmit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
