import '../../../core/base/base_viewmodel.dart';
import '../../../core/network/api_result.dart';
import '../../../core/utils/error_mapper.dart';
import '../../../data/models/score/appeal_model.dart';
import '../../../data/repositories/appeal_repository.dart';

class AppealsViewModel extends BaseViewModel {
  final AppealRepository _appealRepository;

  List<AppealModel> _appeals = [];
  AppealModel? _selectedAppeal;

  AppealsViewModel(this._appealRepository);

  List<AppealModel> get appeals => _appeals;
  AppealModel? get selectedAppeal => _selectedAppeal;

  void selectAppeal(AppealModel appeal) {
    _selectedAppeal = appeal;
    notifyListeners();
  }

  Future<void> loadMyAppeals([String? teamId]) async {
    setLoading();
    final result = await _appealRepository.getMyAppeals(teamId);
    if (result is Success<List<AppealModel>>) {
      _appeals = result.data;
      setSuccess();
    } else if (result is Failure<List<AppealModel>>) {
      setError(ErrorMapper.toMessage(result.exception));
    }
  }

  Future<bool> createAppeal({
    required String teamId,
    required String roundId,
    required String reason,
    String? evidenceUrl,
  }) async {
    if (reason.trim().isEmpty) {
      setError('Vui lòng nhập lý do phúc khảo');
      return false;
    }

    setLoading();
    final result = await _appealRepository.createAppeal(
      teamId: teamId,
      roundId: roundId,
      reason: reason,
      evidenceUrl: evidenceUrl,
    );
    if (result is Success<AppealModel>) {
      _appeals.insert(0, result.data);
      setSuccess();
      return true;
    } else if (result is Failure<AppealModel>) {
      setError(ErrorMapper.toMessage(result.exception));
      return false;
    }
    return false;
  }
}
