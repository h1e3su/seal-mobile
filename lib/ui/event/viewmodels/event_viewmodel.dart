import '../../../core/base/base_viewmodel.dart';
import '../../../core/network/api_result.dart';
import '../../../core/utils/error_mapper.dart';
import '../../../data/models/event/event_model.dart';
import '../../../data/models/event/round_model.dart';
import '../../../data/models/event/track_model.dart';
import '../../../data/repositories/event_repository.dart';

class EventViewModel extends BaseViewModel {
  final EventRepository _eventRepository;

  List<EventModel> _events = [];
  List<EventModel> _upcomingEvents = [];
  List<EventModel> _myEvents = [];
  EventModel? _selectedEvent;
  List<RoundModel> _selectedEventRounds = [];
  List<TrackModel> _selectedEventTracks = [];

  String _searchQuery = '';
  String _selectedStatusFilter = 'ALL';

  EventViewModel(this._eventRepository);

  List<EventModel> get events {
    var list = _events;
    if (_selectedStatusFilter != 'ALL') {
      list = list.where((e) {
        if (_selectedStatusFilter == 'OPEN') return e.isOpen;
        if (_selectedStatusFilter == 'CLOSED') return !e.isOpen;
        return e.status.toUpperCase() == _selectedStatusFilter.toUpperCase();
      }).toList();
    }
    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.trim().toLowerCase();
      list = list
          .where(
            (e) =>
                e.title.toLowerCase().contains(q) ||
                e.description.toLowerCase().contains(q) ||
                (e.location != null && e.location!.toLowerCase().contains(q)),
          )
          .toList();
    }
    // Sort: open events first, then closed events
    list.sort((a, b) => (a.isOpen ? 1 : 0).compareTo(b.isOpen ? 1 : 0));
    return list;
  }

  List<EventModel> get upcomingEvents {
    var list = _upcomingEvents.toList();
    list.sort((a, b) => (a.isOpen ? 1 : 0).compareTo(b.isOpen ? 1 : 0));
    return list;
  }

  List<EventModel> get myEvents {
    var list = _myEvents.toList();
    list.sort((a, b) => (a.isOpen ? 1 : 0).compareTo(b.isOpen ? 1 : 0));
    return list;
  }

  EventModel? get selectedEvent => _selectedEvent;
  List<RoundModel> get selectedEventRounds => _selectedEventRounds;
  List<TrackModel> get selectedEventTracks => _selectedEventTracks;
  String get selectedStatusFilter => _selectedStatusFilter;
  String get searchQuery => _searchQuery;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setStatusFilter(String filter) {
    _selectedStatusFilter = filter;
    notifyListeners();
  }

  Future<void> loadEvents({String? searchTerm}) async {
    setLoading();
    final result = await _eventRepository.getEvents(searchTerm: searchTerm);
    switch (result) {
      case Success(data: final paginated):
        _events = paginated.data;
        setSuccess();
      case Failure(exception: final ex):
        setError(ErrorMapper.toMessage(ex));
    }
  }

  Future<void> refreshEvents() async {
    await loadEvents(searchTerm: _searchQuery.isNotEmpty ? _searchQuery : null);
  }

  Future<void> loadUpcomingEvents() async {
    final result = await _eventRepository.getUpcomingEvents();
    if (result is Success) {
      _upcomingEvents = (result as Success).data.data;
      notifyListeners();
    }
  }

  Future<void> loadMyEvents() async {
    final result = await _eventRepository.getMyEvents();
    if (result is Success) {
      _myEvents = (result as Success).data;
      notifyListeners();
    }
  }

  Future<void> loadEventDetails(String eventId) async {
    setLoading();
    final eventResult = await _eventRepository.getEventById(eventId);
    if (eventResult is Success) {
      _selectedEvent = (eventResult as Success).data;
    }

    final roundsResult = await _eventRepository.getRoundsByEvent(eventId);
    if (roundsResult is Success) {
      _selectedEventRounds = (roundsResult as Success).data;
    }

    final tracksResult = await _eventRepository.getTracksByEvent(eventId);
    if (tracksResult is Success) {
      _selectedEventTracks = (tracksResult as Success).data;
    }

    setSuccess();
  }
}
