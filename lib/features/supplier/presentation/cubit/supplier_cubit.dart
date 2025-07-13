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

  Future<void> fetchSupplier({required String supplierId}) async {
    emit(FetchSupplierLoading());

    final result = await _fetchSupplierUseCase(supplierId);

    result.fold(
      (l) => emit(FetchSupplierError(message: l.message)),
      (r) => emit(FetchSupplierLoaded(supplierDetail: r)),
    );
  }

  Future<void> fetchSuppliers({
    String? search,
    String? column,
    String? order,
  }) async {
    emit(FetchSuppliersLoading());

    final result = await _fetchSuppliersUseCase({
      'search': search,
      'column': column ?? 'name',
      'order': order ?? 'asc',
    });

    result.fold(
      (l) => emit(FetchSuppliersError(message: l.message)),
      (r) => emit(FetchSuppliersLoaded(suppliers: r)),
    );
  }

  Future<void> fetchSuppliersDropdown({
    String? search,
  }) async {
    emit(FetchSuppliersDropdownLoading());
    final result = await _fetchSuppliersDropdownUseCase({
      'search': search,
    });

    result.fold(
      (l) => emit(FetchSuppliersDropdownError(message: l.message)),
      (r) => emit(FetchSuppliersDropdownLoaded(suppliers: r)),
    );
  }

  Future<void> insertSupplier(
      {required SupplierDetailEntity supplierDetailEntity}) async {
    emit(InsertSupplierLoading());

    final result = await _insertSupplierUseCase(supplierDetailEntity);

    result.fold(
      (l) => emit(InsertSupplierError(message: l.message)),
      (r) => emit(InsertSupplierLoaded(message: r)),
    );
  }

  Future<void> updateSupplier(
      {required SupplierDetailEntity supplierDetailEntity}) async {
    emit(UpdateSupplierLoading());

    final result = await _updateSupplierUseCase(supplierDetailEntity);

    result.fold(
      (l) => emit(UpdateSupplierError(message: l.message)),
      (r) => emit(UpdateSupplierLoaded(message: r)),
    );
  }
}
