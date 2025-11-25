import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/use_case.dart';
import '../entities/purchase_note_summary_entity.dart';
import '../repositories/warehouse_repository.dart';

class FetchPurchaseNotesUseCase
    implements
        UseCase<List<PurchaseNoteSummaryEntity>,
            FetchPurchaseNotesUseCaseParams> {
  const FetchPurchaseNotesUseCase({required this.warehouseRepository});

  final WarehouseRepository warehouseRepository;

  @override
  Future<Either<Failure, List<PurchaseNoteSummaryEntity>>> execute(
      FetchPurchaseNotesUseCaseParams params) async {
    return await warehouseRepository.fetchPurchaseNotes(params);
  }
}

class FetchPurchaseNotesUseCaseParams extends Equatable {
  const FetchPurchaseNotesUseCaseParams({
    this.column = 'name',
    this.search,
    this.sort = 'asc',
    this.limit = 10,
    this.page = 1,
  });

  final String column;
  final String? search;
  final String sort;
  final int limit;
  final int page;

  @override
  List<Object?> get props => [column, search, sort, limit, page];
}
