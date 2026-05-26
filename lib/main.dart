import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:logistic_by_strom/firebase_options.dart';
import 'package:logistic_by_strom/app.dart';
import 'package:logistic_by_strom/core/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final container = ProviderContainer();

  // Initialize notifications setup (listeners, FCM configuration) asynchronously
  container.read(notificationServiceProvider.notifier).initialize();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const LogisticApp(),
    ),
  );
}
