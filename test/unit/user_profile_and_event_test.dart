import 'package:flutter_test/flutter_test.dart';
import 'package:seal/core/context/user_role_context.dart';
import 'package:seal/core/network/dio_client.dart';
import 'package:seal/core/network/paginated_data.dart';
import 'package:seal/data/models/event/event_model.dart';
import 'package:seal/data/models/event_role/event_role_model.dart';
import 'package:seal/data/models/user/user_profile_model.dart';
import 'package:seal/data/repositories/event_repository.dart';
import 'package:seal/data/repositories/event_role_repository.dart';
import 'package:seal/data/services/event_remote_datasource.dart';
import 'package:seal/data/services/event_role_remote_datasource.dart';
import 'package:seal/ui/event/viewmodels/event_viewmodel.dart';
import 'package:seal/ui/home/viewmodels/home_viewmodel.dart';

class FakeEventRemoteDataSource extends EventRemoteDataSource {
  FakeEventRemoteDataSource() : super(DioClient());

  List<EventModel> mockEvents = [
    const EventModel(
      id: 'evt_1',
      title: 'SEAL Hackathon 2026',
      description: 'Cuộc thi AI & Web App',
      status: 'RegistrationOpen',
      location: 'FPT Campus',
    ),
    const EventModel(
      id: 'evt_2',
      title: 'Mobile Dev Contest',
      description: 'Thiết kế ứng dụng Flutter',
      status: 'Closed',
      location: 'Hà Nội',
    ),
  ];

  @override
  Future<PaginatedData<EventModel>> getEvents({
    int pageNumber = 1,
    int pageSize = 20,
    String? searchTerm,
  }) async {
    var filtered = mockEvents;
    if (searchTerm != null && searchTerm.isNotEmpty) {
      filtered = filtered
          .where(
            (e) => e.title.toLowerCase().contains(searchTerm.toLowerCase()),
          )
          .toList();
    }
    return PaginatedData<EventModel>(
      data: filtered,
      currentPage: 1,
      pageSize: pageSize,
      totalItems: filtered.length,
    );
  }
}

class FakeEventRoleRemoteDataSource extends EventRoleRemoteDataSource {
  FakeEventRoleRemoteDataSource() : super(DioClient());

  @override
  Future<PaginatedData<EventRoleModel>> getUserRoles({
    int pageNumber = 1,
    int pageSize = 20,
  }) async {
    return const PaginatedData<EventRoleModel>(
      data: [],
      currentPage: 1,
      pageSize: 20,
      totalItems: 0,
    );
  }
}

void main() {
  group('UserProfileModel Approval & Status Tests', () {
    test(
      'Correctly identifies approved user when backend sends registrationStatus: "Approved"',
      () {
        final json = {
          'id': 'usr_01',
          'email': 'student@fpt.edu.vn',
          'fullName': 'Nguyễn Văn A',
          'studentCode': 'SE170001',
          'registrationStatus': 'Approved',
          'isAdmin': false,
          'isStudent': true,
        };

        final profile = UserProfileModel.fromJson(json);

        expect(profile.isApproved, isTrue);
        expect(profile.isPending, isFalse);
        expect(profile.isRejected, isFalse);
        expect(profile.registrationStatus, 'Approved');
        expect(profile.isFpt, isTrue);
      },
    );

    test(
      'Correctly identifies pending user when backend sends registrationStatus: "Pending"',
      () {
        final json = {
          'id': 'usr_02',
          'email': 'guest@hcmut.edu.vn',
          'fullName': 'Trần Văn B',
          'registrationStatus': 'Pending',
          'isApproved': false,
        };

        final profile = UserProfileModel.fromJson(json);

        expect(profile.isApproved, isFalse);
        expect(profile.isPending, isTrue);
        expect(profile.isRejected, isFalse);
        expect(profile.registrationStatus, 'Pending');
      },
    );

    test(
      'Correctly identifies rejected user when backend sends registrationStatus: "Rejected"',
      () {
        final json = {
          'id': 'usr_03',
          'email': 'guest@uit.edu.vn',
          'fullName': 'Lê Văn C',
          'registrationStatus': 'Rejected',
        };

        final profile = UserProfileModel.fromJson(json);

        expect(profile.isApproved, isFalse);
        expect(profile.isPending, isFalse);
        expect(profile.isRejected, isTrue);
        expect(profile.registrationStatus, 'Rejected');
      },
    );

    test('Handles boolean isApproved: true / isApproved: "true"', () {
      final jsonBool = {
        'id': 'usr_04',
        'email': 'a@b.com',
        'fullName': 'Test User',
        'isApproved': true,
      };
      final profileBool = UserProfileModel.fromJson(jsonBool);
      expect(profileBool.isApproved, isTrue);
      expect(profileBool.isPending, isFalse);

      final jsonStr = {
        'id': 'usr_05',
        'email': 'a@b.com',
        'fullName': 'Test User 2',
        'isApproved': 'true',
      };
      final profileStr = UserProfileModel.fromJson(jsonStr);
      expect(profileStr.isApproved, isTrue);
      expect(profileStr.isPending, isFalse);
    });
  });

  group('HomeViewModel & EventViewModel Tests', () {
    late FakeEventRemoteDataSource eventDataSource;
    late FakeEventRoleRemoteDataSource roleDataSource;
    late EventRepository eventRepo;
    late EventRoleRepository roleRepo;
    late UserRoleContext roleContext;

    setUp(() {
      eventDataSource = FakeEventRemoteDataSource();
      roleDataSource = FakeEventRoleRemoteDataSource();
      eventRepo = EventRepository(eventDataSource);
      roleRepo = EventRoleRepository(roleDataSource);
      roleContext = UserRoleContext();
    });

    test('HomeViewModel fetches events and filters by search query', () async {
      final vm = HomeViewModel(roleRepo, eventRepo, roleContext);
      await vm.initHome();

      expect(vm.events.length, 2);
      expect(vm.events[0].title, 'SEAL Hackathon 2026');

      vm.setSearchQuery('Flutter');
      expect(vm.events.length, 1);
      expect(vm.events[0].title, 'Mobile Dev Contest');

      vm.setSearchQuery('');
      expect(vm.events.length, 2);
    });

    test('EventViewModel filters by status and search query', () async {
      final vm = EventViewModel(eventRepo);
      await vm.loadEvents();

      expect(vm.events.length, 2);

      // Status filter OPEN
      vm.setStatusFilter('OPEN');
      expect(vm.events.length, 1);
      expect(vm.events[0].title, 'SEAL Hackathon 2026');

      // Status filter CLOSED
      vm.setStatusFilter('CLOSED');
      expect(vm.events.length, 1);
      expect(vm.events[0].title, 'Mobile Dev Contest');

      // Reset filter
      vm.setStatusFilter('ALL');
      expect(vm.events.length, 2);

      // Search query
      vm.setSearchQuery('AI');
      expect(vm.events.length, 1);
      expect(vm.events[0].title, 'SEAL Hackathon 2026');
    });
  });
}
