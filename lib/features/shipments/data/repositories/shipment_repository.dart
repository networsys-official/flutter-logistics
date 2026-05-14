import 'dart:io';
import 'package:logistic_by_strom/core/typedefs/result.dart';
import 'package:logistic_by_strom/core/models/delivery_zone.dart';
import 'package:logistic_by_strom/core/models/supplier.dart';
import 'package:logistic_by_strom/core/models/customs_duty.dart';
import 'package:logistic_by_strom/features/shipments/data/models/add_shipment_request.dart';

abstract interface class ShipmentRepository {
  ResultFuture<List<Supplier>> getSuppliers();
  ResultFuture<List<CustomsDuty>> getCustomsDuties();
  ResultFuture<List<DeliveryZone>> getLocations();
  ResultVoid createShipmentRequest(
    AddShipmentRequest request,
    List<File> documents,
  );
}
