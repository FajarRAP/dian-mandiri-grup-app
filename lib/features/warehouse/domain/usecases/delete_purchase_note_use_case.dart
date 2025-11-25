import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/use_case.dart';
import '../repositories/warehouse_repository.dart';

class DeletePurchaseNoteUseCase
    implements UseCase<String, DeletePurchaseNoteUseCaseParams> {
  const DeletePurchaseNoteUseCase({required this.warehouseRepository});

  final WarehouseRepository warehouseRepository;

  @override
  Future<Either<Failure, String>> execute(
      DeletePurchaseNoteUseCaseParams params) async {
    return warehouseRepository.deletePurchaseNote(params);
  }
}

class DeletePurchaseNoteUseCaseParams extends Equatable {
  const DeletePurchaseNoteUseCaseParams({required this.purchaseNoteId});

  final String purchaseNoteId;

  @override
  List<Object?> get props => [purchaseNoteId];
}
