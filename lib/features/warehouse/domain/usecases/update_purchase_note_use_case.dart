import 'package:dartz/dartz.dart';

import '../../../../core/common/use_cases.dart';
import '../../../../core/failure/failure.dart';
import '../entities/warehouse_item_entity.dart';
import '../repositories/warehouse_repositories.dart';

class UpdatePurchaseNoteUseCase
    implements UseCase<String, UpdatePurchaseNoteUseCaseParams> {
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
    required this.date,
    required this.receipt,
    required this.note,
    required this.supplierId,
    required this.items,
  });

  final String purchaseNoteId;
  final DateTime date;
  final String receipt;
  final String? note;
  final String supplierId;
  final List<WarehouseItemEntity> items;
}
