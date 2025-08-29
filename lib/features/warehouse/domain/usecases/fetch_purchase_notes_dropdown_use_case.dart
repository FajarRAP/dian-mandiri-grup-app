import 'package:dartz/dartz.dart';

import '../../../../core/common/dropdown_entity.dart';
import '../../../../core/common/use_cases.dart';
import '../../../../core/failure/failure.dart';
import '../repositories/warehouse_repositories.dart';

class FetchPurchaseNotesDropdownUseCase
    implements
        AsyncUseCaseParams<List<DropdownEntity>,
            FetchPurchaseNotesDropdownUseCaseParams> {
  const FetchPurchaseNotesDropdownUseCase(
      {required this.warehouseRepositories});

  final WarehouseRepositories warehouseRepositories;

  @override
  Future<Either<Failure, List<DropdownEntity>>> call(
      FetchPurchaseNotesDropdownUseCaseParams params) async {
    return await warehouseRepositories.fetchPurchaseNotesDropdown(
        params: params);
  }
}

final class FetchPurchaseNotesDropdownUseCaseParams {
  const FetchPurchaseNotesDropdownUseCaseParams({
    this.search,
    this.limit = 10,
    this.page = 1,
  });

  final String? search;
  final int limit;
  final int page;
}
