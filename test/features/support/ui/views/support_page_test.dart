import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logistic_by_strom/features/support/ui/views/support_page.dart';
import 'package:hugeicons/hugeicons.dart';

void main() {
  testWidgets('SupportPage renders correctly with modernized design', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SupportPage(),
      ),
    );

    // Verify AppBar title
    expect(find.text('Support'), findsOneWidget);

    // Verify notification icon with badge
    expect(find.byType(Badge), findsOneWidget);
    expect(find.byType(HugeIcon), findsAtLeastNWidgets(1));

    // Verify banner image
    expect(find.byType(Container), findsAtLeastNWidgets(1));

    // Verify Title and Subtitle
    expect(find.text('How can we help you?'), findsOneWidget);
    expect(find.text('Our team is available to assist you with any questions or concerns.'), findsOneWidget);

    // Verify Contact Cards
    expect(find.text('Phone No.'), findsOneWidget);
    expect(find.text('+236 1234567890'), findsOneWidget);
    expect(find.text('Email Address'), findsOneWidget);
    expect(find.text('support@strom.com'), findsOneWidget);
    expect(find.text('Head Office'), findsOneWidget);
    expect(find.text('Noida One, Sector 63, UP'), findsOneWidget);

    // Verify 3 contact card icons (plus 1 notification icon)
    expect(find.byType(HugeIcon), findsNWidgets(4));
  });
}
