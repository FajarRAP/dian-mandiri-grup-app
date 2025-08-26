import 'package:dartz/dartz.dart';

import '../../../../core/common/use_cases.dart';
import '../../../../core/failure/failure.dart';
import '../repositories/warehouse_repositories.dart';

class UpdatePurchaseNoteUseCase
    implements AsyncUseCaseParams<String, Map<String, dynamic>> {
  const UpdatePurchaseNoteUseCase({required this.warehouseRepositories});

  final WarehouseRepositories warehouseRepositories;

  @override
  Future<Either<Failure, String>> call(Map<String, dynamic> params) async {
    return await warehouseRepositories.updatePurchaseNote(
      purchaseNoteId: params['purchase_note_id'],
      purchaseNote: params['purchase_note'],
    );
  }
}
