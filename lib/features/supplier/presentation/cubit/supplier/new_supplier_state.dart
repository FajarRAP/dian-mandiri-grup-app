part of 'new_supplier_cubit.dart';

enum SupplierStatus { initial, inProgress, success, failure }

class NewSupplierState extends Equatable {
  const NewSupplierState({
    this.status = .initial,
    this.suppliers = const <SupplierEntity>[],
    this.currentPage = 1,
    this.hasReachedMax = false,
    this.isPaginating = false,
    this.query,
    this.sortOptions = SortOptions.nameAsc,
    this.message,
    this.failure,
  });

  final SupplierStatus status;
  final List<SupplierEntity> suppliers;
  final int currentPage;
  final bool hasReachedMax;
  final bool isPaginating;

  final String? query;
  final SortOptions sortOptions;

  final String? message;
  final Failure? failure;

  NewSupplierState copyWith({
    SupplierStatus? status,
    List<SupplierEntity>? suppliers,
    int? currentPage,
    bool? hasReachedMax,
    bool? isPaginating,
    String? query,
    SortOptions? sortOptions,
    String? message,
    Failure? failure,
  }) {
    return NewSupplierState(
      status: status ?? this.status,
      suppliers: suppliers ?? this.suppliers,
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
    suppliers,
    currentPage,
    hasReachedMax,
    isPaginating,
    query,
    sortOptions,
    message,
    failure,
  ];
}
