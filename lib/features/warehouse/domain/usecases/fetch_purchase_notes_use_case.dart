import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/use_case.dart';
import '../entities/purchase_note_summary_entity.dart';
import '../repositories/warehouse_repository.dart';

class FetchPurchaseNotesUseCase
    implements
        UseCase<
          List<PurchaseNoteSummaryEntity>,
          FetchPurchaseNotesUseCaseParams
        > {
  const FetchPurchaseNotesUseCase({required this.warehouseRepository});

  final WarehouseRepository warehouseRepository;

  @override
  Future<Either<Failure, List<PurchaseNoteSummaryEntity>>> execute(
    FetchPurchaseNotesUseCaseParams params,
  ) async {
    return await warehouseRepository.fetchPurchaseNotes(params);
  }
}

class FetchPurchaseNotesUseCaseParams extends Equatable {
  const FetchPurchaseNotesUseCaseParams({
    this.column = 'name',
    this.sort = 'asc',
    this.paginate = const PaginateParams(),
    this.search = const SearchParams(),
  });

  final String column;
  final String sort;
  final PaginateParams paginate;
  final SearchParams search;

  @override
  List<Object?> get props => [column, sort, paginate, search];
}
