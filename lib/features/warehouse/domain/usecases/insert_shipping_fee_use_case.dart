import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/usecase/use_case.dart';
import '../repositories/warehouse_repository.dart';

class InsertShippingFeeUseCase
    implements UseCase<String, InsertShippingFeeUseCaseParams> {
  const InsertShippingFeeUseCase({required this.warehouseRepository});

  final WarehouseRepository warehouseRepository;

  @override
  Future<Either<Failure, String>> execute(
      InsertShippingFeeUseCaseParams params) async {
    return await warehouseRepository.insertShippingFee(params);
  }
}

class InsertShippingFeeUseCaseParams extends Equatable {
  const InsertShippingFeeUseCaseParams({
    required this.price,
    required this.purchaseNoteIds,
  });

  final int price;
  final List<String> purchaseNoteIds;

  @override
  List<Object?> get props => [price, purchaseNoteIds];
}
