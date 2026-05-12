import 'package:fpdart/fpdart.dart';
import 'package:logistic_by_strom/core/errors/error_mapper.dart';
import 'package:logistic_by_strom/core/network/api_client.dart';
import 'package:logistic_by_strom/core/network/api_endpoints.dart';
import 'package:logistic_by_strom/core/typedefs/result.dart';
import 'package:logistic_by_strom/core/utils/map_utils.dart';
import 'package:logistic_by_strom/features/calculator/data/models/calculator_request.dart';
import 'package:logistic_by_strom/features/calculator/data/models/calculator_response.dart';
import 'package:logistic_by_strom/features/calculator/data/repositories/calculator_repository.dart';

class CalculatorRepositoryImpl implements CalculatorRepository {
  CalculatorRepositoryImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  ResultFuture<CalculatorResponse> calculate(CalculatorRequest request) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.calculate,
        data: request.toJson(),
      );
      final data = MapUtils.asMap(response.data);

      final payload = MapUtils.asMap(data['data']).isNotEmpty
          ? MapUtils.asMap(data['data'])
          : data;

      return right(CalculatorResponse.fromJson(payload));
    } catch (error, stackTrace) {
      return left(ErrorMapper.map(error, stackTrace));
    }
  }
}
