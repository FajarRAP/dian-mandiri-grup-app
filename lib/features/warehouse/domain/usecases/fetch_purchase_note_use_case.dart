import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/usecase/use_case.dart';
import '../entities/purchase_note_detail_entity.dart';
import '../repositories/warehouse_repository.dart';

class FetchPurchaseNoteUseCase
    implements
        UseCase<PurchaseNoteDetailEntity, FetchPurchaseNoteUseCaseParams> {
  const FetchPurchaseNoteUseCase({required this.warehouseRepository});

  final WarehouseRepository warehouseRepository;

  @override
  Future<Either<Failure, PurchaseNoteDetailEntity>> execute(
      FetchPurchaseNoteUseCaseParams params) async {
    return await warehouseRepository.fetchPurchaseNote(params);
  }
}

class FetchPurchaseNoteUseCaseParams extends Equatable {
  const FetchPurchaseNoteUseCaseParams({required this.purchaseNoteId});

  final String purchaseNoteId;

  @override
  List<Object?> get props => [purchaseNoteId];
}
