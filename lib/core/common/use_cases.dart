import 'package:dartz/dartz.dart';

import '../failure/failure.dart';

abstract interface class AsyncUseCaseParams<ReturnType, Params> {
  Future<Either<Failure, ReturnType>> call(Params params);
}

abstract interface class AsyncUseCaseNoParams<ReturnType> {
  Future<Either<Failure, ReturnType>> call();
}

abstract interface class UseCaseParams<ReturnType, Params> {
  ReturnType call(Params params);
}

abstract interface class UseCaseNoParams<ReturnType> {
  ReturnType call();
}
