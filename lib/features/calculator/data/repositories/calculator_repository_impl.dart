import 'package:fpdart/fpdart.dart';
import 'package:logistic_by_strom/core/errors/error_mapper.dart';
import 'package:logistic_by_strom/core/network/api_client.dart';
import 'package:logistic_by_strom/core/network/api_endpoints.dart';
import 'package:logistic_by_strom/core/typedefs/result.dart';
import 'package:logistic_by_strom/features/calculator/data/models/estimate_request.dart';
import 'package:logistic_by_strom/features/calculator/data/models/estimate_response.dart';
import 'package:logistic_by_strom/features/calculator/data/repositories/calculator_repository.dart';

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

      // Handle potential 'data' wrapper from API
      final Map<String, dynamic> responseData =
          response.data['data'] ?? response.data;

      return Right(EstimateResponse.fromJson(responseData));
    } catch (error, stackTrace) {
      return Left(ErrorMapper.map(error, stackTrace));
    }
  }
}
