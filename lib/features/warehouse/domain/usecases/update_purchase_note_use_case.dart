import 'package:dartz/dartz.dart';

import '../../../../core/common/use_cases.dart';
import '../../../../core/failure/failure.dart';
import '../entities/insert_purchase_note_manual_entity.dart';
import '../repositories/warehouse_repositories.dart';

class UpdatePurchaseNoteUseCase
    implements AsyncUseCaseParams<String, UpdatePurchaseNoteUseCaseParams> {
  const UpdatePurchaseNoteUseCase({required this.warehouseRepositories});

  final WarehouseRepositories warehouseRepositories;

  @override
  Future<Either<Failure, String>> call(
      UpdatePurchaseNoteUseCaseParams params) async {
    return await warehouseRepositories.updatePurchaseNote(params: params);
  }
}

final class UpdatePurchaseNoteUseCaseParams {
  const UpdatePurchaseNoteUseCaseParams({
    required this.purchaseNoteId,
    required this.purchaseNote,
  });

  final String purchaseNoteId;
  final InsertPurchaseNoteManualEntity purchaseNote;
}
