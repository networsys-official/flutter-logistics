import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:logistic_by_strom/features/shipments/data/models/shipment_request_model.dart';
import 'package:logistic_by_strom/features/shipments/data/repositories/shipment_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fpdart/fpdart.dart';

part 'status_requests_view_model.g.dart';

@riverpod
class StatusRequestsViewModel extends _$StatusRequestsViewModel {
  StreamSubscription<RemoteMessage>? _fcmSubscription;

  @override
  Future<List<ShipmentRequestModel>> build(String status) async {
    // Listen to Firebase messaging foreground onMessage stream for real-time updates
    _fcmSubscription = FirebaseMessaging.onMessage.listen((message) {
      // Invalidate provider state to trigger an auto-refresh when FCM receives notification
      ref.invalidateSelf();
    });

    // Clean up subscription when this family member is disposed
    ref.onDispose(() {
      _fcmSubscription?.cancel();
    });

    return _fetchRequests();
  }

  Future<List<ShipmentRequestModel>> _fetchRequests() async {
    final repository = ref.read(shipmentRepositoryProvider);
    final result = await repository.getShipmentRequests();

    return switch (result) {
      Left(value: final failure) => throw failure.message,
      Right(value: final requests) => _filterRequests(requests),
    };
  }

  List<ShipmentRequestModel> _filterRequests(List<ShipmentRequestModel> requests) {
    return requests
        .where((req) => req.bookingStatus.toLowerCase() == status.toLowerCase())
        .toList();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchRequests());
  }
}
