import 'package:dartz/dartz.dart';

import '../../../../core/common/use_cases.dart';
import '../../../../core/failure/failure.dart';
import '../repositories/warehouse_repository.dart';

class DeletePurchaseNoteUseCase implements AsyncUseCaseParams<String, String> {
  const DeletePurchaseNoteUseCase({required this.warehouseRepository});

  final WarehouseRepository warehouseRepository;

  @override
  Future<Either<Failure, String>> call(String params) async {
    return warehouseRepository.deletePurchaseNote(purchaseNoteId: params);
  }
}
