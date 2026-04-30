import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:logistic_by_strom/app.dart';

void main() {
  testWidgets('boots routed MVVM shell', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: LogisticApp()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
