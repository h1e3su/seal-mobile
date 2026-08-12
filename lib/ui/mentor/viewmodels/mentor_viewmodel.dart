import '../../../core/base/base_viewmodel.dart';
import '../../../core/network/api_result.dart';
import '../../../core/network/paginated_data.dart';
import '../../../data/models/event/track_model.dart';
import '../../../data/models/score/final_result_model.dart';
import '../../../data/models/score/score_breakdown_model.dart';
import '../../../data/models/team/team_model.dart';
import '../../../data/repositories/final_result_repository.dart';
import '../../../data/repositories/score_repository.dart';
import '../../../data/repositories/team_repository.dart';
import '../../../data/repositories/track_repository.dart';

class MentorViewModel extends BaseViewModel {
  final TrackRepository _trackRepository;
  final TeamRepository _teamRepository;
  final ScoreRepository _scoreRepository;
  final FinalResultRepository _finalResultRepository;

  TrackModel? _currentTrack;
  List<TeamModel> _teams = [];
  ScoreBreakdownModel? _selectedScoreBreakdown;
  List<FinalResultModel> _leaderboard = [];

  MentorViewModel(
    this._trackRepository,
    this._teamRepository,
    this._scoreRepository,
    this._finalResultRepository,
  );

  TrackModel? get currentTrack => _currentTrack;
  List<TeamModel> get teams => _teams;
  ScoreBreakdownModel? get selectedScoreBreakdown => _selectedScoreBreakdown;
  List<FinalResultModel> get leaderboard => _leaderboard;

  Future<void> loadTrackWorkspace(String trackId) async {
    setLoading();
    try {
      _currentTrack = await _trackRepository.getTrackById(trackId);
      _teams = await _teamRepository.getTeams(trackId: trackId);
      setSuccess();
    } catch (e) {
      setError('Khởi tạo thông tin Mentor thất bại: ${e.toString()}');
    }
  }

  Future<ScoreBreakdownModel?> fetchTeamScoreBreakdown(String teamId) async {
    final result = await _scoreRepository.getTeamBreakdown(teamId);
    if (result is Success<ScoreBreakdownModel>) {
      _selectedScoreBreakdown = result.data;
      notifyListeners();
      return _selectedScoreBreakdown;
    } else {
      setError('Lấy chi tiết điểm đội thất bại');
      return null;
    }
  }

  Future<void> fetchRoundLeaderboard(String roundId) async {
    final result = await _finalResultRepository.getRoundResults(roundId);
    if (result is Success<PaginatedData<FinalResultModel>>) {
      _leaderboard = result.data.data;
      notifyListeners();
    } else {
      setError('Lấy bảng xếp hạng thất bại');
    }
  }
}
