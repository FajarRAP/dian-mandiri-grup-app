import 'package:dartz/dartz.dart';

import '../../../../core/common/use_cases.dart';
import '../../../../core/failure/failure.dart';
import '../repositories/warehouse_repositories.dart';

class InsertShippingFeeUseCase
    implements AsyncUseCaseParams<String, Map<String, dynamic>> {
  const InsertShippingFeeUseCase({required this.warehouseRepositories});

  final WarehouseRepositories warehouseRepositories;

  @override
  Future<Either<Failure, String>> call(Map<String, dynamic> params) async {
    return await warehouseRepositories.insertShippingFee(
      price: params['price'],
      purchaseNoteIds: params['purchase_note_ids'],
    );
  }
}
