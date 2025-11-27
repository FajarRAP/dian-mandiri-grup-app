import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/usecase/use_case.dart';
import '../../../domain/entities/shipment_report_entity.dart';
import '../../../domain/usecases/create_shipment_report_use_case.dart';
import '../../../domain/usecases/download_shipment_report_use_case.dart';
import '../../../domain/usecases/fetch_shipment_reports_use_case.dart';

part 'shipment_report_state.dart';

class ShipmentReportCubit extends Cubit<ShipmentReportState> {
  ShipmentReportCubit({
    required CreateShipmentReportUseCase createShipmentReportUseCase,
    required DownloadShipmentReportUseCase downloadShipmentReportUseCase,
    required FetchShipmentReportsUseCase fetchShipmentReportsUseCase,
  }) : _createShipmentReportUseCase = createShipmentReportUseCase,
       _downloadShipmentReportUseCase = downloadShipmentReportUseCase,
       _fetchShipmentReportsUseCase = fetchShipmentReportsUseCase,
       super(ShipmentReportState.initial());

  final CreateShipmentReportUseCase _createShipmentReportUseCase;
  final DownloadShipmentReportUseCase _downloadShipmentReportUseCase;
  final FetchShipmentReportsUseCase _fetchShipmentReportsUseCase;

  Future<void> createShipmentReport({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    emit(state.copyWith(actionStatus: .inProgress));

    final params = CreateShipmentReportUseCaseParams(
      startDate: startDate,
      endDate: endDate,
    );
    final result = await _createShipmentReportUseCase(params);

    result.fold(
      (failure) =>
          emit(state.copyWith(actionStatus: .failure, failure: failure)),
      (message) =>
          emit(state.copyWith(actionStatus: .success, message: message)),
    );
  }

  Future<void> downloadShipmentReport({
    required ShipmentReportEntity shipmentReportEntity,
  }) async {
    // emit(
    //   DownloadShipmentReportLoading(shipmentReportId: shipmentReportEntity.id),
    // );

    // final params = DownloadShipmentReportUseCaseParams(
    //   externalPath: externalPath,
    //   fileUrl: shipmentReportEntity.file,
    //   filename: shipmentReportEntity.name,
    //   createdAt: shipmentReportEntity.date,
    // );
    // final result = await _downloadShipmentReportUseCase(params);

    // result.fold(
    //   (failure) => emit(DownloadShipmentReportError(message: failure.message)),
    //   (message) => emit(DownloadShipmentReportLoaded(message: message)),
    // );
  }

  Future<void> fetchShipmentReports({
    required DateTime startDate,
    required DateTime endDate,
    required String status,
  }) async {
    emit(state.copyWith(status: .inProgress));

    final params = FetchShipmentReportsUseCaseParams(
      startDate: startDate,
      endDate: endDate,
      status: status,
    );
    final result = await _fetchShipmentReportsUseCase(params);

    result.fold(
      (failure) => emit(state.copyWith(status: .failure, failure: failure)),
      (reports) => emit(state.copyWith(status: .success, reports: reports)),
    );
  }

  Future<void> fetchShipmentReportsPaginate({
    required DateTime startDate,
    required DateTime endDate,
    required String status,
  }) async {
    if (state.hasReachedMax) return;

    emit(state.copyWith(isPaginating: true));

    final params = FetchShipmentReportsUseCaseParams(
      startDate: startDate,
      endDate: endDate,
      status: status,
      paginate: PaginateParams(page: state.currentPage + 1),
    );
    final result = await _fetchShipmentReportsUseCase(params);

    result.fold(
      (failure) =>
          emit(state.copyWith(status: .failure, message: failure.message)),
      (shipmentReports) {
        shipmentReports.isEmpty
            ? emit(state.copyWith(hasReachedMax: true, isPaginating: false))
            : emit(
                state.copyWith(
                  reports: [...state.reports, ...shipmentReports],
                  currentPage: state.currentPage + 1,
                  isPaginating: false,
                ),
              );
      },
    );
  }
}
