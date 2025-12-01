import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../features/supplier/domain/usecases/fetch_suppliers_dropdown_use_case.dart';
import '../../../features/warehouse/domain/usecases/fetch_purchase_notes_dropdown_use_case.dart';
import '../../common/dropdown_entity.dart';
import '../../errors/failure.dart';
import '../../usecase/use_case.dart';

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

  Future<void> fetchSuppliers({String query = '', bool showAll = false}) async {
    emit(
      state.copyWith(
        status: .inProgress,
        currentPage: 1,
        hasReachedMax: false,
        isPaginating: false,
      ),
    );

    final params = FetchSuppliersDropdownUseCaseParams(
      search: SearchParams(query: query),
      showAll: showAll,
    );
    final result = await _fetchSuppliersDropdownUseCase(params);

    result.fold(
      (failure) => emit(state.copyWith(status: .failure, failure: failure)),
      (suppliers) => emit(state.copyWith(status: .success, items: suppliers)),
    );
  }

  Future<void> fetchSuppliersPaginate() async {
    if (state.hasReachedMax || state.isPaginating) return;

    emit(state.copyWith(isPaginating: true));

    final params = FetchSuppliersDropdownUseCaseParams(
      paginate: PaginateParams(page: state.currentPage + 1),
      search: SearchParams(query: state.query),
    );
    final result = await _fetchSuppliersDropdownUseCase(params);

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

  // Future<void> fetchPurchaseNotes({String query = '', bool showAll = false}) async {
  //   emit(
  //     state.copyWith(
  //       status: .inProgress,
  //       currentPage: 1,
  //       hasReachedMax: false,
  //       isPaginating: false,
  //     ),
  //   );

  //   final params = FetchSuppliersDropdownUseCaseParams(
  //     search: SearchParams(query: query),
  //     showAll: showAll,
  //   );
  //   final result = await _fetchPurchaseNotesDropdownUseCase(params);

  //   result.fold(
  //     (failure) => emit(state.copyWith(status: .failure, failure: failure)),
  //     (suppliers) => emit(state.copyWith(status: .success, items: suppliers)),
  //   );
  // }

  // Future<void> fetchPurchaseNotesPaginate() async {
  //   if (state.hasReachedMax || state.isPaginating) return;

  //   emit(state.copyWith(isPaginating: true));

  //   final params = FetchSuppliersDropdownUseCaseParams(
  //     paginate: PaginateParams(page: state.currentPage + 1),
  //     search: SearchParams(query: state.query),
  //   );
  //   final result = await _fetchPurchaseNotesDropdownUseCase(params);

  //   result.fold(
  //     (failure) => emit(
  //       state.copyWith(
  //         status: .failure,
  //         hasReachedMax: true,
  //         isPaginating: false,
  //         failure: failure,
  //       ),
  //     ),
  //     (suppliers) => emit(
  //       state.copyWith(
  //         status: .success,
  //         isPaginating: false,
  //         hasReachedMax: suppliers.isEmpty,
  //         currentPage: state.currentPage + 1,
  //         items: [...state.items, ...suppliers],
  //       ),
  //     ),
  //   );
  // }
}
