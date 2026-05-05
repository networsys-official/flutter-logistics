import 'package:logistic_by_strom/core/typedefs/result.dart';
import 'package:logistic_by_strom/features/calculator/data/models/calculator_request.dart';
import 'package:logistic_by_strom/features/calculator/data/models/calculator_response.dart';

abstract interface class CalculatorRepository {
  ResultFuture<CalculatorResponse> calculate(CalculatorRequest request);
}
