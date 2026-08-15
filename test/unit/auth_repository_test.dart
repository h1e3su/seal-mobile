import 'package:flutter_test/flutter_test.dart';
import 'package:seal/core/network/api_result.dart';
import 'package:seal/core/network/dio_client.dart';
import 'package:seal/data/models/auth/auth_response.dart';
import 'package:seal/data/models/auth/login_request.dart';
import 'package:seal/data/models/auth/register_request.dart';
import 'package:seal/data/models/user/user_profile_model.dart';
import 'package:seal/data/repositories/auth_repository.dart';
import 'package:seal/data/services/auth_remote_datasource.dart';

class FakeAuthRemoteDataSource extends AuthRemoteDataSource {
  FakeAuthRemoteDataSource() : super(DioClient());

  bool shouldFail = false;

  @override
  Future<AuthResponse> login(LoginRequest request) async {
    if (shouldFail) throw Exception('Invalid credentials');
    return AuthResponse(
      message: 'Success',
      accessToken: 'jwt_mock_access_token',
      refreshToken: 'jwt_mock_refresh_token',
      userId: 'usr_01',
      email: request.email,
    );
  }

  @override
  Future<UserProfileModel> register(RegisterRequest request) async {
    if (shouldFail) throw Exception('Email already exists');
    return UserProfileModel(
      id: 'usr_01',
      email: request.email,
      fullName: request.fullName,
      isStudent: true,
      isAdmin: false,
      isApproved: false,
      isFpt: false,
      isRejected: false,
      isTemporary: false,
    );
  }
}

void main() {
  group('AuthRepository Unit Tests', () {
    late FakeAuthRemoteDataSource dataSource;
    late AuthRepository repository;

    setUp(() {
      dataSource = FakeAuthRemoteDataSource();
      repository = AuthRepository(dataSource);
    });

    test('Login success returns Success<AuthResponse> with valid token', () async {
      final result = await repository.login(
        'test@fpt.edu.vn',
        'password123',
      );

      expect(result, isA<Success<AuthResponse>>());
      final data = (result as Success<AuthResponse>).data;
      expect(data.accessToken, 'jwt_mock_access_token');
      expect(data.refreshToken, 'jwt_mock_refresh_token');
      expect(data.email, 'test@fpt.edu.vn');
    });

    test('Login failure returns Failure result', () async {
      dataSource.shouldFail = true;

      final result = await repository.login(
        'test@fpt.edu.vn',
        'wrong_password',
      );

      expect(result, isA<Failure<AuthResponse>>());
    });

    test('Register success returns Success<UserProfileModel>', () async {
      final result = await repository.register(
        email: 'newuser@fpt.edu.vn',
        password: 'password123',
        fullName: 'New User',
      );

      expect(result, isA<Success<UserProfileModel>>());
      final data = (result as Success<UserProfileModel>).data;
      expect(data.email, 'newuser@fpt.edu.vn');
      expect(data.fullName, 'New User');
    });
  });
}
