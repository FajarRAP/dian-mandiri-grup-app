import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/common/dropdown_entity.dart';
import '../../../../core/failure/failure.dart';
import '../../../../core/usecase/use_case.dart';
import '../repositories/warehouse_repository.dart';

class FetchPurchaseNotesDropdownUseCase
    implements
        UseCase<List<DropdownEntity>, FetchPurchaseNotesDropdownUseCaseParams> {
  const FetchPurchaseNotesDropdownUseCase({required this.warehouseRepository});

  final WarehouseRepository warehouseRepository;

  @override
  Future<Either<Failure, List<DropdownEntity>>> execute(
      FetchPurchaseNotesDropdownUseCaseParams params) async {
    return await warehouseRepository.fetchPurchaseNotesDropdown(params);
  }
}

class FetchPurchaseNotesDropdownUseCaseParams extends Equatable {
  const FetchPurchaseNotesDropdownUseCaseParams({
    this.search,
    this.limit = 10,
    this.page = 1,
  });

  final String? search;
  final int limit;
  final int page;

  @override
  List<Object?> get props => [search, limit, page];
}
