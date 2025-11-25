import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/use_case.dart';
import '../repositories/warehouse_repository.dart';

class InsertReturnCostUseCase
    implements UseCase<String, InsertReturnCostUseCaseParams> {
  InsertReturnCostUseCase({required this.warehouseRepository});

  final WarehouseRepository warehouseRepository;

  @override
  Future<Either<Failure, String>> execute(
      InsertReturnCostUseCaseParams params) async {
    return await warehouseRepository.insertReturnCost(params);
  }
}

class InsertReturnCostUseCaseParams extends Equatable {
  const InsertReturnCostUseCaseParams({
    required this.purchaseNoteId,
    required this.amount,
  });

  final String purchaseNoteId;
  final int amount;

  @override
  List<Object?> get props => [purchaseNoteId, amount];
}
