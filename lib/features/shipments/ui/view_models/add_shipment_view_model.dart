import 'package:logistic_by_strom/core/providers/reference_data_provider.dart';
import 'package:logistic_by_strom/features/shipments/data/repositories/shipment_repository_impl.dart';
import 'package:logistic_by_strom/features/shipments/ui/view_models/add_shipment_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logistic_by_strom/core/utils/file_utils.dart';
import 'package:logistic_by_strom/core/models/supplier.dart';
import 'package:logistic_by_strom/core/models/customs_duty.dart';
import 'package:logistic_by_strom/core/models/delivery_zone.dart';
import 'package:logistic_by_strom/features/shipments/data/models/add_shipment_request.dart';
import 'package:logistic_by_strom/features/shipments/ui/widgets/upload_option_bottom_sheet.dart';

part 'add_shipment_view_model.g.dart';

@riverpod
class AddShipmentViewModel extends _$AddShipmentViewModel {
  @override
  Future<AddShipmentFormData> build() async {
    final refData = await ref.watch(referenceDataProvider.future);

    return AddShipmentFormData(
      suppliers: refData.suppliers,
      customsDuties: refData.customsDuties,
      locations: refData.locations,
    );
  }

  void _updateState(AddShipmentFormData Function(AddShipmentFormData) update) {
    if (state.value != null) {
      state = AsyncData(update(state.value!));
    }
  }

  void updateTrackingNumber(String value) =>
      _updateState((s) => s.copyWith(trackingNumber: value));
  void updateDate(DateTime value) =>
      _updateState((s) => s.copyWith(expectedArrival: value));
  void updateSupplier(Supplier? value) =>
      _updateState((s) => s.copyWith(selectedSupplier: value));

  void addItem() => _updateState(
    (s) => s.copyWith(items: [...s.items, const ShipmentItemModel()]),
  );

  void removeItem(int index) {
    _updateState((s) {
      if (s.items.length <= 1) return s;
      final items = [...s.items];
      items.removeAt(index);
      return s.copyWith(items: items);
    });
  }

  void updateItemCommodity(int index, CustomsDuty? value) {
    _updateState((s) {
      final items = [...s.items];
      items[index] = items[index].copyWith(commodity: value);
      return s.copyWith(items: items);
    });
  }

  void updateItemPrice(int index, double value) {
    _updateState((s) {
      final items = [...s.items];
      items[index] = items[index].copyWith(price: value);
      return s.copyWith(items: items);
    });
  }

  void updateItemDescription(int index, String value) {
    _updateState((s) {
      final items = [...s.items];
      items[index] = items[index].copyWith(description: value);
      return s.copyWith(items: items);
    });
  }

  void updateNote(String value) => _updateState((s) => s.copyWith(note: value));
  void updateOriginFacility(int id) =>
      _updateState((s) => s.copyWith(originFacilityId: id));
  void updateServiceType(int id) =>
      _updateState((s) => s.copyWith(serviceTypeId: id));

  void updateDeliveryType(String type) {
    _updateState(
      (s) => s.copyWith(
        deliveryType: type,
        selectedLocation: type != 'door_delivery' ? null : s.selectedLocation,
      ),
    );
  }

  void updateLocation(DeliveryZone? location) =>
      _updateState((s) => s.copyWith(selectedLocation: location));

  Future<void> pickFile(DocumentPickerSource source) async {
    final pickedFile = source == DocumentPickerSource.camera
        ? await FileUtils.pickImage()
        : await FileUtils.pickDocument();

    if (pickedFile != null) {
      _updateState(
        (s) =>
            s.copyWith(selectedDocuments: [...s.selectedDocuments, pickedFile]),
      );
    }
  }

  void removeDocument(int index) {
    _updateState((s) {
      final docs = [...s.selectedDocuments];
      docs.removeAt(index);
      return s.copyWith(selectedDocuments: docs);
    });
  }

  Future<void> submit() async {
    final formData = state.value;
    if (formData == null) return;

    if (formData.trackingNumber == null ||
        formData.expectedArrival == null ||
        formData.selectedSupplier == null ||
        formData.selectedDocuments.isEmpty) {
      throw 'Please fill all required fields and upload at least one document.';
    }

    if (formData.deliveryType == 'door_delivery' &&
        formData.selectedLocation == null) {
      throw 'Please select a delivery zone for door delivery.';
    }

    for (var item in formData.items) {
      if (item.commodity == null || item.price <= 0) {
        throw 'Please ensure all items have a commodity and price.';
      }
    }

    final request = AddShipmentRequest(
      originCountryId: formData.originCountryId,
      originFacilityId: formData.originFacilityId,
      destinationCountryId: formData.destinationCountryId,
      destinationFacilityId: formData.destinationFacilityId,
      serviceTypeId: formData.serviceTypeId,
      deliveryType: formData.deliveryType,
      locationId: formData.selectedLocation?.id,
      supplierName: formData.selectedSupplier!.company,
      trackingNumber: formData.trackingNumber!,
      expectedArrival: formData.expectedArrival!.toIso8601String().split(
        'T',
      )[0],
      note: formData.note,
      items: formData.items
          .map(
            (item) => ShipmentItemRequest(
              commodityType: item.commodity?.item ?? item.description,
              price: item.price,
            ),
          )
          .toList(),
    );

    final result = await ref
        .read(shipmentRepositoryProvider)
        .createShipmentRequest(request, formData.selectedDocuments);

    result.fold((failure) => throw failure.message, (_) => null);
  }
}
