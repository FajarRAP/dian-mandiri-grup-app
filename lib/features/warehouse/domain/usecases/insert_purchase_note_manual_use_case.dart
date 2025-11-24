import 'package:dartz/dartz.dart';

import '../../../../core/common/use_cases.dart';
import '../../../../core/failure/failure.dart';
import '../entities/warehouse_item_entity.dart';
import '../repositories/warehouse_repository.dart';

class InsertPurchaseNoteManualUseCase
    implements UseCase<String, InsertPurchaseNoteManualUseCaseParams> {
  const InsertPurchaseNoteManualUseCase({required this.warehouseRepository});

  final WarehouseRepository warehouseRepository;

  @override
  Future<Either<Failure, String>> call(
      InsertPurchaseNoteManualUseCaseParams params) async {
    return await warehouseRepository.insertPurchaseNoteManual(params: params);
  }
}

class InsertPurchaseNoteManualUseCaseParams {
  const InsertPurchaseNoteManualUseCaseParams({
    required this.date,
    required this.receipt,
    required this.note,
    required this.supplierId,
    required this.items,
  });

  final DateTime date;
  final String receipt;
  final String? note;
  final String supplierId;
  final List<WarehouseItemEntity> items;
}
