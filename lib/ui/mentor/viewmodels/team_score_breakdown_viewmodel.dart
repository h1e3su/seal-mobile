import '../../../core/base/base_viewmodel.dart';
import '../../../core/network/api_result.dart';
import '../../../core/utils/error_mapper.dart';
import '../../../data/models/score/judge_score_model.dart';
import '../../../data/models/score/score_breakdown_model.dart';
import '../../../data/models/score/submission_score_model.dart';
import '../../../data/repositories/score_repository.dart';

class TeamScoreBreakdownViewModel extends BaseViewModel {
  final ScoreRepository _scoreRepository;
  TeamScoreBreakdownViewModel(this._scoreRepository);

  ScoreBreakdownModel? _breakdown;
  ScoreBreakdownModel? get breakdown => _breakdown;

  Future<void> loadBreakdown(String teamId) async {
    setLoading();
    final result = await _scoreRepository.getTeamBreakdown(teamId);
    switch (result) {
      case Success(data: final data):
        _breakdown = data;
        setSuccess();
      case Failure(exception: final ex):
        setError(ErrorMapper.toMessage(ex));
    }
  }

  /// View calls this method to enforce roundPublished gate
  List<JudgeScoreModel>? visibleJudgeScores(SubmissionScoreModel submission) {
    if (!submission.roundPublished) return null; // null = unpublished
    return submission.judgeScores;
  }
}
