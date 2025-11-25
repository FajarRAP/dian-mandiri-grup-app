import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/usecase/use_case.dart';
import '../entities/warehouse_item_entity.dart';
import '../repositories/warehouse_repository.dart';

class InsertPurchaseNoteManualUseCase
    implements UseCase<String, InsertPurchaseNoteManualUseCaseParams> {
  const InsertPurchaseNoteManualUseCase({required this.warehouseRepository});

  final WarehouseRepository warehouseRepository;

  @override
  Future<Either<Failure, String>> execute(
      InsertPurchaseNoteManualUseCaseParams params) async {
    return await warehouseRepository.insertPurchaseNoteManual(params);
  }
}

class InsertPurchaseNoteManualUseCaseParams extends Equatable {
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

  @override
  List<Object?> get props => [date, receipt, note, supplierId, items];
}
