part of 'dropdown_cubit.dart';

enum DropdownStatus { initial, inProgress, success, failure }

class DropdownState extends Equatable {
  const DropdownState({
    this.status = DropdownStatus.initial,
    this.items = const [],
    this.currentPage = 1,
    this.hasReachedMax = false,
    this.isPaginating = false,
    this.query,
    this.failure,
  });

  final DropdownStatus status;
  final List<DropdownEntity> items;
  final int currentPage;
  final bool hasReachedMax;
  final bool isPaginating;

  final String? query;

  final Failure? failure;

  DropdownState copyWith({
    DropdownStatus? status,
    List<DropdownEntity>? items,
    int? currentPage,
    bool? hasReachedMax,
    bool? isPaginating,
    String? query,
    Failure? failure,
  }) {
    return DropdownState(
      status: status ?? this.status,
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isPaginating: isPaginating ?? this.isPaginating,
      query: query ?? '',
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [
    status,
    items,
    currentPage,
    hasReachedMax,
    isPaginating,
    query,
    failure,
  ];
}
