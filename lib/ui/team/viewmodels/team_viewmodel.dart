import '../../../core/base/base_viewmodel.dart';
import '../../../data/repositories/team_repository.dart';

class TeamViewModel extends BaseViewModel {
  final TeamRepository _teamRepository;

  TeamViewModel(this._teamRepository);
}
