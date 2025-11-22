import 'package:dartz/dartz.dart';

import '../../../../core/common/use_cases.dart';
import '../../../../core/failure/failure.dart';
import '../entities/warehouse_item_entity.dart';
import '../repositories/warehouse_repositories.dart';

class InsertPurchaseNoteManualUseCase
    implements UseCase<String, InsertPurchaseNoteManualUseCaseParams> {
  const InsertPurchaseNoteManualUseCase({required this.warehouseRepositories});

  final WarehouseRepositories warehouseRepositories;

  @override
  Future<Either<Failure, String>> call(
      InsertPurchaseNoteManualUseCaseParams params) async {
    return await warehouseRepositories.insertPurchaseNoteManual(params: params);
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
