import '../../../core/base/base_viewmodel.dart';
import '../../../data/repositories/event_repository.dart';

class EventViewModel extends BaseViewModel {
  final EventRepository _eventRepository;

  EventViewModel(this._eventRepository);
}
