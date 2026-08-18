import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  // Web/Server Client ID - LẤY CHÍNH XÁC TỪ GoogleAuth:ClientId Ở BE appsettings.json
  static const String _webClientId =
      '805216331270-kmjdrat53j8oa0c7sg6cqbag12a8q9iv.apps.googleusercontent.com';

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: kIsWeb ? _webClientId : null,
    serverClientId: kIsWeb ? null : _webClientId, // <- CHÌA KHÓA TRÁNH LỖI AUDIENCE (aud) trên mobile
    scopes: ['email', 'profile'],
  );

  Future<String?> signInAndGetIdToken() async {
    try {
      // 1. Đăng xuất token cũ trước nếu cần để luôn hiển thị picker chọn tài khoản
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }

      // 2. Mở Google Sign-In Dialog
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        debugPrint('[GoogleAuthService] User cancelled Google Sign-In');
        return null; // Người dùng hủy đăng nhập
      }

      // 3. Lấy thông tin xác thực
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      debugPrint(googleAuth.toString());

      final String? idToken = googleAuth.idToken;
      debugPrint(
        '[GoogleAuthService] Successfully fetched idToken (Length: ${idToken?.length ?? 0})',
      );
      return idToken;
    } catch (e, stackTrace) {
      debugPrint('======================');
      debugPrint('[GoogleAuthService ERROR] $e');
      debugPrint('StackTrace:\n$stackTrace');
      debugPrint('======================');
      rethrow;
    }
  }

  Future<void> signOut() async {
    if (await _googleSignIn.isSignedIn()) {
      await _googleSignIn.signOut();
    }
  }
}
