import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logistic_by_strom/features/home/ui/widgets/home_action_grid.dart';
import 'package:hugeicons/hugeicons.dart';

void main() {
  testWidgets('HomeActionGrid renders 4 action items with circular containers', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: HomeActionGrid(),
        ),
      ),
    );

    // Verify 4 HugeIcons are rendered
    expect(find.byType(HugeIcon), findsNWidgets(4));

    // Verify each icon is wrapped in a Container with BoxShape.circle
    final containerFinder = find.descendant(
      of: find.byType(Column),
      matching: find.byType(Container),
    );

    // Filter containers that have BoxDecoration with shape: BoxShape.circle
    int circularContainersCount = 0;
    for (var element in containerFinder.evaluate()) {
      final container = element.widget as Container;
      if (container.decoration is BoxDecoration) {
        final decoration = container.decoration as BoxDecoration;
        if (decoration.shape == BoxShape.circle) {
          circularContainersCount++;
        }
      }
    }
    
    // There are 4 icons, each should have one circular container
    expect(circularContainersCount, 4);

    // Verify labels are present
    expect(find.text('Invoice'), findsOneWidget);
    expect(find.text('Stand By'), findsOneWidget);
    expect(find.text('Cancelled'), findsOneWidget);
    expect(find.text('Calculator'), findsOneWidget);
  });
}
