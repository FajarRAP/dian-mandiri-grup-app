import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../core/common/dropdown_entity.dart';
import '../../../../core/usecase/use_case.dart';
import '../../domain/entities/supplier_detail_entity.dart';
import '../../domain/entities/supplier_entity.dart';
import '../../domain/usecases/fetch_supplier_use_case.dart';
import '../../domain/usecases/fetch_suppliers_dropdown_use_case.dart';
import '../../domain/usecases/fetch_suppliers_use_case.dart';
import '../../domain/usecases/create_supplier_use_case.dart';
import '../../domain/usecases/update_supplier_use_case.dart';

part 'supplier_state.dart';

class SupplierCubit extends Cubit<SupplierState> {
  SupplierCubit({
    required FetchSupplierUseCase fetchSupplierUseCase,
    required FetchSuppliersUseCase fetchSuppliersUseCase,
    required FetchSuppliersDropdownUseCase fetchSuppliersDropdownUseCase,
    required CreateSupplierUseCase createSupplierUseCase,
    required UpdateSupplierUseCase updateSupplierUseCase,
  }) : _fetchSupplierUseCase = fetchSupplierUseCase,
       _fetchSuppliersUseCase = fetchSuppliersUseCase,
       _fetchSuppliersDropdownUseCase = fetchSuppliersDropdownUseCase,
       _createSupplierUseCase = createSupplierUseCase,
       _updateSupplierUseCase = updateSupplierUseCase,
       super(SupplierInitial());

  final FetchSupplierUseCase _fetchSupplierUseCase;
  final FetchSuppliersUseCase _fetchSuppliersUseCase;
  final FetchSuppliersDropdownUseCase _fetchSuppliersDropdownUseCase;
  final CreateSupplierUseCase _createSupplierUseCase;
  final UpdateSupplierUseCase _updateSupplierUseCase;

  var _currentPage = 1;
  final _suppliers = <SupplierEntity>[];
  final _supplierDropdowns = <DropdownEntity>[];

  Future<void> fetchSupplier({required String supplierId}) async {
    emit(FetchSupplierLoading());

    final params = FetchSupplierUseCaseParams(supplierId: supplierId);
    final result = await _fetchSupplierUseCase(params);

    result.fold(
      (failure) => emit(FetchSupplierError(message: failure.message)),
      (supplierDetail) =>
          emit(FetchSupplierLoaded(supplierDetail: supplierDetail)),
    );
  }

  Future<void> fetchSuppliers({
    String? search,
    String column = 'name',
    String sort = 'asc',
  }) async {
    _currentPage = 1;

    emit(FetchSuppliersLoading());

    final params = FetchSuppliersUseCaseParams(
      search: SearchParams(query: search),
      column: column,
      sort: sort,
    );
    final result = await _fetchSuppliersUseCase(params);

    result.fold(
      (failure) => emit(FetchSuppliersError(message: failure.message)),
      (suppliers) => emit(
        FetchSuppliersLoaded(
          suppliers: _suppliers
            ..clear()
            ..addAll(suppliers),
        ),
      ),
    );
  }

  Future<void> fetchSuppliersPaginate({
    String? search,
    String column = 'name',
    String sort = 'asc',
  }) async {
    emit(ListPaginateLoading());

    final params = FetchSuppliersUseCaseParams(
      column: column,
      search: SearchParams(query: search),
      sort: sort,
      paginate: PaginateParams(page: ++_currentPage),
    );
    final result = await _fetchSuppliersUseCase(params);

    result.fold(
      (failure) => emit(FetchSuppliersError(message: failure.message)),
      (suppliers) {
        if (suppliers.isEmpty) {
          _currentPage = 1;
          emit(ListPaginateLast());
        } else {
          emit(ListPaginateLoaded());
          emit(FetchSuppliersLoaded(suppliers: _suppliers..addAll(suppliers)));
        }
      },
    );
  }

  Future<void> fetchSuppliersDropdown({String? search}) async {
    _currentPage = 1;

    emit(FetchSuppliersDropdownLoading());

    final params = FetchSuppliersDropdownUseCaseParams(
      search: SearchParams(query: search),
      paginate: const PaginateParams(page: 1),
    );
    final result = await _fetchSuppliersDropdownUseCase(params);

    result.fold(
      (failure) => emit(FetchSuppliersDropdownError(message: failure.message)),
      (suppliers) => emit(
        FetchSuppliersDropdownLoaded(
          suppliers: _supplierDropdowns
            ..clear()
            ..addAll(suppliers),
        ),
      ),
    );
  }

  Future<void> fetchSuppliersDropdownPaginate({String? search}) async {
    emit(ListPaginateLoading());

    final params = FetchSuppliersDropdownUseCaseParams(
      search: SearchParams(query: search),
      paginate: PaginateParams(page: ++_currentPage),
    );
    final result = await _fetchSuppliersDropdownUseCase(params);

    result.fold(
      (failure) => emit(FetchSuppliersDropdownError(message: failure.message)),
      (suppliers) {
        if (suppliers.isEmpty) {
          _currentPage = 1;
          emit(ListPaginateLast());
        } else {
          emit(ListPaginateLoaded());
          emit(
            FetchSuppliersDropdownLoaded(
              suppliers: _supplierDropdowns..addAll(suppliers),
            ),
          );
        }
      },
    );
  }

  Future<void> createSupplier({
    required CreateSupplierUseCaseParams params,
  }) async {
    emit(InsertSupplierLoading());

    final result = await _createSupplierUseCase(params);

    result.fold(
      (failure) => emit(InsertSupplierError(message: failure.message)),
      (message) => emit(InsertSupplierLoaded(message: message)),
    );
  }

  Future<void> updateSupplier({
    required SupplierDetailEntity supplierDetailEntity,
  }) async {
    emit(UpdateSupplierLoading());

    final params = UpdateSupplierUseCaseParams(
      supplierDetailEntity: supplierDetailEntity,
    );
    final result = await _updateSupplierUseCase(params);

    result.fold(
      (failure) => emit(UpdateSupplierError(message: failure.message)),
      (message) => emit(UpdateSupplierLoaded(message: message)),
    );
  }
}
