import 'package:dartz/dartz.dart';

import '../../../../core/common/use_cases.dart';
import '../../../../core/failure/failure.dart';
import '../entities/purchase_note_summary_entity.dart';
import '../repositories/warehouse_repositories.dart';

class FetchPurchaseNotesUseCase
    implements
        AsyncUseCaseParams<List<PurchaseNoteSummaryEntity>,
            Map<String, dynamic>> {
  const FetchPurchaseNotesUseCase({required this.warehouseRepositories});

  final WarehouseRepositories warehouseRepositories;

  @override
  Future<Either<Failure, List<PurchaseNoteSummaryEntity>>> call(
      Map<String, dynamic> params) async {
    return await warehouseRepositories.fetchPurchaseNotes(
      column: params['column'] ?? 'name',
      order: params['order'] ?? 'asc',
      search: params['search'],
      limit: params['limit'] ?? 10,
      page: params['page'] ?? 1,
    );
  }
}
