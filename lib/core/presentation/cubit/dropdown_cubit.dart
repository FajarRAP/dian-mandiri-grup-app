import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../features/supplier/domain/usecases/fetch_suppliers_dropdown_use_case.dart';
import '../../../features/warehouse/domain/usecases/fetch_purchase_notes_dropdown_use_case.dart';
import '../../domain/entities/dropdown_entity.dart';
import '../../errors/failure.dart';
import '../../usecase/use_case.dart';
import '../../utils/typedefs.dart';

part 'dropdown_state.dart';

class DropdownCubit extends Cubit<DropdownState> {
  DropdownCubit({
    required FetchSuppliersDropdownUseCase fetchSuppliersDropdownUseCase,
    required FetchPurchaseNotesDropdownUseCase
    fetchPurchaseNotesDropdownUseCase,
  }) : _fetchSuppliersDropdownUseCase = fetchSuppliersDropdownUseCase,
       _fetchPurchaseNotesDropdownUseCase = fetchPurchaseNotesDropdownUseCase,
       super(const DropdownState());

  final FetchSuppliersDropdownUseCase _fetchSuppliersDropdownUseCase;
  final FetchPurchaseNotesDropdownUseCase _fetchPurchaseNotesDropdownUseCase;

  Future<void> fetchSuppliers({
    String query = '',
    bool showAll = false,
  }) async => _fetch(
    usecase: () async {
      final params = FetchSuppliersDropdownUseCaseParams(
        search: SearchParams(query: query),
        showAll: showAll,
      );
      return await _fetchSuppliersDropdownUseCase(params);
    },
  );

  Future<void> fetchSuppliersPaginate() async => await _paginate(
    usecase: () async {
      final params = FetchSuppliersDropdownUseCaseParams(
        paginate: PaginateParams(page: state.currentPage + 1),
        search: SearchParams(query: state.query),
      );
      return await _fetchSuppliersDropdownUseCase(params);
    },
  );

  Future<void> fetchPurchaseNotes({
    String query = '',
    bool showAll = false,
  }) async => await _fetch(
    usecase: () async {
      final params = FetchPurchaseNotesDropdownUseCaseParams(
        search: SearchParams(query: query),
        showAll: showAll,
      );
      return await _fetchPurchaseNotesDropdownUseCase(params);
    },
  );

  Future<void> fetchPurchaseNotesPaginate() async => await _paginate(
    usecase: () async {
      final params = FetchPurchaseNotesDropdownUseCaseParams(
        paginate: PaginateParams(page: state.currentPage + 1),
        search: SearchParams(query: state.query),
      );
      return await _fetchPurchaseNotesDropdownUseCase(params);
    },
  );

  Future<void> _fetch({
    String query = '',
    required ListDropdownUseCase Function() usecase,
  }) async {
    emit(
      state.copyWith(
        status: .inProgress,
        currentPage: 1,
        hasReachedMax: false,
        isPaginating: false,
        query: query,
      ),
    );

    final result = await usecase();

    result.fold(
      (failure) => emit(state.copyWith(status: .failure, failure: failure)),
      (items) => emit(state.copyWith(status: .success, items: items)),
    );
  }

  Future<void> _paginate({
    required ListDropdownUseCase Function() usecase,
  }) async {
    if (state.hasReachedMax || state.isPaginating) return;

    emit(state.copyWith(isPaginating: true));

    final result = await usecase();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: .failure,
          hasReachedMax: true,
          isPaginating: false,
          failure: failure,
        ),
      ),
      (suppliers) => emit(
        state.copyWith(
          status: .success,
          isPaginating: false,
          hasReachedMax: suppliers.isEmpty,
          currentPage: state.currentPage + 1,
          items: [...state.items, ...suppliers],
        ),
      ),
    );
  }
}
