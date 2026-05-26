import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logistic_by_strom/core/services/storage_service.dart';
import 'package:logistic_by_strom/features/notifications/data/models/notification_model.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

part 'notifications_view_model.g.dart';

@Riverpod(keepAlive: true)
class NotificationsViewModel extends _$NotificationsViewModel {
  @override
  FutureOr<List<NotificationModel>> build() async {
    return _loadNotifications();
  }

  Future<List<NotificationModel>> _loadNotifications() async {
    final storageService = ref.read(storageServiceProvider.notifier);
    final jsonStr = await storageService.getNotifications();
    if (jsonStr == null || jsonStr.isEmpty) return [];

    try {
      final List<dynamic> decodedList = jsonDecode(jsonStr);
      return decodedList
          .map((item) => NotificationModel.fromJson(item as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => b.receivedAt.compareTo(a.receivedAt));
    } catch (e) {
      return [];
    }
  }

  Future<void> addNotification(RemoteMessage message) async {
    final currentNotifications = state.value ?? [];
    
    // Create new model
    final newNotification = NotificationModel(
      id: message.messageId ?? const Uuid().v4(),
      title: message.notification?.title ?? 'New Notification',
      body: message.notification?.body ?? '',
      data: message.data,
      receivedAt: message.sentTime ?? DateTime.now(),
      isRead: false,
    );

    // Ensure no duplicates by ID
    if (currentNotifications.any((n) => n.id == newNotification.id)) return;

    final updatedList = [newNotification, ...currentNotifications];
    
    // Save to state and storage
    state = AsyncValue.data(updatedList);
    await _saveNotifications(updatedList);
  }

  Future<void> markAsRead(String id) async {
    final currentNotifications = state.value ?? [];
    final index = currentNotifications.indexWhere((n) => n.id == id);
    if (index == -1) return;

    final updatedNotification = currentNotifications[index].copyWith(isRead: true);
    final updatedList = List<NotificationModel>.from(currentNotifications);
    updatedList[index] = updatedNotification;

    state = AsyncValue.data(updatedList);
    await _saveNotifications(updatedList);
  }

  Future<void> markAllAsRead() async {
    final currentNotifications = state.value ?? [];
    final updatedList = currentNotifications.map((n) => n.copyWith(isRead: true)).toList();

    state = AsyncValue.data(updatedList);
    await _saveNotifications(updatedList);
  }

  Future<void> clearAll() async {
    state = const AsyncValue.data([]);
    await ref.read(storageServiceProvider.notifier).clearNotifications();
  }

  Future<void> _saveNotifications(List<NotificationModel> notifications) async {
    final storageService = ref.read(storageServiceProvider.notifier);
    final jsonList = notifications.map((n) => n.toJson()).toList();
    await storageService.saveNotifications(jsonEncode(jsonList));
  }
}
