import 'package:flutter_test/flutter_test.dart';

import 'package:logistic_by_strom/app.dart';

void main() {
  testWidgets('boots routed MVVM shell', (tester) async {
    await tester.pumpWidget(const LogisticApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pumpAndSettle();

    expect(find.text('Track every shipment from one place'), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
  });
}
