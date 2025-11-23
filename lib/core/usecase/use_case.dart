import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../failure/failure.dart';

abstract interface class UseCase<ReturnType, Params> {
  Future<Either<Failure, ReturnType>> execute(Params params);
}

class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}

class PaginateParams extends Equatable {
  const PaginateParams({this.page = 1, this.limit = 10});

  factory PaginateParams.unlimit() => const PaginateParams(limit: 1000000);

  final int page;
  final int limit;

  @override
  List<Object?> get props => [page, limit];
}

class SearchParams extends Equatable {
  const SearchParams({this.query});

  final String? query;

  @override
  List<Object?> get props => [query];
}

extension NoParamsExtension<ReturnType> on UseCase<ReturnType, NoParams> {
  Future<Either<Failure, ReturnType>> call() => execute(const NoParams());
}

extension UseCaseExtension<ReturnType, Params> on UseCase<ReturnType, Params> {
  Future<Either<Failure, ReturnType>> call(Params params) => execute(params);
}
