import '../../../core/base/base_viewmodel.dart';
import '../../../core/context/user_role_context.dart';
import '../../../core/network/api_result.dart';
import '../../../core/utils/error_mapper.dart';
import '../../../data/models/event/event_model.dart';
import '../../../data/repositories/event_repository.dart';
import '../../../data/repositories/event_role_repository.dart';

class HomeViewModel extends BaseViewModel {
  final EventRoleRepository _eventRoleRepository;
  final EventRepository _eventRepository;
  final UserRoleContext _roleContext;

  List<EventModel> _events = [];
  String _searchQuery = '';

  HomeViewModel(
    this._eventRoleRepository,
    this._eventRepository,
    this._roleContext,
  );

  UserRoleContext get roleContext => _roleContext;

  List<EventModel> get allEvents => _events;

  List<EventModel> get events {
    if (_searchQuery.trim().isEmpty) {
      return _events;
    }
    final q = _searchQuery.trim().toLowerCase();
    return _events
        .where((e) =>
            e.title.toLowerCase().contains(q) ||
            e.description.toLowerCase().contains(q) ||
            (e.location != null && e.location!.toLowerCase().contains(q)))
        .toList();
  }

  String get searchQuery => _searchQuery;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> initHome() async => init();

  Future<void> init() async {
    setLoading();

    // 1. Fetch user event roles
    final rolesResult = await _eventRoleRepository.getUserRoles();
    if (rolesResult is Success) {
      _roleContext.setRoles((rolesResult as Success).data.data);
    }

    // 2. Fetch event list for Home page
    final eventsResult = await _eventRepository.getEvents(pageSize: 20);
    switch (eventsResult) {
      case Success(data: final paginated):
        _events = paginated.data;
        setSuccess();
      case Failure(exception: final ex):
        // Even if events fail, roles might have succeeded, but we show friendly error if empty
        if (_events.isEmpty) {
          setError(ErrorMapper.toMessage(ex));
        } else {
          setSuccess();
        }
    }
  }

  Future<void> refreshHome() async {
    await init();
  }
}
