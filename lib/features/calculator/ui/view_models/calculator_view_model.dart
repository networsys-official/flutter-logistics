import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logistic_by_strom/features/calculator/data/models/estimate_request.dart';
import 'package:logistic_by_strom/features/calculator/data/models/estimate_response.dart';
import 'package:logistic_by_strom/features/calculator/data/repositories/calculator_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'calculator_view_model.freezed.dart';
part 'calculator_view_model.g.dart';

@freezed
sealed class CalculatorState with _$CalculatorState {
  const factory CalculatorState({
    @Default(0.0) double length,
    @Default(0.0) double width,
    @Default(0.0) double height,
    @Default(0.0) double weight,
    @Default(0.0) double price,
    int? tariffCode,
    @Default('pickup') String deliveryType,
    @Default('standard') String shippingType,
    int? destinationLocationId,
    @Default(false) bool isLoading,
    String? errorMessage,
    EstimateResponse? estimate,
  }) = _CalculatorState;
}

@riverpod
class CalculatorViewModel extends _$CalculatorViewModel {
  @override
  CalculatorState build() {
    return const CalculatorState();
  }

  void updateLength(double value) => state = state.copyWith(length: value);
  void updateWidth(double value) => state = state.copyWith(width: value);
  void updateHeight(double value) => state = state.copyWith(height: value);
  void updateWeight(double value) => state = state.copyWith(weight: value);
  void updatePrice(double value) => state = state.copyWith(price: value);

  void updateTariffCode(int? value) {
    state = state.copyWith(tariffCode: value);
  }

  void updateDeliveryType(String type) {
    state = state.copyWith(
      deliveryType: type,
      // Reset location if switching to pickup
      destinationLocationId: type == 'pickup'
          ? null
          : state.destinationLocationId,
    );
  }

  void updateShippingType(String type) {
    state = state.copyWith(shippingType: type);
  }

  void updateDestinationLocation(int? locationId) {
    state = state.copyWith(destinationLocationId: locationId);
  }

  Future<void> calculate() async {
    if (state.weight <= 0) {
      state = state.copyWith(errorMessage: 'Weight must be greater than 0');
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null, estimate: null);

    final request = EstimateRequest(
      shippingType: state.shippingType,
      deliveryType: state.deliveryType,
      destinationLocationId: state.destinationLocationId,
      tariffCode: state.tariffCode,
      estimatedWeightLbs: state.weight,
      lengthCm: state.length,
      widthCm: state.width,
      heightCm: state.height,
      price: state.price,
    );

    final repository = ref.read(calculatorRepositoryProvider);
    final result = await repository.getEstimate(request);

    result.fold(
      (error) {
        state = state.copyWith(isLoading: false, errorMessage: error.message);
      },
      (response) {
        state = state.copyWith(isLoading: false, estimate: response);
      },
    );
  }
}
