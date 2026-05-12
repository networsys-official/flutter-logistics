import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logistic_by_strom/features/home/ui/widgets/home_app_bar.dart';
import 'package:hugeicons/hugeicons.dart';

void main() {
  testWidgets(
    'HomeAppBar renders logo and interactive notification icon with badge',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: Column(children: [HomeAppBar()])),
        ),
      );

      // Verify logo exists
      expect(find.byType(Image), findsOneWidget);

      // Verify notification icon exists
      expect(find.byType(HugeIcon), findsOneWidget);

      // Verify badge exists
      expect(find.byType(Badge), findsOneWidget);
      expect(find.text('2'), findsOneWidget);

      // Verify InkWell exists for interaction
      expect(find.byType(InkWell), findsOneWidget);
    },
  );
}
