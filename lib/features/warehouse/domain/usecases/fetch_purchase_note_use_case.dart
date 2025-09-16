import 'package:dartz/dartz.dart';

import '../../../../core/common/use_cases.dart';
import '../../../../core/failure/failure.dart';
import '../entities/purchase_note_detail_entity.dart';
import '../repositories/warehouse_repositories.dart';

class FetchPurchaseNoteUseCase
    implements AsyncUseCaseParams<PurchaseNoteDetailEntity, String> {
  const FetchPurchaseNoteUseCase({required this.warehouseRepositories});

  final WarehouseRepositories warehouseRepositories;

  @override
  Future<Either<Failure, PurchaseNoteDetailEntity>> call(String params) async {
    return await warehouseRepositories.fetchPurchaseNote(
        purchaseNoteId: params);
  }
}
