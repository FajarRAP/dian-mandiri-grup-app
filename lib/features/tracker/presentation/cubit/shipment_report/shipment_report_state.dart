part of 'shipment_report_cubit.dart';

enum ShipmentReportStatus { initial, inProgress, success, failure }

class ShipmentReportState extends Equatable {
  const ShipmentReportState({
    this.status = .initial,
    this.reports = const [],
    this.currentPage = 1,
    this.hasReachedMax = false,
    this.isPaginating = false,
    this.downloadingReportId,
    this.dateTimeRange,
    this.filterStatus = AppConstants.completedReport,
    this.message,
    this.failure,
  });

  // Status
  final ShipmentReportStatus status;

  // State Properties
  final List<ShipmentReportUiModel> reports;
  final int currentPage;
  final bool hasReachedMax;
  final bool isPaginating;
  final String? downloadingReportId;

  // Filters
  final DateTimeRange? dateTimeRange;
  final String filterStatus;

  // Success
  final String? message;

  // Failure
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
    List<ShipmentReportUiModel>? reports,
    int? currentPage,
    bool? hasReachedMax,
    bool? isPaginating,
    String? downloadingReportId,
    DateTimeRange? dateTimeRange,
    String? filterStatus,
    String? message,
    Failure? failure,
  }) {
    return ShipmentReportState(
      status: status ?? this.status,
      reports: reports ?? this.reports,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isPaginating: isPaginating ?? this.isPaginating,
      downloadingReportId: downloadingReportId ?? this.downloadingReportId,
      dateTimeRange: dateTimeRange ?? this.dateTimeRange,
      filterStatus: filterStatus ?? this.filterStatus,
      message: message ?? this.message,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [
    status,
    reports,
    currentPage,
    hasReachedMax,
    isPaginating,
    downloadingReportId,
    dateTimeRange,
    filterStatus,
    message,
    failure,
  ];
}
