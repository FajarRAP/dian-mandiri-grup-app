part of 'purchase_note_list_cubit.dart';

enum PurchaseNoteStatus { initial, inProgress, success, failure }

enum PurchaseNoteActionStatus { initial, inProgress, success, failure }

class PurchaseNoteListState extends Equatable {
  const PurchaseNoteListState({
    this.status = .initial,
    this.actionStatus = .initial,
    this.purchaseNotes = const [],
    this.currentPage = 1,
    this.hasReachedMax = false,
    this.isPaginating = false,
    this.query,
    this.sortOptions = .dateAsc,
    this.message,
    this.failure,
  });

  final PurchaseNoteStatus status;
  final PurchaseNoteActionStatus actionStatus;
  final List<PurchaseNoteSummaryEntity> purchaseNotes;
  final int currentPage;
  final bool hasReachedMax;
  final bool isPaginating;

  final String? query;
  final SortOptions sortOptions;

  final String? message;
  final Failure? failure;

  PurchaseNoteListState copyWith({
    PurchaseNoteStatus? status,
    PurchaseNoteActionStatus? actionStatus,
    List<PurchaseNoteSummaryEntity>? purchaseNotes,
    int? currentPage,
    bool? hasReachedMax,
    bool? isPaginating,
    String? query,
    SortOptions? sortOptions,
    String? message,
    Failure? failure,
  }) {
    return PurchaseNoteListState(
      status: status ?? this.status,
      actionStatus: actionStatus ?? this.actionStatus,
      purchaseNotes: purchaseNotes ?? this.purchaseNotes,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isPaginating: isPaginating ?? this.isPaginating,
      query: query ?? this.query,
      sortOptions: sortOptions ?? this.sortOptions,
      message: message ?? this.message,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [
    status,
    actionStatus,
    purchaseNotes,
    currentPage,
    hasReachedMax,
    isPaginating,
    query,
    sortOptions,
    message,
    failure,
  ];
}
