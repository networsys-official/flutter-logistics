import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logistic_by_strom/core/models/delivery_zone.dart';
import 'package:logistic_by_strom/features/shipments/data/models/customs_duty.dart';
import 'package:logistic_by_strom/features/shipments/data/models/supplier.dart';
import 'package:logistic_by_strom/features/shipments/data/repositories/shipment_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reference_data_provider.freezed.dart';
part 'reference_data_provider.g.dart';

@freezed
sealed class ReferenceDataState with _$ReferenceDataState {
  const factory ReferenceDataState({
    @Default([]) List<Supplier> suppliers,
    @Default([]) List<CustomsDuty> customsDuties,
    @Default([]) List<DeliveryZone> locations,
  }) = _ReferenceDataState;
}

@Riverpod(keepAlive: true)
class ReferenceData extends _$ReferenceData {
  @override
  Future<ReferenceDataState> build() async {
    final shipmentRepository = ref.watch(shipmentRepositoryProvider);

    final suppliersResult = await shipmentRepository.getSuppliers();
    final customsDutiesResult = await shipmentRepository.getCustomsDuties();
    final locationsResult = await shipmentRepository.getLocations();

    return ReferenceDataState(
      suppliers: suppliersResult.fold((l) => [], (r) => r),
      customsDuties: customsDutiesResult.fold((l) => [], (r) => r),
      locations: locationsResult.fold((l) => [], (r) => r),
    );
  }
}
