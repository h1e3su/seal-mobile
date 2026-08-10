import 'package:flutter_test/flutter_test.dart';
import 'package:seal/app/app.dart';
import 'package:seal/app/di/locator.dart';
import 'package:seal/core/network/dio_client.dart';
import 'package:seal/ui/auth/views/login_view.dart';

void main() {
  setUp(() {
    if (!locator.isRegistered<DioClient>()) {
      setupLocator();
    }
  });

  testWidgets('App boots into LoginView', (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    // Verify that LoginView is displayed
    expect(find.byType(LoginView), findsOneWidget);
  });
}
