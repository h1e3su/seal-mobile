import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seal/app/theme/app_colors.dart';
import 'package:seal/ui/common/widgets/hud_card.dart';

void main() {
  group('HudCard Widget Tests', () {
    testWidgets('HudCard renders child widget and responds to onTap', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HudCard(
              accentBarColor: AppColors.primary,
              onTap: () {
                tapped = true;
              },
              child: const Text('TACTICAL SQUAD'),
            ),
          ),
        ),
      );

      expect(find.text('TACTICAL SQUAD'), findsOneWidget);

      await tester.tap(find.text('TACTICAL SQUAD'));
      await tester.pump();

      expect(tapped, true);
    });
  });
}
