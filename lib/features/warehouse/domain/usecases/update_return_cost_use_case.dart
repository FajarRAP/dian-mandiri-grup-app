import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/use_case.dart';
import '../repositories/warehouse_repository.dart';

class UpdateReturnCostUseCase
    implements UseCase<String, UpdateReturnCostUseCaseParams> {
  UpdateReturnCostUseCase({required this.warehouseRepository});

  final WarehouseRepository warehouseRepository;

  @override
  Future<Either<Failure, String>> execute(
    UpdateReturnCostUseCaseParams params,
  ) async {
    return await warehouseRepository.updateReturnCost(params);
  }
}

class UpdateReturnCostUseCaseParams extends Equatable {
  const UpdateReturnCostUseCaseParams({
    required this.purchaseNoteId,
    required this.amount,
  });

  final String purchaseNoteId;
  final int amount;

  @override
  List<Object?> get props => [purchaseNoteId, amount];
}
