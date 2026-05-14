import 'dart:io';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:logistic_by_strom/core/errors/error_mapper.dart';
import 'package:logistic_by_strom/core/network/api_client.dart';
import 'package:logistic_by_strom/core/network/api_endpoints.dart';
import 'package:logistic_by_strom/core/typedefs/result.dart';
import 'package:logistic_by_strom/core/models/delivery_zone.dart';
import 'package:logistic_by_strom/core/models/supplier.dart';
import 'package:logistic_by_strom/core/models/customs_duty.dart';
import 'package:logistic_by_strom/features/shipments/data/models/add_shipment_request.dart';
import 'package:logistic_by_strom/features/shipments/data/repositories/shipment_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'shipment_repository_impl.g.dart';

@riverpod
ShipmentRepository shipmentRepository(Ref ref) {
  return ShipmentRepositoryImpl(ref.watch(apiClientProvider));
}

class ShipmentRepositoryImpl implements ShipmentRepository {
  final ApiClient _apiClient;

  ShipmentRepositoryImpl(this._apiClient);

  @override
  ResultFuture<List<Supplier>> getSuppliers() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.suppliers);
      final List<dynamic> data = response.data['data'];
      return Right(data.map((e) => Supplier.fromJson(e)).toList());
    } catch (error, stackTrace) {
      return Left(ErrorMapper.map(error, stackTrace));
    }
  }

  @override
  ResultFuture<List<CustomsDuty>> getCustomsDuties() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.customsDuties);
      final List<dynamic> data = response.data['data'];

      return Right(data.map((e) => CustomsDuty.fromJson(e)).toList());
    } catch (error, stackTrace) {
      return Left(ErrorMapper.map(error, stackTrace));
    }
  }

  @override
  ResultFuture<List<DeliveryZone>> getLocations() async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.userAddressesLocations,
      );
      final List<dynamic> data = response.data['data'];

      return Right(data.map((e) => DeliveryZone.fromJson(e)).toList());
    } catch (error, stackTrace) {
      return Left(ErrorMapper.map(error, stackTrace));
    }
  }

  @override
  ResultVoid createShipmentRequest(
    AddShipmentRequest request,
    List<File> documents,
  ) async {
    try {
      final Map<String, dynamic> data = request.toJson();
      final Map<String, dynamic> flatData = {};

      data.forEach((key, value) {
        if (value is List) {
          for (var i = 0; i < value.length; i++) {
            final element = value[i];
            final item = element is Map
                ? element as Map<String, dynamic>
                : (element as dynamic).toJson() as Map<String, dynamic>;

            item.forEach((itemKey, itemValue) {
              if (itemValue != null) {
                flatData['$key[$i][$itemKey]'] = itemValue;
              }
            });
          }
        } else if (value != null) {
          flatData[key] = value;
        }
      });

      final List<MultipartFile> multipartFiles = [];
      for (var file in documents) {
        final filename = file.path.split('/').last;
        final ext = filename.split('.').last.toLowerCase();

        String mimeType = 'image';
        String mimeSubtype = 'jpeg';

        if (ext == 'png') {
          mimeSubtype = 'png';
        } else if (ext == 'pdf') {
          mimeType = 'application';
          mimeSubtype = 'pdf';
        } else if (ext == 'jpg' || ext == 'jpeg') {
          mimeSubtype = 'jpeg';
        }

        // Read bytes upfront — ensures full Content-Length is known
        // and avoids iOS security-scoped file streaming issues.
        final bytes = await file.readAsBytes();

        multipartFiles.add(
          MultipartFile.fromBytes(
            bytes,
            filename: filename,
            contentType: DioMediaType(mimeType, mimeSubtype),
          ),
        );
      }

      // Build FormData from the flattened fields first (no documents yet),
      // then add files individually so Dio encodes them as documents[] parts.
      final formData = FormData.fromMap(flatData, ListFormat.multiCompatible);
      formData.files.addAll(
        multipartFiles.map((f) => MapEntry('documents[]', f)),
      );

      // Use the dedicated uploadFile method — Dio auto-sets
      // "multipart/form-data; boundary=..." when no contentType is forced.
      await _apiClient.uploadFile(
        ApiEndpoints.shipmentRequests,
        formData: formData,
      );
      return const Right(null);
    } catch (error, stackTrace) {
      return Left(ErrorMapper.map(error, stackTrace));
    }
  }
}
