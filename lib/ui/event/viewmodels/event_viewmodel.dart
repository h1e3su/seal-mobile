import '../../../core/base/base_viewmodel.dart';
import '../../../data/models/event/event_model.dart';
import '../../../data/repositories/event_repository.dart';

class EventViewModel extends BaseViewModel {
  final EventRepository _eventRepository;

  final List<EventModel> _events = [
    const EventModel(
      id: '1',
      name: 'SEAL Hackathon 2026',
      description: 'Cuộc thi lập trình Hackathon dành cho sinh viên CNTT với 3 Tracks thi đấu hấp dẫn.',
      status: 'OPEN',
    ),
    const EventModel(
      id: '2',
      name: 'AI Innovation Challenge',
      description: 'Thử thách phát triển ứng dụng Trí tuệ nhân tạo giải quyết bài toán thực tế.',
      status: 'CLOSED',
    ),
  ];

  EventViewModel(this._eventRepository);

  List<EventModel> get events => _events;

  Future<void> loadEvents() async {
    setLoading();
    await Future.delayed(const Duration(milliseconds: 500));
    setSuccess();
  }
}
