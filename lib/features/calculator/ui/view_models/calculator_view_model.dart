import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logistic_by_strom/core/network/api_client.dart';
import 'package:logistic_by_strom/features/calculator/data/models/calculator_request.dart';
import 'package:logistic_by_strom/features/calculator/data/models/calculator_response.dart';
import 'package:logistic_by_strom/features/calculator/data/repositories/calculator_repository.dart';
import 'package:logistic_by_strom/features/calculator/data/repositories/calculator_repository_impl.dart';

part 'calculator_view_model.g.dart';

@riverpod
CalculatorRepository calculatorRepository(Ref ref) {
  return CalculatorRepositoryImpl(ref.watch(apiClientProvider));
}

@riverpod
class CalculatorViewModel extends _$CalculatorViewModel {
  @override
  AsyncValue<CalculatorResponse?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> calculate(CalculatorRequest request) async {
    state = const AsyncValue.loading();
    
    final repository = ref.read(calculatorRepositoryProvider);
    final result = await repository.calculate(request);

    state = result.fold(
      (failure) => AsyncValue.error(failure.message, StackTrace.current),
      (response) => AsyncValue.data(response),
    );
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}
