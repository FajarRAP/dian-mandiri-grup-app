import 'package:dartz/dartz.dart';

import '../../../../core/common/use_cases.dart';
import '../../../../core/failure/failure.dart';
import '../entities/insert_purchase_note_file_entity.dart';
import '../repositories/warehouse_repositories.dart';

class InsertPurchaseNoteFileUseCase
    implements AsyncUseCaseParams<String, InsertPurchaseNoteFileEntity> {
  const InsertPurchaseNoteFileUseCase({required this.warehouseRepositories});

  final WarehouseRepositories warehouseRepositories;
  @override
  Future<Either<Failure, String>> call(
      InsertPurchaseNoteFileEntity params) async {
    return await warehouseRepositories.insertPurchaseNoteFile(
        purchaseNote: params);
  }
}
