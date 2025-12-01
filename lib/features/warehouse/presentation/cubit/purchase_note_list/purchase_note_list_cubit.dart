import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../common/constants/app_enums.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/usecase/use_case.dart';
import '../../../domain/entities/purchase_note_summary_entity.dart';
import '../../../domain/usecases/delete_purchase_note_use_case.dart';
import '../../../domain/usecases/fetch_purchase_notes_use_case.dart';

part 'purchase_note_list_state.dart';

class PurchaseNoteListCubit extends Cubit<PurchaseNoteListState> {
  PurchaseNoteListCubit({
    required FetchPurchaseNotesUseCase fetchPurchaseNotesUseCase,
    required DeletePurchaseNoteUseCase deletePurchaseNoteUseCase,
  }) : _fetchPurchaseNotesUseCase = fetchPurchaseNotesUseCase,
       _deletePurchaseNoteUseCase = deletePurchaseNoteUseCase,
       super(const PurchaseNoteListState());

  final FetchPurchaseNotesUseCase _fetchPurchaseNotesUseCase;
  final DeletePurchaseNoteUseCase _deletePurchaseNoteUseCase;

  Future<void> fetchPurchaseNotes({
    SortOptions? sortOption,
    String? query,
  }) async {
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
    final params = FetchPurchaseNotesUseCaseParams(
      column: column,
      sort: sort,
      search: SearchParams(query: effectiveQuery),
    );
    final result = await _fetchPurchaseNotesUseCase(params);

    result.fold(
      (failure) => emit(state.copyWith(status: .failure, failure: failure)),
      (purchaseNotes) => emit(
        state.copyWith(
          status: .success,
          purchaseNotes: purchaseNotes,
          hasReachedMax: purchaseNotes.isEmpty,
        ),
      ),
    );
  }

  Future<void> fetchPurchaseNotesPaginate() async {
    if (state.hasReachedMax || state.isPaginating) return;

    emit(state.copyWith(isPaginating: true));

    final [column, sort] = state.sortOptions.parseApiValue;
    final params = FetchPurchaseNotesUseCaseParams(
      column: column,
      sort: sort,
      search: SearchParams(query: state.query),
      paginate: PaginateParams(page: state.currentPage + 1),
    );
    final result = await _fetchPurchaseNotesUseCase(params);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: .failure,
          hasReachedMax: true,
          isPaginating: false,
          failure: failure,
        ),
      ),
      (purchaseNotes) => emit(
        state.copyWith(
          status: .success,
          isPaginating: false,
          hasReachedMax: purchaseNotes.isEmpty,
          currentPage: state.currentPage + 1,
          purchaseNotes: [...state.purchaseNotes, ...purchaseNotes],
        ),
      ),
    );
  }

  Future<void> deletePurchaseNote({required String purchaseNoteId}) async {
    emit(state.copyWith(actionStatus: .inProgress));

    final params = DeletePurchaseNoteUseCaseParams(
      purchaseNoteId: purchaseNoteId,
    );
    final result = await _deletePurchaseNoteUseCase(params);

    result.fold(
      (failure) =>
          emit(state.copyWith(actionStatus: .failure, failure: failure)),
      (message) =>
          emit(state.copyWith(actionStatus: .success, message: message)),
    );
  }
}
