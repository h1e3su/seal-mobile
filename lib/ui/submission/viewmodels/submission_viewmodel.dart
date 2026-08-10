import '../../../core/base/base_viewmodel.dart';
import '../../../data/repositories/submission_repository.dart';

class SubmissionViewModel extends BaseViewModel {
  final SubmissionRepository _submissionRepository;

  SubmissionViewModel(this._submissionRepository);
}
