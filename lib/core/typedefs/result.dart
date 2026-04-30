import 'package:fpdart/fpdart.dart';
import 'package:logistic_by_strom/core/errors/app_failure.dart';

typedef Result<T> = Either<AppFailure, T>;
typedef ResultFuture<T> = Future<Either<AppFailure, T>>;
typedef ResultVoid = ResultFuture<void>;
