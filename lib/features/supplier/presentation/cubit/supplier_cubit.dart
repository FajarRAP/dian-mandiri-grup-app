import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../core/common/dropdown_entity.dart';
import '../../domain/entities/supplier_detail_entity.dart';
import '../../domain/entities/supplier_entity.dart';
import '../../domain/usecases/fetch_supplier_use_case.dart';
import '../../domain/usecases/fetch_suppliers_dropdown_use_case.dart';
import '../../domain/usecases/fetch_suppliers_use_case.dart';
import '../../domain/usecases/insert_supplier_use_case.dart';
import '../../domain/usecases/update_supplier_use_case.dart';

part 'supplier_state.dart';

class SupplierCubit extends Cubit<SupplierState> {
  SupplierCubit({
    required FetchSupplierUseCase fetchSupplierUseCase,
    required FetchSuppliersUseCase fetchSuppliersUseCase,
    required FetchSuppliersDropdownUseCase fetchSuppliersDropdownUseCase,
    required InsertSupplierUseCase insertSupplierUseCase,
    required UpdateSupplierUseCase updateSupplierUseCase,
  })  : _fetchSupplierUseCase = fetchSupplierUseCase,
        _fetchSuppliersUseCase = fetchSuppliersUseCase,
        _fetchSuppliersDropdownUseCase = fetchSuppliersDropdownUseCase,
        _insertSupplierUseCase = insertSupplierUseCase,
        _updateSupplierUseCase = updateSupplierUseCase,
        super(SupplierInitial());

  final FetchSupplierUseCase _fetchSupplierUseCase;
  final FetchSuppliersUseCase _fetchSuppliersUseCase;
  final FetchSuppliersDropdownUseCase _fetchSuppliersDropdownUseCase;
  final InsertSupplierUseCase _insertSupplierUseCase;
  final UpdateSupplierUseCase _updateSupplierUseCase;

  var _currentPage = 1;
  final _suppliers = <SupplierEntity>[];

  Future<void> fetchSupplier({required String supplierId}) async {
    emit(FetchSupplierLoading());

    final result = await _fetchSupplierUseCase(supplierId);

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
      search: search,
      column: column,
      sort: sort,
    );
    final result = await _fetchSuppliersUseCase(params);

    result.fold(
      (failure) => emit(FetchSuppliersError(message: failure.message)),
      (suppliers) => emit(FetchSuppliersLoaded(
          suppliers: _suppliers
            ..clear()
            ..addAll(suppliers))),
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
      search: search,
      sort: sort,
      page: ++_currentPage,
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
    emit(FetchSuppliersDropdownLoading());

    final params = FetchSuppliersDropdownUseCaseParams(search: search);
    final result = await _fetchSuppliersDropdownUseCase(params);

    result.fold(
      (failure) => emit(FetchSuppliersDropdownError(message: failure.message)),
      (suppliers) => emit(FetchSuppliersDropdownLoaded(suppliers: suppliers)),
    );
  }

  Future<void> insertSupplier(
      {required SupplierDetailEntity supplierDetailEntity}) async {
    emit(InsertSupplierLoading());

    final result = await _insertSupplierUseCase(supplierDetailEntity);

    result.fold(
      (failure) => emit(InsertSupplierError(message: failure.message)),
      (message) => emit(InsertSupplierLoaded(message: message)),
    );
  }

  Future<void> updateSupplier(
      {required SupplierDetailEntity supplierDetailEntity}) async {
    emit(UpdateSupplierLoading());

    final result = await _updateSupplierUseCase(supplierDetailEntity);

    result.fold(
      (failure) => emit(UpdateSupplierError(message: failure.message)),
      (message) => emit(UpdateSupplierLoaded(message: message)),
    );
  }
}
