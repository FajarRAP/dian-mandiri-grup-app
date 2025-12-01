import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/use_case.dart';
import '../entities/warehouse_item_entity.dart';
import '../repositories/warehouse_repository.dart';

class CreatePurchaseNoteUseCase
    implements UseCase<String, CreatePurchaseNoteUseCaseParams> {
  const CreatePurchaseNoteUseCase({required this.warehouseRepository});

  final WarehouseRepository warehouseRepository;

  @override
  Future<Either<Failure, String>> execute(
    CreatePurchaseNoteUseCaseParams params,
  ) async {
    return await warehouseRepository.createPurchaseNote(params);
  }
}

class CreatePurchaseNoteUseCaseParams extends Equatable {
  const CreatePurchaseNoteUseCaseParams({
    required this.date,
    required this.receipt,
    this.note,
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
