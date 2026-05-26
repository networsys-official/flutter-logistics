import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logistic_by_strom/core/network/api_client.dart';
import 'package:logistic_by_strom/core/network/api_endpoints.dart';
import 'package:logistic_by_strom/core/providers/auth_provider.dart';
import 'package:logistic_by_strom/firebase_options.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logistic_by_strom/features/notifications/ui/view_models/notifications_view_model.dart';
import 'package:logistic_by_strom/core/router/app_router.dart';
import 'package:logistic_by_strom/core/router/app_routes.dart';

part 'notification_service.g.dart';

@Riverpod(keepAlive: true)
class NotificationService extends _$NotificationService {
  late final FirebaseMessaging _messaging;
  late final FlutterLocalNotificationsPlugin _localNotifications;

  Future<void> _getAndSyncToken() async {
    try {
      if (Platform.isIOS) {
        // Wait for APNs token before getting FCM token on iOS
        final apnsToken = await _messaging.getAPNSToken();
        if (apnsToken == null) {
          if (kDebugMode) {
            print('APNs token is null. FCM token might not be generated.');
          }
          // We can still try to get the FCM token, but it might fail or return null
        }
      }

      final token = await _messaging.getToken();
      if (token != null) {
        await syncTokenToServer(token);
      } else {
        if (kDebugMode) {
          print('FCM token is null after requesting it from Firebase.');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting FCM token: $e');
      }
    }
  }

  @override
  void build() {
    _messaging = FirebaseMessaging.instance;
    _localNotifications = FlutterLocalNotificationsPlugin();

    // Listen to auth state changes to sync FCM token when the user becomes logged in
    ref.listen(authProvider, (previous, next) async {
      final prevLoggedIn = previous?.value?.isLoggedIn ?? false;
      final nextLoggedIn = next.value?.isLoggedIn ?? false;

      if (!prevLoggedIn && nextLoggedIn) {
        if (kDebugMode) {
          print('Auth state changed to logged in. Syncing FCM token...');
        }
        await _getAndSyncToken();
      }
    });
  }

  Future<void> initialize() async {
    // Request permission
    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (kDebugMode) {
      print('User granted permission: ${settings.authorizationStatus}');
    }

    // Initialize local notifications
    await _localNotifications.initialize(settings: 
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle foreground notification tap
        if (response.payload != null) {
           appRouter(ref).push(AppRoutes.notifications);
        }
      },
    );

    // Create Android Notification Channel
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // name
      description: 'This channel is used for important notifications.', // description
      importance: Importance.max,
    );

    final androidPlugin = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(channel);

    // Register background messaging handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Foreground listener
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('Got a message whilst in the foreground!');
        print('Message data: ${message.data}');
      }
      
      // Add to local state/storage
      ref.read(notificationsViewModelProvider.notifier).addNotification(message);

      if (message.notification != null) {
        if (kDebugMode) {
          print('Message also contained a notification: ${message.notification}');
        }
        
        // Show local notification
        _localNotifications.show(
          id: message.hashCode,
          title: message.notification?.title,
          body: message.notification?.body,
          notificationDetails: NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: '@mipmap/ic_launcher',
            ),
            iOS: DarwinNotificationDetails(),
          ),
          payload: message.data.toString(),
        );
      }
    });

    // App opened from background/terminated state
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('A new onMessageOpenedApp event was published!');
      }
      _handleNotificationClick(message);
    });

    // Check for initial message (when app is launched from terminated state via notification click)
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationClick(initialMessage);
    }

    // Token refresh listener
    _messaging.onTokenRefresh.listen((token) async {
      final authState = ref.read(authProvider).value;
      if (authState?.isLoggedIn ?? false) {
        await syncTokenToServer(token);
      }
    });

    // Sync token initially if user is already logged in
    try {
      final authState = await ref.read(authProvider.future);
      if (authState.isLoggedIn) {
        await _getAndSyncToken();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting FCM token on init: $e');
      }
    }
  }

  Future<void> syncTokenToServer(String token) async {
    try {
      final client = ref.read(apiClientProvider);
      await client.post(
        ApiEndpoints.fcmToken,
        data: {'fcm_token': token},
      );
      if (kDebugMode) {
        print('FCM Token synced to server: $token');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to sync FCM Token to server: $e');
      }
    }
  }

  Future<void> deleteTokenFromServer() async {
    try {
      final client = ref.read(apiClientProvider);
      await client.delete(ApiEndpoints.fcmToken);
      if (kDebugMode) {
        print('FCM Token removed from server');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to remove FCM Token from server: $e');
      }
    }
  }

  void _handleNotificationClick(RemoteMessage message) {
    if (kDebugMode) {
      print('Notification clicked with data: ${message.data}');
    }
    
    // Add to local state/storage if it wasn't added yet
    ref.read(notificationsViewModelProvider.notifier).addNotification(message);

    // Deep linking logic
    final router = appRouter(ref);
    final type = message.data['type'];

    if (type == 'shipment_status_updated' || type == 'shipment_charge_calculated') {
       // Ideally we would fetch the ShipmentRequestModel using the ID, but since the route expects the model, 
       // it's cleaner to navigate to the Shipments list page and let the user select it, or navigate to a dedicated detail route that accepts an ID.
       // For now, redirect to the notifications page or shipments list.
       router.push(AppRoutes.notifications);
    } else {
       router.push(AppRoutes.notifications);
    }
  }
}

// Background message handler must be a top-level function
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (kDebugMode) {
    print('Handling a background message: ${message.messageId}');
  }
  // Note: We cannot easily access Riverpod state here to save it locally without a complex setup.
  // When the user opens the app, the notifications won't be in the local list if they were dismissed.
  // This is a limitation of entirely local storage for background notifications without a shared isolate.
}
