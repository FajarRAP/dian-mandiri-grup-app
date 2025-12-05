import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/use_case.dart';
import '../repositories/warehouse_repository.dart';

class AddShippingFeeUseCase
    implements UseCase<String, AddShippingFeeUseCaseParams> {
  const AddShippingFeeUseCase({required this.warehouseRepository});

  final WarehouseRepository warehouseRepository;

  @override
  Future<Either<Failure, String>> execute(
    AddShippingFeeUseCaseParams params,
  ) async {
    return await warehouseRepository.addShippingFee(params);
  }
}

class AddShippingFeeUseCaseParams extends Equatable {
  const AddShippingFeeUseCaseParams({
    required this.price,
    required this.purchaseNoteIds,
  });

  final int price;
  final List<String> purchaseNoteIds;

  @override
  List<Object?> get props => [price, purchaseNoteIds];
}
