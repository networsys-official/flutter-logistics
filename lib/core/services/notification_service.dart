import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logistic_by_strom/core/network/api_client.dart';
import 'package:logistic_by_strom/core/network/api_endpoints.dart';
import 'package:logistic_by_strom/core/providers/auth_provider.dart';
import 'package:logistic_by_strom/firebase_options.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logistic_by_strom/core/router/app_router.dart';
import 'package:logistic_by_strom/core/router/app_routes.dart';

part 'notification_service.g.dart';

@Riverpod(keepAlive: true)
class NotificationService extends _$NotificationService {
  late final FirebaseMessaging _messaging;
  late final FlutterLocalNotificationsPlugin _localNotifications;

  Future<void> getAndSyncToken() async {
    try {
      if (Platform.isIOS) {
        final apnsToken = await _waitForApnsToken();
        if (apnsToken == null) {
          if (kDebugMode) {
            print('APNs token is still null. FCM token sync skipped for now.');
          }
          return;
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
        await getAndSyncToken();
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
    await _localNotifications.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle foreground notification tap.
        // Payload is jsonEncode(message.data) — parse it to decide where to navigate.
        final payload = response.payload;
        if (payload == null) return;

        try {
          final data = jsonDecode(payload) as Map<String, dynamic>;
          final type = data['type'] as String?;
          final router = appRouter(ref);

          switch (type) {
            case 'shipment_status_updated':
            case 'shipment_charge_calculated':
              // Switch bottom-nav to the Shipments tab so the user
              // can immediately see their shipment.
              router.go(AppRoutes.shipments);
            default:
              router.push(AppRoutes.notifications);
          }
        } catch (_) {
          appRouter(ref).push(AppRoutes.notifications);
        }
      },
    );

    // Create Android Notification Channel
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // name
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.max,
    );

    final androidPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await androidPlugin?.createNotificationChannel(channel);

    // Register background messaging handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Foreground listener
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('Got a message whilst in the foreground!');
        print('Message data: ${message.data}');
      }

      if (message.notification != null) {
        if (kDebugMode) {
          print(
            'Message also contained a notification: ${message.notification}',
          );
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
          // Encode as JSON so onDidReceiveNotificationResponse can
          // parse the type and route correctly.
          payload: jsonEncode(message.data),
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
        await getAndSyncToken();
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
      final deviceName = await _getDeviceName();
      await client.post(
        ApiEndpoints.fcmToken,
        data: {
          'fcm_token': token,
          'platform': Platform.operatingSystem,
          'device_name': deviceName,
        },
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

  Future<String> _getDeviceName() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      if (kIsWeb) {
        final webBrowserInfo = await deviceInfo.webBrowserInfo;
        return webBrowserInfo.browserName.toString();
      }
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        return '${androidInfo.brand} ${androidInfo.model}';
      }
      if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        return iosInfo.name;
      }
      if (Platform.isMacOS) {
        final macInfo = await deviceInfo.macOsInfo;
        return macInfo.computerName;
      }
      if (Platform.isWindows) {
        final windowsInfo = await deviceInfo.windowsInfo;
        return windowsInfo.computerName;
      }
      if (Platform.isLinux) {
        final linuxInfo = await deviceInfo.linuxInfo;
        return linuxInfo.name;
      }
    } catch (_) {
      // Fallback
    }
    return Platform.localHostname;
  }

  Future<String?> _waitForApnsToken() async {
    for (var attempt = 0; attempt < 10; attempt++) {
      final token = await _messaging.getAPNSToken();
      if (token != null) return token;

      await Future<void>.delayed(const Duration(milliseconds: 500));
    }

    return null;
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

    final router = appRouter(ref);
    final type = message.data['type'] as String?;

    switch (type) {
      case 'shipment_status_updated':
      case 'shipment_charge_calculated':
        // Navigate to the Shipments tab. The shipmentDetail route requires
        // a full ShipmentRequestModel object which we don't have from the
        // notification payload — the list is the correct landing point.
        router.go(AppRoutes.shipments);
      default:
        router.push(AppRoutes.notifications);
    }
  }
}

// Background message handler must be a top-level function.
// Runs in a separate isolate.
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (kDebugMode) {
    print('Handling a background message: ${message.messageId}');
  }
}
