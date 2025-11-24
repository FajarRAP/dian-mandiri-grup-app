import 'package:dartz/dartz.dart';

import '../../../../core/common/use_cases.dart';
import '../../../../core/failure/failure.dart';
import '../repositories/warehouse_repository.dart';

class InsertShippingFeeUseCase
    implements AsyncUseCaseParams<String, InsertShippingFeeUseCaseParams> {
  const InsertShippingFeeUseCase({required this.warehouseRepository});

  final WarehouseRepository warehouseRepository;

  @override
  Future<Either<Failure, String>> call(
      InsertShippingFeeUseCaseParams params) async {
    return await warehouseRepository.insertShippingFee(params: params);
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
