import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/use_case.dart';
import '../../../../main.dart';
import '../../domain/entities/shipment_detail_entity.dart';
import '../../domain/entities/shipment_entity.dart';
import '../../domain/entities/shipment_history_entity.dart';
import '../../domain/entities/shipment_report_entity.dart';
import '../../domain/usecases/create_shipment_report_use_case.dart';
import '../../domain/usecases/download_shipment_report_use_case.dart';
import '../../domain/usecases/fetch_shipment_reports_use_case.dart';
import '../../domain/usecases/fetch_shipment_status_use_case.dart';
import '../../domain/usecases/fetch_shipment_use_case.dart';
import '../../domain/usecases/update_shipment_document_use_case.dart';

part 'shipment_state.dart';

class ShipmentCubit extends Cubit<ShipmentState> {
  ShipmentCubit({
    required CreateShipmentReportUseCase createShipmentReportUseCase,
    required DownloadShipmentReportUseCase downloadShipmentReportUseCase,
    required FetchShipmentUseCase fetchShipmentUseCase,
    required FetchShipmentStatusUseCase fetchShipmentStatusUseCase,
    required FetchShipmentReportsUseCase fetchShipmentReportsUseCase,
    required UpdateShipmentDocumentUseCase insertShipmentDocumentUseCase,
  }) : _createShipmentReportUseCase = createShipmentReportUseCase,
       _downloadShipmentReportUseCase = downloadShipmentReportUseCase,
       _fetchShipmentUseCase = fetchShipmentUseCase,
       _fetchShipmentStatusUseCase = fetchShipmentStatusUseCase,
       _fetchShipmentReportsUseCase = fetchShipmentReportsUseCase,
       _insertShipmentDocumentUseCase = insertShipmentDocumentUseCase,
       super(ShipInitial());

  final CreateShipmentReportUseCase _createShipmentReportUseCase;
  final DownloadShipmentReportUseCase _downloadShipmentReportUseCase;
  final FetchShipmentUseCase _fetchShipmentUseCase;
  final FetchShipmentStatusUseCase _fetchShipmentStatusUseCase;
  final FetchShipmentReportsUseCase _fetchShipmentReportsUseCase;
  final UpdateShipmentDocumentUseCase _insertShipmentDocumentUseCase;

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

  Future<void> fetchShipment({required String shipmentId}) async {
    emit(FetchShipmentDetailLoading());

    final params = FetchShipmentUseCaseParams(shipmentId: shipmentId);
    final result = await _fetchShipmentUseCase(params);

    result.fold(
      (failure) => emit(FetchShipmentDetailError(message: failure.message)),
      (shipmentDetail) =>
          emit(FetchShipmentDetailLoaded(shipmentDetail: shipmentDetail)),
    );
  }

  Future<void> fetchShipmentStatus({required String receiptNumber}) async {
    emit(FetchReceiptStatusLoading());

    final params = FetchShipmentStatusUseCaseParams(
      receiptNumber: receiptNumber,
    );
    final result = await _fetchShipmentStatusUseCase(params);

    result.fold(
      (failure) => emit(FetchReceiptStatusError(failure: failure)),
      (shipmentHistory) =>
          emit(FetchReceiptStatusLoaded(shipmentHistory: shipmentHistory)),
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
    emit(ListPaginateLoading());

    final params = FetchShipmentReportsUseCaseParams(
      startDate: startDate,
      endDate: endDate,
      status: status,
      paginate: PaginateParams(page: ++_currentPage),
    );
    final result = await _fetchShipmentReportsUseCase(params);

    result.fold(
      (failure) => emit(FetchShipmentReportsError(message: failure.message)),
      (shipmentReports) {
        if (shipmentReports.isEmpty) {
          _currentPage = 1;
          emit(ListPaginateLast());
        } else {
          emit(ListPaginateLoaded());
          emit(
            FetchShipmentReportsLoaded(
              shipmentReports: _shipmentReports..addAll(shipmentReports),
            ),
          );
        }
      },
    );
  }

  Future<void> insertShipmentDocument({
    required String shipmentId,
    required String documentPath,
    required String stage,
  }) async {
    emit(InsertShipmentDocumentLoading());

    final params = UpdateShipmentDocumentUseCaseParams(
      shipmentId: shipmentId,
      documentPath: documentPath,
      stage: stage,
    );

    final result = await _insertShipmentDocumentUseCase(params);

    result.fold(
      (failure) => emit(InsertShipmentDocumentError(message: failure.message)),
      (message) => emit(InsertShipmentDocumentLoaded(message: message)),
    );
  }
}
