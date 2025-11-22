import 'package:dartz/dartz.dart';

import '../../../../core/common/use_cases.dart';
import '../../../../core/failure/failure.dart';
import '../repositories/warehouse_repositories.dart';

class InsertPurchaseNoteFileUseCase
    implements AsyncUseCaseParams<String, InsertPurchaseNoteFileUseCaseParams> {
  const InsertPurchaseNoteFileUseCase({required this.warehouseRepositories});

  final WarehouseRepositories warehouseRepositories;
  @override
  Future<Either<Failure, String>> call(
      InsertPurchaseNoteFileUseCaseParams params) async {
    return await warehouseRepositories.insertPurchaseNoteFile(params: params);
  }
}

class InsertPurchaseNoteFileUseCaseParams {
  InsertPurchaseNoteFileUseCaseParams({
    required this.date,
    required this.receipt,
    this.note,
    required this.supplierId,
    required this.file,
  });

  final DateTime date;
  final String receipt;
  final String? note;
  final String supplierId;
  final String file;
}
