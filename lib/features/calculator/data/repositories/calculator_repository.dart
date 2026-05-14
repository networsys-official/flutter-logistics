import 'package:logistic_by_strom/core/typedefs/result.dart';
import 'package:logistic_by_strom/features/calculator/data/models/estimate_request.dart';
import 'package:logistic_by_strom/features/calculator/data/models/estimate_response.dart';

abstract interface class CalculatorRepository {
  ResultFuture<EstimateResponse> getEstimate(EstimateRequest request);
}
