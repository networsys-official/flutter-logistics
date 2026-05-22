import 'package:logistic_by_strom/core/typedefs/result.dart';
import 'package:logistic_by_strom/features/calculator/data/models/estimate_request.dart';
import 'package:logistic_by_strom/features/calculator/data/models/estimate_response.dart';
import 'package:logistic_by_strom/core/network/api_client.dart';
import 'package:logistic_by_strom/features/calculator/data/repositories/calculator_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'calculator_repository.g.dart';

@riverpod
CalculatorRepository calculatorRepository(Ref ref) {
  return CalculatorRepositoryImpl(ref.watch(apiClientProvider));
}

abstract interface class CalculatorRepository {
  ResultFuture<EstimateResponse> getEstimate(EstimateRequest request);
}
