import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logistic_by_strom/core/network/api_client.dart';
import 'package:logistic_by_strom/core/network/api_endpoints.dart';
import 'package:logistic_by_strom/features/notifications/data/models/notification_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

part 'notifications_view_model.g.dart';

@Riverpod(keepAlive: true)
class NotificationsViewModel extends _$NotificationsViewModel {
  @override
  FutureOr<List<NotificationModel>> build() async {
    // Subscribe to foreground FCM messages to refresh the state in real-time
    final subscription = FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      ref.invalidateSelf();
    });
    
    ref.onDispose(() {
      subscription.cancel();
    });

    return _loadNotifications();
  }

  Future<List<NotificationModel>> _loadNotifications() async {
    final client = ref.read(apiClientProvider);
    try {
      final response = await client.get(ApiEndpoints.notifications);
      final dynamic responseData = response.data;
      if (responseData is Map<String, dynamic> && responseData['data'] is List) {
        final List<dynamic> list = responseData['data'] as List<dynamic>;
        return list
            .map((item) => NotificationModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<void> markAsRead(String id) async {
    final currentNotifications = state.value ?? [];
    final index = currentNotifications.indexWhere((n) => n.id == id);
    if (index == -1) return;

    // Snappy UI: Update state immediately
    final updatedNotification = currentNotifications[index].copyWith(isRead: true);
    final updatedList = List<NotificationModel>.from(currentNotifications);
    updatedList[index] = updatedNotification;
    state = AsyncValue.data(updatedList);

    // Call API in the background
    final client = ref.read(apiClientProvider);
    try {
      await client.patch(ApiEndpoints.markNotificationRead(id));
    } catch (_) {
      // In case of error, reload from backend to ensure state consistency
      ref.invalidateSelf();
    }
  }

  Future<void> markAllAsRead() async {
    final currentNotifications = state.value ?? [];
    // Snappy UI: Update state immediately
    final updatedList = currentNotifications.map((n) => n.copyWith(isRead: true)).toList();
    state = AsyncValue.data(updatedList);

    // Call API in the background
    final client = ref.read(apiClientProvider);
    try {
      await client.patch(ApiEndpoints.markAllNotificationsRead);
    } catch (_) {
      ref.invalidateSelf();
    }
  }

  Future<void> clearAll() async {
    state = const AsyncValue.data([]);

    // Call API in the background
    final client = ref.read(apiClientProvider);
    try {
      await client.delete(ApiEndpoints.clearNotifications);
    } catch (_) {
      ref.invalidateSelf();
    }
  }

  Future<void> removeNotification(String id) async {
    final currentNotifications = state.value ?? [];
    // Snappy UI: Update state immediately
    final updatedList = currentNotifications.where((n) => n.id != id).toList();
    state = AsyncValue.data(updatedList);

    // Call API in the background
    final client = ref.read(apiClientProvider);
    try {
      await client.delete(ApiEndpoints.deleteNotification(id));
    } catch (_) {
      ref.invalidateSelf();
    }
  }
}
