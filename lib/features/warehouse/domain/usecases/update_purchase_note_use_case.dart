import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/usecase/use_case.dart';
import '../entities/warehouse_item_entity.dart';
import '../repositories/warehouse_repository.dart';

class UpdatePurchaseNoteUseCase
    implements UseCase<String, UpdatePurchaseNoteUseCaseParams> {
  const UpdatePurchaseNoteUseCase({required this.warehouseRepository});

  final WarehouseRepository warehouseRepository;

  @override
  Future<Either<Failure, String>> execute(
      UpdatePurchaseNoteUseCaseParams params) async {
    return await warehouseRepository.updatePurchaseNote(params);
  }
}

class UpdatePurchaseNoteUseCaseParams extends Equatable {
  const UpdatePurchaseNoteUseCaseParams({
    required this.purchaseNoteId,
    required this.date,
    required this.receipt,
    this.note,
    required this.supplierId,
    required this.items,
  });

  final String purchaseNoteId;
  final DateTime date;
  final String receipt;
  final String? note;
  final String supplierId;
  final List<WarehouseItemEntity> items;

  @override
  List<Object?> get props =>
      [purchaseNoteId, date, receipt, note, supplierId, items];
}
