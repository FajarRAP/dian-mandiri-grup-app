import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../../../../core/usecase/use_case.dart';
import '../../../../../main.dart';
import '../../../domain/entities/shipment_report_entity.dart';
import '../../../domain/usecases/create_shipment_report_use_case.dart';
import '../../../domain/usecases/download_shipment_report_use_case.dart';
import '../../../domain/usecases/fetch_shipment_reports_use_case.dart';

part 'shipment_state.dart';

class ShipmentCubit extends Cubit<ShipmentState> {
  ShipmentCubit({
    required CreateShipmentReportUseCase createShipmentReportUseCase,
    required DownloadShipmentReportUseCase downloadShipmentReportUseCase,
    required FetchShipmentReportsUseCase fetchShipmentReportsUseCase,
  }) : _createShipmentReportUseCase = createShipmentReportUseCase,
       _downloadShipmentReportUseCase = downloadShipmentReportUseCase,
       _fetchShipmentReportsUseCase = fetchShipmentReportsUseCase,
       super(ShipmentInitial());

  final CreateShipmentReportUseCase _createShipmentReportUseCase;
  final DownloadShipmentReportUseCase _downloadShipmentReportUseCase;
  final FetchShipmentReportsUseCase _fetchShipmentReportsUseCase;

  var _currentPage = 1;
  final _shipmentReports = <ShipmentReportEntity>[];

  Future<void> createShipmentReport({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    emit(CreateShipmentReportLoading());

    final params = CreateShipmentReportUseCaseParams(
      startDate: startDate,
      endDate: endDate,
    );
    final result = await _createShipmentReportUseCase(params);

    result.fold(
      (failure) => emit(CreateShipmentReportError(message: failure.message)),
      (message) => emit(CreateShipmentReportLoaded(message: message)),
    );
  }

  Future<void> downloadShipmentReport({
    required ShipmentReportEntity shipmentReportEntity,
  }) async {
    emit(
      DownloadShipmentReportLoading(shipmentReportId: shipmentReportEntity.id),
    );

    final params = DownloadShipmentReportUseCaseParams(
      externalPath: externalPath,
      fileUrl: shipmentReportEntity.file,
      filename: shipmentReportEntity.name,
      createdAt: shipmentReportEntity.date,
    );
    final result = await _downloadShipmentReportUseCase(params);

    result.fold(
      (failure) => emit(DownloadShipmentReportError(message: failure.message)),
      (message) => emit(DownloadShipmentReportLoaded(message: message)),
    );
  }

  Future<void> fetchShipmentReports({
    required DateTime startDate,
    required DateTime endDate,
    required String status,
  }) async {
    emit(FetchShipmentReportsLoading());

    final params = FetchShipmentReportsUseCaseParams(
      startDate: startDate,
      endDate: endDate,
      status: status,
      paginate: PaginateParams(page: _currentPage = 1),
    );
    final result = await _fetchShipmentReportsUseCase(params);

    result.fold(
      (failure) => emit(FetchShipmentReportsError(message: failure.message)),
      (shipmentReports) => emit(
        FetchShipmentReportsLoaded(
          shipmentReports: _shipmentReports
            ..clear()
            ..addAll(shipmentReports),
        ),
      ),
    );
  }

  Future<void> fetchShipmentReportsPaginate({
    required DateTime startDate,
    required DateTime endDate,
    required String status,
  }) async {
    // emit(ListPaginateLoading());

    // final params = FetchShipmentReportsUseCaseParams(
    //   startDate: startDate,
    //   endDate: endDate,
    //   status: status,
    //   paginate: PaginateParams(page: ++_currentPage),
    // );
    // final result = await _fetchShipmentReportsUseCase(params);

    // result.fold(
    //   (failure) => emit(FetchShipmentReportsError(message: failure.message)),
    //   (shipmentReports) {
    //     if (shipmentReports.isEmpty) {
    //       _currentPage = 1;
    //       emit(ListPaginateLast());
    //     } else {
    //       emit(ListPaginateLoaded());
    //       emit(
    //         FetchShipmentReportsLoaded(
    //           shipmentReports: _shipmentReports..addAll(shipmentReports),
    //         ),
    //       );
    //     }
    //   },
    // );
  }
}
