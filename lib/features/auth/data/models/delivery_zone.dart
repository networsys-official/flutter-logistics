import 'package:freezed_annotation/freezed_annotation.dart';

part 'delivery_zone.freezed.dart';
part 'delivery_zone.g.dart';

@freezed
sealed class DeliveryZone with _$DeliveryZone {
  const factory DeliveryZone({required int id, required String label}) =
      _DeliveryZone;

  factory DeliveryZone.fromJson(Map<String, dynamic> json) =>
      _$DeliveryZoneFromJson(json);
}
