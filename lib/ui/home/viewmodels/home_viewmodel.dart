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

  List<EventModel> _sortEvents(List<EventModel> inputList) {
    final sorted = List<EventModel>.from(inputList);
    sorted.sort((a, b) {
      // 1. Ưu tiên sự kiện ĐANG MỞ lên trước
      if (a.isOpen && !b.isOpen) return -1;
      if (!a.isOpen && b.isOpen) return 1;

      // 2. Cùng trạng thái: sắp xếp theo thời gian mới hơn lên trước
      if (a.isOpen) {
        final aStart = a.startDate ?? a.registrationStartDate ?? DateTime(1970);
        final bStart = b.startDate ?? b.registrationStartDate ?? DateTime(1970);
        return bStart.compareTo(aStart);
      } else {
        final aEnd = a.endDate ?? a.startDate ?? DateTime(1970);
        final bEnd = b.endDate ?? b.startDate ?? DateTime(1970);
        return bEnd.compareTo(aEnd);
      }
    });
    return sorted;
  }

  List<EventModel> get allEvents => _sortEvents(_events);

  List<EventModel> get events {
    var list = _events;
    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.trim().toLowerCase();
      list = list
          .where((e) =>
              e.title.toLowerCase().contains(q) ||
              e.description.toLowerCase().contains(q) ||
              (e.location != null && e.location!.toLowerCase().contains(q)))
          .toList();
    }
    return _sortEvents(list);
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
