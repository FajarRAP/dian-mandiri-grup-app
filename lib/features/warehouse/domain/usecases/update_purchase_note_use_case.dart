import 'package:dartz/dartz.dart';

import '../../../../core/common/use_cases.dart';
import '../../../../core/failure/failure.dart';
import '../entities/insert_purchase_note_manual_entity.dart';
import '../repositories/warehouse_repositories.dart';

class UpdatePurchaseNoteUseCase implements AsyncUseCaseParams<String, InsertPurchaseNoteManualEntity>{
  const UpdatePurchaseNoteUseCase({required this.warehouseRepositories});

  final WarehouseRepositories warehouseRepositories;

  @override
  Future<Either<Failure, String>> call(InsertPurchaseNoteManualEntity params) async {
    return await warehouseRepositories.updatePurchaseNote(purchaseNote: params);
  }
}