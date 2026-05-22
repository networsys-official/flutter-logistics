import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logistic_by_strom/core/models/delivery_zone.dart';
import 'package:logistic_by_strom/core/models/customs_duty.dart';
import 'package:logistic_by_strom/core/models/supplier.dart';
import 'package:logistic_by_strom/core/models/user_address.dart';
import 'package:logistic_by_strom/features/accounts/data/repositories/user_address_repository.dart';
import 'package:logistic_by_strom/features/shipments/data/repositories/shipment_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reference_data_provider.freezed.dart';
part 'reference_data_provider.g.dart';

@freezed
sealed class ReferenceDataState with _$ReferenceDataState {
  const factory ReferenceDataState({
    @Default([]) List<Supplier> suppliers,
    @Default([]) List<CustomsDuty> customsDuties,
    @Default([]) List<DeliveryZone> locations,
    @Default([]) List<UserAddress> addresses,
  }) = _ReferenceDataState;
}

@Riverpod(keepAlive: true)
class ReferenceData extends _$ReferenceData {
  @override
  Future<ReferenceDataState> build() async {
    final shipmentRepository = ref.watch(shipmentRepositoryProvider);
    final userAddressRepository = ref.watch(userAddressRepositoryProvider);

    final suppliersResult = await shipmentRepository.getSuppliers();
    final customsDutiesResult = await shipmentRepository.getCustomsDuties();
    final locationsResult = await shipmentRepository.getLocations();
    final addressesResult = await userAddressRepository.getAddresses();

    return ReferenceDataState(
      suppliers: suppliersResult.fold((l) => [], (r) => r),
      customsDuties: customsDutiesResult.fold((l) => [], (r) => r),
      locations: locationsResult.fold((l) => [], (r) => r),
      addresses: addressesResult.fold((l) => [], (r) => r),
    );
  }
}
