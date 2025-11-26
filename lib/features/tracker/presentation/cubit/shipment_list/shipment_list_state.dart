part of 'shipment_list_cubit.dart';

enum ShipmentListStatus {
  initial,
  loading,
  success,
  failure,
  actionInProgress,
  actionSuccess,
  actionFailure,
}

class ShipmentListState extends Equatable {
  const ShipmentListState({
    required this.status,
    required this.shipments,
    required this.currentPage,
    required this.hasReachedMax,
    required this.isPaginating,
    this.message,
    this.failure,
  });

  factory ShipmentListState.initial() {
    return const ShipmentListState(
      status: ShipmentListStatus.initial,
      shipments: [],
      currentPage: 1,
      hasReachedMax: false,
      isPaginating: false,
    );
  }

  final ShipmentListStatus status;
  final List<ShipmentEntity> shipments;
  final int currentPage;
  final bool hasReachedMax;
  final bool isPaginating;

  final String? message;
  final Failure? failure;

  ShipmentListState copyWith({
    ShipmentListStatus? status,
    List<ShipmentEntity>? shipments,
    int? currentPage,
    bool? hasReachedMax,
    bool? isPaginating,
    String? message,
    Failure? failure,
  }) {
    return ShipmentListState(
      status: status ?? this.status,
      shipments: shipments ?? this.shipments,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isPaginating: isPaginating ?? this.isPaginating,
      message: message ?? this.message,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [
    status,
    shipments,
    hasReachedMax,
    currentPage,
    isPaginating,
    message,
    failure,
  ];
}
