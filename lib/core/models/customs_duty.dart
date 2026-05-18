import 'package:freezed_annotation/freezed_annotation.dart';

part 'customs_duty.freezed.dart';
part 'customs_duty.g.dart';

@freezed
sealed class CustomsDuty with _$CustomsDuty {
  const factory CustomsDuty({
    required int id,
    String? item,
    @JsonKey(name: 'tariff_code') String? tariffCode,
    @JsonKey(name: 'duty_rate_label') String? dutyRateLabel,
  }) = _CustomsDuty;

  factory CustomsDuty.fromJson(Map<String, dynamic> json) =>
      _$CustomsDutyFromJson(json);
}
