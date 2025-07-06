import 'package:dartz/dartz.dart';

import '../../../../core/common/dropdown_entity.dart';
import '../../../../core/common/use_cases.dart';
import '../../../../core/failure/failure.dart';
import '../repositories/warehouse_repositories.dart';

class FetchPurchaseNotesDropdownUseCase
    implements AsyncUseCaseParams<List<DropdownEntity>, Map<String, dynamic>> {
  const FetchPurchaseNotesDropdownUseCase(
      {required this.warehouseRepositories});

  final WarehouseRepositories warehouseRepositories;

  @override
  Future<Either<Failure, List<DropdownEntity>>> call(
      Map<String, dynamic> params) async {
    return await warehouseRepositories.fetchPurchaseNotesDropdown(
      search: params['search'],
      limit: params['limit'] ?? 10,
      page: params['page'] ?? 1,
    );
  }
}
