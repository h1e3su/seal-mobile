import 'package:flutter_test/flutter_test.dart';
import 'package:seal/core/network/api_result.dart';
import 'package:seal/data/models/submission/submit_result_model.dart';
import 'package:seal/data/repositories/submission_repository.dart';
import 'package:seal/ui/submission/viewmodels/submission_viewmodel.dart';

class FakeSubmissionRepository implements SubmissionRepository {
  List<SubmitResultModel> fakeSubmissions = [];

  @override
  Future<ApiResult<List<SubmitResultModel>>> getSubmissions({String? teamId, String? trackId}) async {
    return Success(fakeSubmissions);
  }

  @override
  Future<ApiResult<SubmitResultModel?>> getSubmissionById(String id) async {
    final sub = fakeSubmissions.where((s) => s.id == id).firstOrNull;
    return Success(sub);
  }

  @override
  Future<ApiResult<SubmitResultModel>> submitResult({
    required String teamId,
    required String trackId,
    required String title,
    String? description,
    required String submissionUrl,
    String? attachmentUrl,
  }) async {
    final newSub = SubmitResultModel(
      id: 'sub_${fakeSubmissions.length + 1}',
      teamId: teamId,
      trackId: trackId,
      title: title,
      description: description,
      submissionUrl: submissionUrl,
      attachmentUrl: attachmentUrl,
    );
    fakeSubmissions.add(newSub);
    return Success(newSub);
  }

  @override
  Future<ApiResult<SubmitResultModel>> updateSubmission(
    String id, {
    required String title,
    String? description,
    required String submissionUrl,
    String? attachmentUrl,
  }) async {
    final updated = SubmitResultModel(
      id: id,
      teamId: 'team_01',
      trackId: 'trk_01',
      title: title,
      description: description,
      submissionUrl: submissionUrl,
      attachmentUrl: attachmentUrl,
    );
    return Success(updated);
  }

  @override
  Future<ApiResult<void>> deleteSubmission(String id) async {
    fakeSubmissions.removeWhere((s) => s.id == id);
    return const Success(null);
  }
}

void main() {
  group('SubmissionViewModel Unit Tests', () {
    late FakeSubmissionRepository repository;
    late SubmissionViewModel viewModel;

    setUp(() {
      repository = FakeSubmissionRepository();
      viewModel = SubmissionViewModel(repository);
    });

    test('URL validator correctly validates HTTP / HTTPS links', () {
      expect(SubmissionViewModel.isValidUrl('https://github.com/team/repo'), true);
      expect(SubmissionViewModel.isValidUrl('http://demo.example.com'), true);
      expect(SubmissionViewModel.isValidUrl('invalid-url-string'), false);
      expect(SubmissionViewModel.isValidUrl('ftp://server/file'), false);
      expect(SubmissionViewModel.isValidUrl(''), false);
    });

    test('Submitting invalid URL fails validation and sets error', () async {
      final success = await viewModel.submitEntry(
        teamId: 'team_01',
        trackId: 'trk_01',
        title: 'Project AI',
        submissionUrl: 'invalid-url',
      );

      expect(success, false);
      expect(viewModel.errorMessage, isNotNull);
      expect(viewModel.submissions.isEmpty, true);
    });

    test('Submitting valid URL adds submission successfully', () async {
      final success = await viewModel.submitEntry(
        teamId: 'team_01',
        trackId: 'trk_01',
        title: 'Project AI',
        submissionUrl: 'https://github.com/team/project-ai',
      );

      expect(success, true);
      expect(viewModel.submissions.length, 1);
      expect(viewModel.submissions.first.title, 'Project AI');
    });
  });
}
