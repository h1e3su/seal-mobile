import '../../../core/base/base_viewmodel.dart';
import '../../../core/network/api_result.dart';
import '../../../core/utils/error_mapper.dart';
import '../../../data/models/score/final_result_model.dart';
import '../../../data/repositories/final_result_repository.dart';

class MentorRankingViewModel extends BaseViewModel {
  final FinalResultRepository _finalResultRepository;
  MentorRankingViewModel(this._finalResultRepository);

  List<FinalResultModel> _results = [];
  List<FinalResultModel> get results => _results;

  Future<void> loadRanking(String roundId, String myTrackId) async {
    setLoading();
    final result = await _finalResultRepository.getRoundResults(roundId);
    switch (result) {
      case Success(data: final paginated):
        // Filter by Mentor's assigned Track client-side
        _results = paginated.data.where((r) => r.trackId == myTrackId).toList()
          ..sort((a, b) => a.rank.compareTo(b.rank));
        setSuccess();
      case Failure(exception: final ex):
        setError(ErrorMapper.toMessage(ex));
    }
  }
}
