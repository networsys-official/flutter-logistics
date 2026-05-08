import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:logistic_by_strom/core/typedefs/result.dart';

class MockAccountsRepository implements AccountsRepository {
  final UserProfile profile;
  MockAccountsRepository(this.profile);

  @override
  ResultFuture<UserProfile> getProfile() async {
    return Right(profile);
  }

  @override
  ResultFuture<UserProfile> updateProfile({
    required String name,
    required String phone,
    String? gender,
    String? dob,
    String? language,
    String? imagePath,
  }) async {
    return Right(profile);
  }
}

void main() {
  testWidgets('AccountPage renders correctly with modernized design', (WidgetTester tester) async {
    final userProfile = UserProfile(
      id: '1',
      name: 'John Doe',
      email: 'john@example.com',
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          accountsRepositoryProvider.overrideWithValue(MockAccountsRepository(userProfile)),
        ],
        child: const MaterialApp(
          home: AccountPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify AppBar title
    expect(find.text('Account'), findsOneWidget);

    // Verify Profile Card
    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('john@example.com'), findsOneWidget);
    expect(find.byIcon(Icons.edit_outlined), findsOneWidget);

    // Verify Section Headers
    expect(find.text('Account Settings'), findsOneWidget);
    expect(find.text('General'), findsOneWidget);

    // Verify Menu Items
    expect(find.text('Account Information'), findsOneWidget);
    expect(find.text('Change Password'), findsOneWidget);
    expect(find.text('Connect to Banks'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Help & Support'), findsOneWidget);
    expect(find.text('About'), findsOneWidget);

    // Verify Logout Button
    expect(find.text('Logout'), findsOneWidget);

    // Verify 6 menu icons + 1 notification icon
    expect(find.byType(HugeIcon), findsNWidgets(7));
  });
}
