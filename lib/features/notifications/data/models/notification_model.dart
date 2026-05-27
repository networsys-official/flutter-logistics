import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_model.freezed.dart';

@freezed
sealed class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    required String id,
    required String title,
    required String body,
    required Map<String, dynamic> data,
    required DateTime receivedAt,
    @Default(false) bool isRead,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      title: (json['title'] ?? '') as String,
      body: (json['message'] ?? json['body'] ?? '') as String,
      data: json['data'] as Map<String, dynamic>? ?? json,
      receivedAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String)
          : (json['receivedAt'] != null 
              ? DateTime.parse(json['receivedAt'] as String)
              : DateTime.now()),
      isRead: json['read_at'] != null || (json['isRead'] as bool? ?? false),
    );
  }
}
