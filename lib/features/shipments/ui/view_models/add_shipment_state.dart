import 'dart:io';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logistic_by_strom/core/models/delivery_zone.dart';
import 'package:logistic_by_strom/features/shipments/data/models/supplier.dart';
import 'package:logistic_by_strom/features/shipments/data/models/customs_duty.dart';

part 'add_shipment_state.freezed.dart';

@freezed
abstract class ShipmentItemModel with _$ShipmentItemModel {
  const factory ShipmentItemModel({
    CustomsDuty? commodity,
    @Default(0.0) double price,
    @Default('') String description,
  }) = _ShipmentItemModel;
}

@freezed
abstract class AddShipmentFormData with _$AddShipmentFormData {
  const factory AddShipmentFormData({
    @Default([]) List<Supplier> suppliers,
    @Default([]) List<CustomsDuty> customsDuties,
    @Default([]) List<DeliveryZone> locations,
    // Form fields
    String? trackingNumber,
    DateTime? expectedArrival,
    Supplier? selectedSupplier,
    @Default([ShipmentItemModel()]) List<ShipmentItemModel> items,
    String? note,
    @Default([]) List<File> selectedDocuments,

    // Delivery fields
    DeliveryZone? selectedLocation,
    @Default(2) int originCountryId, // Default US
    @Default(2) int originFacilityId, // Default Miami Warehouse
    @Default(1) int destinationCountryId, // Default Bahamas
    @Default(1) int destinationFacilityId, // Default Nassau Store
    @Default(1) int serviceTypeId, // Default Standard
    @Default('pickup') String deliveryType,
  }) = _AddShipmentFormData;
}
