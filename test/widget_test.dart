import 'package:flutter_test/flutter_test.dart';
import 'package:seal/app/app.dart';
import 'package:seal/app/di/locator.dart';
import 'package:seal/core/network/dio_client.dart';
import 'package:seal/ui/auth/views/splash_view.dart';

void main() {
  setUp(() {
    if (!locator.isRegistered<DioClient>()) {
      setupLocator();
    }
  });

  testWidgets('App boots into SplashView and initializes', (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    // Verify that SplashView is rendered on startup
    expect(find.byType(SplashView), findsOneWidget);

    // Advance splash delay timer
    await tester.pump(const Duration(milliseconds: 1600));
    await tester.pump();
  });
}
