import 'dart:io';
import 'package:logistic_by_strom/core/typedefs/result.dart';
import 'package:logistic_by_strom/core/models/delivery_zone.dart';
import 'package:logistic_by_strom/core/models/supplier.dart';
import 'package:logistic_by_strom/core/models/customs_duty.dart';
import 'package:logistic_by_strom/features/shipments/data/models/add_shipment_request.dart';
import 'package:logistic_by_strom/features/shipments/data/models/shipment_request_model.dart';
import 'package:logistic_by_strom/features/shipments/data/models/user_shipment_model.dart';

import 'package:logistic_by_strom/features/shipments/data/models/invoice_model.dart';
import 'package:logistic_by_strom/core/network/api_client.dart';
import 'package:logistic_by_strom/features/shipments/data/repositories/shipment_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'shipment_repository.g.dart';

@riverpod
ShipmentRepository shipmentRepository(Ref ref) {
  return ShipmentRepositoryImpl(ref.watch(apiClientProvider));
}

abstract interface class ShipmentRepository {
  ResultFuture<List<Supplier>> getSuppliers();
  ResultFuture<List<CustomsDuty>> getCustomsDuties();
  ResultFuture<List<DeliveryZone>> getLocations();
  ResultVoid createShipmentRequest(
    AddShipmentRequest request,
    List<File> documents,
  );
  ResultFuture<List<ShipmentRequestModel>> getShipmentRequests();
  ResultFuture<List<UserShipmentModel>> getMyOrders();
  ResultFuture<(List<UserShipmentModel> orders, bool hasMore)> getMyOrdersPaginated({
    required int page,
    int perPage = 10,
  });
  ResultFuture<InvoiceModel> getInvoice(int shipmentRequestId);
  ResultFuture<PaymentResponseModel> initiatePayment(int invoiceId, String gateway);
  ResultVoid uploadInvoice(int shipmentRequestId, File file);
}
