import '../../../core/base/base_viewmodel.dart';
import '../../../core/network/api_result.dart';
import '../../../core/utils/error_mapper.dart';
import '../../../data/models/submission/submit_result_model.dart';
import '../../../data/repositories/submission_repository.dart';

class SubmissionViewModel extends BaseViewModel {
  final SubmissionRepository _submissionRepository;

  List<SubmitResultModel> _submissions = [];
  SubmitResultModel? _selectedSubmission;

  SubmissionViewModel(this._submissionRepository);

  List<SubmitResultModel> get submissions => _submissions;
  SubmitResultModel? get selectedSubmission => _selectedSubmission;

  void selectSubmission(SubmitResultModel submission) {
    _selectedSubmission = submission;
    notifyListeners();
  }

  static bool isValidUrl(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return false;
    return uri.isAbsolute && (uri.scheme == 'http' || uri.scheme == 'https');
  }

  Future<void> loadSubmissions({String? teamId, String? trackId}) async {
    setLoading();
    final result = await _submissionRepository.getSubmissions(teamId: teamId, trackId: trackId);
    if (result is Success<List<SubmitResultModel>>) {
      _submissions = result.data;
      setSuccess();
    } else if (result is Failure<List<SubmitResultModel>>) {
      setError(ErrorMapper.toMessage(result.exception));
    }
  }

  Future<bool> submitEntry({
    required String teamId,
    required String trackId,
    required String title,
    String? description,
    required String submissionUrl,
    String? attachmentUrl,
  }) async {
    if (!isValidUrl(submissionUrl)) {
      setError('Đường dẫn bài nộp (URL) không hợp lệ');
      return false;
    }

    setLoading();
    final result = await _submissionRepository.submitResult(
      teamId: teamId,
      trackId: trackId,
      title: title,
      description: description,
      submissionUrl: submissionUrl,
      attachmentUrl: attachmentUrl,
    );
    if (result is Success<SubmitResultModel>) {
      _submissions.insert(0, result.data);
      setSuccess();
      return true;
    } else if (result is Failure<SubmitResultModel>) {
      setError(ErrorMapper.toMessage(result.exception));
      return false;
    }
    return false;
  }

  Future<bool> updateSubmission(
    String id, {
    required String title,
    String? description,
    required String submissionUrl,
    String? attachmentUrl,
  }) async {
    if (!isValidUrl(submissionUrl)) {
      setError('Đường dẫn bài nộp (URL) không hợp lệ');
      return false;
    }

    setLoading();
    final result = await _submissionRepository.updateSubmission(
      id,
      title: title,
      description: description,
      submissionUrl: submissionUrl,
      attachmentUrl: attachmentUrl,
    );
    if (result is Success<SubmitResultModel>) {
      final index = _submissions.indexWhere((s) => s.id == id);
      if (index != -1) {
        _submissions[index] = result.data;
      }
      _selectedSubmission = result.data;
      setSuccess();
      return true;
    } else if (result is Failure<SubmitResultModel>) {
      setError(ErrorMapper.toMessage(result.exception));
      return false;
    }
    return false;
  }

  Future<bool> deleteSubmission(String id) async {
    setLoading();
    final result = await _submissionRepository.deleteSubmission(id);
    if (result is Success<void>) {
      _submissions.removeWhere((s) => s.id == id);
      if (_selectedSubmission?.id == id) {
        _selectedSubmission = null;
      }
      setSuccess();
      return true;
    } else if (result is Failure<void>) {
      setError(ErrorMapper.toMessage(result.exception));
      return false;
    }
    return false;
  }
}
