import 'package:dartz/dartz.dart';

import '../../../../core/common/use_cases.dart';
import '../../../../core/failure/failure.dart';
import '../repositories/warehouse_repository.dart';

class InsertReturnCostUseCase
    implements AsyncUseCaseParams<String, InsertReturnCostUseCaseParams> {
  InsertReturnCostUseCase({required this.warehouseRepository});

  final WarehouseRepository warehouseRepository;

  @override
  Future<Either<Failure, String>> call(
      InsertReturnCostUseCaseParams params) async {
    return await warehouseRepository.insertReturnCost(params: params);
  }
}

final class InsertReturnCostUseCaseParams {
  const InsertReturnCostUseCaseParams({
    required this.purchaseNoteId,
    required this.amount,
  });

  final String purchaseNoteId;
  final int amount;
}
