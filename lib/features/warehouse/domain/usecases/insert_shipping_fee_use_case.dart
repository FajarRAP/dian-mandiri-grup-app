import 'package:dartz/dartz.dart';

import '../../../../core/common/use_cases.dart';
import '../../../../core/failure/failure.dart';
import '../repositories/warehouse_repositories.dart';

class InsertShippingFeeUseCase
    implements AsyncUseCaseParams<String, InsertShippingFeeUseCaseParams> {
  const InsertShippingFeeUseCase({required this.warehouseRepositories});

  final WarehouseRepositories warehouseRepositories;

  @override
  Future<Either<Failure, String>> call(
      InsertShippingFeeUseCaseParams params) async {
    return await warehouseRepositories.insertShippingFee(params: params);
  }
}

final class InsertShippingFeeUseCaseParams {
  const InsertShippingFeeUseCaseParams({
    required this.price,
    required this.purchaseNoteIds,
  });

  final int price;
  final List<String> purchaseNoteIds;
}
