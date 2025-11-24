import 'package:dartz/dartz.dart';

import '../../../../core/common/use_cases.dart';
import '../../../../core/failure/failure.dart';
import '../entities/purchase_note_summary_entity.dart';
import '../repositories/warehouse_repository.dart';

class FetchPurchaseNotesUseCase
    implements
        AsyncUseCaseParams<List<PurchaseNoteSummaryEntity>,
            FetchPurchaseNotesUseCaseParams> {
  const FetchPurchaseNotesUseCase({required this.warehouseRepository});

  final WarehouseRepository warehouseRepository;

  @override
  Future<Either<Failure, List<PurchaseNoteSummaryEntity>>> call(
      FetchPurchaseNotesUseCaseParams params) async {
    return await warehouseRepository.fetchPurchaseNotes(params: params);
  }
}

final class FetchPurchaseNotesUseCaseParams {
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
}
