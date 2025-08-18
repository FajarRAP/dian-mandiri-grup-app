import 'package:dartz/dartz.dart';

import '../../../../core/common/use_cases.dart';
import '../../../../core/failure/failure.dart';
import '../repositories/warehouse_repositories.dart';

class InsertReturnCostUseCase
    implements AsyncUseCaseParams<String, Map<String, dynamic>> {
  InsertReturnCostUseCase({required this.warehouseRepositories});

  final WarehouseRepositories warehouseRepositories;

  @override
  Future<Either<Failure, String>> call(Map<String, dynamic> params) async {
    final purchaseNoteId = params['purchase_note_id'];
    final amount = params['amount'];

    return await warehouseRepositories.insertReturnCost(
        purchaseNoteId: purchaseNoteId, amount: amount);
  }
}
