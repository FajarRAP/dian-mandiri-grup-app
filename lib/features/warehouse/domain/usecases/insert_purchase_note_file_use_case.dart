import 'package:dartz/dartz.dart';

import '../../../../core/common/use_cases.dart';
import '../../../../core/failure/failure.dart';
import '../repositories/warehouse_repository.dart';

class InsertPurchaseNoteFileUseCase
    implements AsyncUseCaseParams<String, InsertPurchaseNoteFileUseCaseParams> {
  const InsertPurchaseNoteFileUseCase({required this.warehouseRepository});

  final WarehouseRepository warehouseRepository;
  @override
  Future<Either<Failure, String>> call(
      InsertPurchaseNoteFileUseCaseParams params) async {
    return await warehouseRepository.insertPurchaseNoteFile(params: params);
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
