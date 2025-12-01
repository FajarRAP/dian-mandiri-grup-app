import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../common/constants/app_enums.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/usecase/use_case.dart';
import '../../../domain/entities/supplier_entity.dart';
import '../../../domain/usecases/create_supplier_use_case.dart';
import '../../../domain/usecases/fetch_suppliers_use_case.dart';

part 'new_supplier_state.dart';

class NewSupplierCubit extends Cubit<NewSupplierState> {
  NewSupplierCubit({
    required FetchSuppliersUseCase fetchSuppliersUseCase,
    required CreateSupplierUseCase createSupplierUseCase,
  }) : _fetchSuppliersUseCase = fetchSuppliersUseCase,
       _createSupplierUseCase = createSupplierUseCase,

       super(const NewSupplierState());

  final FetchSuppliersUseCase _fetchSuppliersUseCase;
  final CreateSupplierUseCase _createSupplierUseCase;

  Future<void> fetchSuppliers({SortOptions? sortOption, String? query}) async {
    final effectiveQuery = query ?? state.query;
    final effectiveSortOption = sortOption ?? state.sortOptions;

    emit(
      state.copyWith(
        status: .inProgress,
        actionStatus: .initial,
        query: effectiveQuery,
        sortOptions: effectiveSortOption,
        currentPage: 1,
        hasReachedMax: false,
        isPaginating: false,
      ),
    );

    final [column, sort] = effectiveSortOption.parseApiValue;
    final params = FetchSuppliersUseCaseParams(
      column: column,
      sort: sort,
      search: SearchParams(query: effectiveQuery),
    );
    final result = await _fetchSuppliersUseCase(params);

    result.fold(
      (failure) => emit(state.copyWith(status: .failure, failure: failure)),
      (suppliers) => emit(
        state.copyWith(
          status: .success,
          suppliers: suppliers,
          hasReachedMax: suppliers.isEmpty,
        ),
      ),
    );
  }

  Future<void> fetchSuppliersPaginate() async {
    if (state.hasReachedMax || state.isPaginating) return;

    emit(state.copyWith(isPaginating: true));

    final [column, sort] = state.sortOptions.parseApiValue;
    final params = FetchSuppliersUseCaseParams(
      column: column,
      sort: sort,
      search: SearchParams(query: state.query),
      paginate: PaginateParams(page: state.currentPage + 1),
    );
    final result = await _fetchSuppliersUseCase(params);

    result.fold(
      (failure) => emit(
        state.copyWith(
          hasReachedMax: true,
          isPaginating: false,
          failure: failure,
        ),
      ),
      (suppliers) => emit(
        state.copyWith(
          isPaginating: false,
          hasReachedMax: suppliers.isEmpty,
          currentPage: state.currentPage + 1,
          suppliers: [...state.suppliers, ...suppliers],
        ),
      ),
    );
  }

  Future<void> createSupplier({
    required String name,
    required String phoneNumber,
    String? address,
    String? avatar,
    String? email,
  }) async {
    emit(state.copyWith(actionStatus: .inProgress));

    final params = CreateSupplierUseCaseParams(
      name: name,
      phoneNumber: phoneNumber,
    );
    final result = await _createSupplierUseCase(params);

    result.fold(
      (failure) =>
          emit(state.copyWith(actionStatus: .failure, failure: failure)),
      (message) =>
          emit(state.copyWith(actionStatus: .success, message: message)),
    );
  }
}
