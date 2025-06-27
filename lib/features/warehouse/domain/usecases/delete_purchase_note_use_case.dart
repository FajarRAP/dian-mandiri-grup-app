import 'package:dartz/dartz.dart';

import '../../../../core/common/use_cases.dart';
import '../../../../core/failure/failure.dart';
import '../repositories/warehouse_repositories.dart';

class DeletePurchaseNoteUseCase implements AsyncUseCaseParams<String, String> {
  const DeletePurchaseNoteUseCase({required this.warehouseRepositories});

  final WarehouseRepositories warehouseRepositories;

  @override
  Future<Either<Failure, String>> call(String params) async {
    return warehouseRepositories.deletePurchaseNote(purchaseNoteId: params);
  }
}
