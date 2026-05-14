import 'package:fpdart/fpdart.dart';
import 'package:logistic_by_strom/core/errors/error_mapper.dart';
import 'package:logistic_by_strom/core/network/api_client.dart';
import 'package:logistic_by_strom/core/network/api_endpoints.dart';
import 'package:logistic_by_strom/core/typedefs/result.dart';
import 'package:logistic_by_strom/features/calculator/data/models/estimate_request.dart';
import 'package:logistic_by_strom/features/calculator/data/models/estimate_response.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'calculator_repository.g.dart';

abstract class CalculatorRepository {
  ResultFuture<EstimateResponse> getEstimate(EstimateRequest request);
}

@riverpod
CalculatorRepository calculatorRepository(Ref ref) {
  return CalculatorRepositoryImpl(ref.watch(apiClientProvider));
}

class CalculatorRepositoryImpl implements CalculatorRepository {
  final ApiClient _apiClient;

  CalculatorRepositoryImpl(this._apiClient);

  @override
  ResultFuture<EstimateResponse> getEstimate(EstimateRequest request) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.shipmentEstimates,
        data: request.toJson(),
      );
      final data = response.data['data'];
      return Right(EstimateResponse.fromJson(data));
    } catch (error, stackTrace) {
      return Left(ErrorMapper.map(error, stackTrace));
    }
  }
}
