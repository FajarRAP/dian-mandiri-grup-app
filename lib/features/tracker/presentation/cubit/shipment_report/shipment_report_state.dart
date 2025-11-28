part of 'shipment_report_cubit.dart';

enum ShipmentReportStatus { initial, inProgress, success, failure }

enum ShipmentReportActionStatus { initial, inProgress, success, failure }

class ShipmentReportState extends Equatable {
  const ShipmentReportState({
    required this.status,
    required this.actionStatus,
    required this.reports,
    required this.currentPage,
    required this.hasReachedMax,
    required this.isPaginating,
    required this.downloadingReportId,
    this.message,
    this.failure,
  });

  factory ShipmentReportState.initial() {
    return const ShipmentReportState(
      status: .initial,
      actionStatus: .initial,
      reports: [],
      currentPage: 1,
      hasReachedMax: false,
      isPaginating: false,
      downloadingReportId: null,
      message: null,
      failure: null,
    );
  }

  final ShipmentReportStatus status;
  final ShipmentReportActionStatus actionStatus;

  final List<ShipmentReportUiModel> reports;
  final int currentPage;
  final bool hasReachedMax;
  final bool isPaginating;

  final String? downloadingReportId;

  final String? message;
  final Failure? failure;

  bool shouldRebuild(ShipmentReportState previous) {
    return previous.status != status ||
        previous.reports != reports ||
        previous.downloadingReportId != downloadingReportId ||
        previous.hasReachedMax != hasReachedMax ||
        previous.isPaginating != isPaginating;
  }

  ShipmentReportState copyWith({
    ShipmentReportStatus? status,
    ShipmentReportActionStatus? actionStatus,
    List<ShipmentReportUiModel>? reports,
    int? currentPage,
    bool? hasReachedMax,
    bool? isPaginating,
    String? downloadingReportId,
    String? message,
    Failure? failure,
  }) {
    return ShipmentReportState(
      status: status ?? this.status,
      actionStatus: actionStatus ?? this.actionStatus,
      reports: reports ?? this.reports,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isPaginating: isPaginating ?? this.isPaginating,
      downloadingReportId: downloadingReportId,
      message: message ?? this.message,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [
    status,
    actionStatus,
    reports,
    currentPage,
    hasReachedMax,
    isPaginating,
    downloadingReportId,
    message,
    failure,
  ];
}
