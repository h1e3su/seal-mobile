import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/router/route_names.dart';
import '../../../app/theme/app_colors.dart';
import '../../common/widgets/app_button.dart';
import '../../common/widgets/app_text_field.dart';
import '../../common/widgets/clipped_container.dart';
import '../viewmodels/profile_viewmodel.dart';

class ProfileVerificationView extends StatefulWidget {
  const ProfileVerificationView({super.key});

  @override
  State<ProfileVerificationView> createState() => _ProfileVerificationViewState();
}

class _ProfileVerificationViewState extends State<ProfileVerificationView> {
  final _fullNameController = TextEditingController();
  final _mssvController = TextEditingController();
  final _searchSchoolController = TextEditingController();

  // 0 = Trường khác (Non-FPT), 1 = Đại học FPT
  int _selectedSchoolType = 0;
  String? _selectedSchoolId;
  String? _selectedSchoolName;
  bool _hasUploadedCard = false;
  String _schoolSearchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<ProfileViewModel>();
      vm.fetchSchools();
      vm.fetchProfile().then((_) {
        if (mounted && vm.profile != null) {
          _fullNameController.text = vm.profile?.fullName ?? '';
          if (vm.profile?.studentCode != null && vm.profile!.studentCode!.isNotEmpty) {
            _mssvController.text = vm.profile!.studentCode!;
          }
          if (vm.profile?.schoolId != null) {
            _selectedSchoolId = vm.profile!.schoolId;
            _selectedSchoolName = vm.profile!.schoolName;
          }
          if (vm.profile?.studentCardImageUrl != null && vm.profile!.studentCardImageUrl!.isNotEmpty) {
            _hasUploadedCard = true;
          }
        }
      });
    });

    _searchSchoolController.addListener(() {
      setState(() {
        _schoolSearchQuery = _searchSchoolController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _mssvController.dispose();
    _searchSchoolController.dispose();
    super.dispose();
  }

  String _normalizeString(String str) {
    var withDia = 'àáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđÀÁẠẢÃÂẦẤẬẨẪĂẰẮẶẲẴÈÉẸẺẼÊỀẾỆỂỄÌÍỊỈĨÒÓỌỎÕÔỒỐỘỔỖƠỜỚỢỞỠÙÚỤỦŨƯỪỨỰỬỮỲÝỴỶỸĐ';
    var withoutDia = 'aaaaaaaaaaaaaaaaaeeeeeeeeeeeiiiiiooooooooooooooooouuuuuuuuuuuyyyyydAAAAAAAAAAAAAAAAAEEEEEEEEEEEIIIIIOOOOOOOOOOOOOOOOOUUUUUUUUUUUYYYYYD';
    var result = str;
    for (int i = 0; i < withDia.length; i++) {
      result = result.replaceAll(withDia[i], withoutDia[i]);
    }
    return result.toLowerCase();
  }

  void _onVerify(ProfileViewModel vm) async {
    final mssv = _mssvController.text.trim();

    // 1. Kiểm tra bắt buộc nhập Mã số sinh viên
    if (mssv.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập Mã số sinh viên (MSSV) bắt buộc!'),
          backgroundColor: AppColors.statusDanger,
        ),
      );
      return;
    }

    if (_selectedSchoolType == 1) {
      // 1 = Đại học FPT: xác thực qua FPT Mock API
      final verified = await vm.checkFptStudent(mssv);
      if (verified != null) {
        final success = await vm.updateStudentProfile(studentCode: mssv);
        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Xác thực thành công sinh viên FPT: ${verified.fullName} (${verified.major})'),
              backgroundColor: AppColors.statusSuccess,
            ),
          );
          Navigator.of(context).pushNamedAndRemoveUntil(RouteNames.home, (route) => false);
        }
      } else if (mounted && vm.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(vm.errorMessage!),
            backgroundColor: AppColors.statusDanger,
          ),
        );
      }
    } else {
      // 0 = Trường khác (Non-FPT)
      // 2. Kiểm tra bắt buộc chọn trường đại học
      if (_selectedSchoolId == null || _selectedSchoolId!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Vui lòng chọn trường đại học từ danh sách!'),
            backgroundColor: AppColors.statusDanger,
          ),
        );
        return;
      }

      // 3. Kiểm tra bắt buộc tải lên ảnh thẻ sinh viên
      if (!_hasUploadedCard) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Vui lòng tải lên ảnh thẻ sinh viên để gửi yêu cầu xác minh!'),
            backgroundColor: AppColors.statusDanger,
          ),
        );
        return;
      }

      final success = await vm.updateStudentProfile(
        schoolId: _selectedSchoolId,
        studentCode: mssv,
        studentCardImageUrl: 'https://storage.cloudfly.vn/cards/student_card_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.hourglass_top, color: Colors.white, size: 20),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Hồ sơ của bạn đang được ban tổ chức phê duyệt',
                    style: TextStyle(fontFamily: 'Sora', fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            backgroundColor: AppColors.statusWarning,
            duration: Duration(seconds: 4),
          ),
        );
        Navigator.of(context).pushNamedAndRemoveUntil(RouteNames.home, (route) => false);
      } else if (mounted && vm.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(vm.errorMessage!),
            backgroundColor: AppColors.statusDanger,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(
      builder: (context, vm, _) {
        final allSchools = vm.schools;
        final normalizedQuery = _normalizeString(_schoolSearchQuery);

        final filteredSchools = normalizedQuery.isEmpty
            ? allSchools
            : allSchools.where((s) {
                final normName = _normalizeString(s.name);
                final normCode = _normalizeString(s.code ?? '');
                final normAddr = _normalizeString(s.address ?? '');
                final isBkMatch = (normalizedQuery == 'bk' || normalizedQuery.contains('bach khoa')) && normName.contains('bach khoa');
                return normName.contains(normalizedQuery) || normCode.contains(normalizedQuery) || normAddr.contains(normalizedQuery) || isBkMatch;
              }).toList();

        final isPending = vm.profile?.isPending ?? false;

        return Scaffold(
          backgroundColor: AppColors.bgBase,
          appBar: AppBar(
            automaticallyImplyLeading: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.primary),
              onPressed: () => Navigator.of(context).pop(),
            ),
            backgroundColor: AppColors.bgPanel,
            elevation: 0,
            title: const Text(
              'CẬP NHẬT HỒ SƠ',
              style: TextStyle(
                fontFamily: 'Chakra Petch',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                if (isPending)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.statusWarning.withValues(alpha: 0.2),
                      border: Border.all(color: AppColors.statusWarning),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.hourglass_empty, color: AppColors.statusWarning, size: 20),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Hồ sơ của bạn đang được Ban Tổ Chức phê duyệt',
                            style: TextStyle(
                              fontFamily: 'Sora',
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: ClippedContainer(
                      padding: const EdgeInsets.all(20),
                      backgroundColor: AppColors.bgPanel,
                      borderColor: AppColors.borderMuted,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'THÔNG TIN SINH VIÊN',
                            style: TextStyle(
                              fontFamily: 'Chakra Petch',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // HỌ VÀ TÊN
                          AppTextField(
                            controller: _fullNameController,
                            label: 'HỌ VÀ TÊN',
                            hint: 'Nhập họ và tên đầy đủ',
                            prefixIcon: Icons.person_outline,
                            enabled: true,
                          ),
                          const SizedBox(height: 18),

                          // TRƯỜNG (Dropdown: Trường khác / Đại học FPT)
                          const Text(
                            'TRƯỜNG',
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
                              child: DropdownButton<int>(
                                value: _selectedSchoolType,
                                isExpanded: true,
                                dropdownColor: AppColors.bgPanel,
                                items: const [
                                  DropdownMenuItem<int>(
                                    value: 0,
                                    child: Text(
                                      'Trường khác',
                                      style: TextStyle(
                                        fontFamily: 'Sora',
                                        fontSize: 13,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                  DropdownMenuItem<int>(
                                    value: 1,
                                    child: Text(
                                      'Đại học FPT',
                                      style: TextStyle(
                                        fontFamily: 'Sora',
                                        fontSize: 13,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                ],
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() {
                                      _selectedSchoolType = val;
                                      if (val == 0) {
                                        vm.fetchSchools();
                                      }
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),

                          // KHI LÀ TRƯỜNG KHÁC: TÌM KIẾM TRƯỜNG VÀ CHỌN TRƯỜNG
                          if (_selectedSchoolType == 0) ...[
                            AppTextField(
                              controller: _searchSchoolController,
                              label: 'TÌM KIẾM TRƯỜNG ${allSchools.isNotEmpty ? "(${allSchools.length} trường)" : ""}',
                              hint: 'Gõ tên trường để tìm kiếm (VD: Văn Lang, Bách Khoa...)',
                              prefixIcon: Icons.search,
                            ),
                            const SizedBox(height: 8),

                            // Danh sách trường tìm kiếm / lựa chọn
                            Container(
                              constraints: const BoxConstraints(maxHeight: 180),
                              decoration: BoxDecoration(
                                color: AppColors.bgInput,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: _selectedSchoolId != null ? AppColors.primary : AppColors.borderMuted,
                                ),
                              ),
                              child: allSchools.isEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Center(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                                            ),
                                            const SizedBox(height: 8),
                                            TextButton(
                                              onPressed: () => vm.fetchSchools(),
                                              child: const Text('Đang tải danh sách... Chạm để thử lại', style: TextStyle(fontFamily: 'Sora', fontSize: 11, color: AppColors.primary)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : filteredSchools.isEmpty
                                      ? const Padding(
                                          padding: EdgeInsets.all(12),
                                          child: Center(
                                            child: Text(
                                              'Không tìm thấy trường phù hợp',
                                              style: TextStyle(fontFamily: 'Sora', fontSize: 12, color: AppColors.textMuted),
                                            ),
                                          ),
                                        )
                                      : ListView.separated(
                                          shrinkWrap: true,
                                          itemCount: filteredSchools.length,
                                          separatorBuilder: (_, i) => const Divider(height: 1, color: AppColors.borderMuted),
                                          itemBuilder: (ctx, index) {
                                            final sch = filteredSchools[index];
                                            final isSelected = _selectedSchoolId == sch.id;
                                            return ListTile(
                                              dense: true,
                                              title: Text(
                                                sch.name,
                                                style: TextStyle(
                                                  fontFamily: 'Sora',
                                                  fontSize: 12,
                                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
                                                ),
                                              ),
                                              subtitle: sch.address != null && sch.address!.isNotEmpty
                                                  ? Text(
                                                      sch.address!,
                                                      style: const TextStyle(fontFamily: 'Sora', fontSize: 10, color: AppColors.textMuted),
                                                    )
                                                  : null,
                                              trailing: isSelected
                                                  ? const Icon(Icons.check_circle, size: 16, color: AppColors.primary)
                                                  : null,
                                              onTap: () {
                                                setState(() {
                                                  _selectedSchoolId = sch.id;
                                                  _selectedSchoolName = sch.name;
                                                  _searchSchoolController.text = sch.name;
                                                });
                                              },
                                            );
                                          },
                                        ),
                            ),
                            if (_selectedSchoolName != null) ...[
                              const SizedBox(height: 6),
                              Text(
                                'Đã chọn: $_selectedSchoolName',
                                style: const TextStyle(
                                  fontFamily: 'Sora',
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                            const SizedBox(height: 18),
                          ],

                          // MÃ SỐ SINH VIÊN (BẮT BUỘC)
                          AppTextField(
                            controller: _mssvController,
                            label: 'MÃ SỐ SINH VIÊN *',
                            hint: 'VD: SE123456 hoặc mã sinh viên trường bạn',
                            prefixIcon: Icons.badge_outlined,
                          ),
                          const SizedBox(height: 18),

                          // ẢNH THẺ SINH VIÊN (BẮT BUỘC KHI LÀ TRƯỜNG KHÁC)
                          if (_selectedSchoolType == 0) ...[
                            Row(
                              children: [
                                const Text(
                                  'ẢNH THẺ SINH VIÊN *',
                                  style: TextStyle(
                                    fontFamily: 'JetBrains Mono',
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.8,
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                if (!_hasUploadedCard)
                                  const Text(
                                    '(Bắt buộc)',
                                    style: TextStyle(fontFamily: 'Sora', fontSize: 10, color: AppColors.statusDanger),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _hasUploadedCard = !_hasUploadedCard;
                                });
                              },
                              child: Container(
                                height: 110,
                                decoration: BoxDecoration(
                                  color: _hasUploadedCard ? AppColors.statusSuccess.withValues(alpha: 0.08) : AppColors.bgInput,
                                  border: Border.all(
                                    color: _hasUploadedCard ? AppColors.statusSuccess : (_mssvController.text.isNotEmpty && !_hasUploadedCard ? AppColors.statusWarning : AppColors.borderMuted),
                                    width: _hasUploadedCard ? 1.5 : 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        _hasUploadedCard ? Icons.check_circle : Icons.upload_file,
                                        color: _hasUploadedCard ? AppColors.statusSuccess : AppColors.primary,
                                        size: 30,
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        _hasUploadedCard ? 'Đã tải lên ảnh thẻ sinh viên' : 'Chạm để tải ảnh thẻ sinh viên',
                                        style: TextStyle(
                                          fontFamily: 'Sora',
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: _hasUploadedCard ? AppColors.statusSuccess : AppColors.textPrimary,
                                        ),
                                      ),
                                      if (!_hasUploadedCard) ...[
                                        const SizedBox(height: 2),
                                        const Text(
                                          'Hỗ trợ JPG, PNG, PDF',
                                          style: TextStyle(fontFamily: 'Sora', fontSize: 10, color: AppColors.textMuted),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                          ] else ...[
                            const SizedBox(height: 10),
                            const Text(
                              '• Sinh viên FPT sẽ được hệ thống tự động xác minh và duyệt ngay lập tức qua Cổng đào tạo.',
                              style: TextStyle(fontFamily: 'Sora', fontSize: 11, color: AppColors.textMuted),
                            ),
                            const SizedBox(height: 24),
                          ],

                          // Nút hành động: Quay lại & Gửi đăng ký
                          Row(
                            children: [
                              TextButton.icon(
                                icon: const Icon(Icons.arrow_back, size: 16, color: AppColors.textMuted),
                                label: const Text(
                                  'Quay lại',
                                  style: TextStyle(fontFamily: 'Sora', color: AppColors.textMuted),
                                ),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                              const Spacer(),
                              Expanded(
                                flex: 2,
                                child: AppButton(
                                  label: 'Gửi đăng ký',
                                  isLoading: vm.isLoading,
                                  onPressed: () => _onVerify(vm),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
