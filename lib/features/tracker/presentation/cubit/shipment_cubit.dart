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
import '../../domain/usecases/delete_shipment_use_case.dart';
import '../../domain/usecases/download_shipment_report_use_case.dart';
import '../../domain/usecases/fetch_shipment_by_id_use_case.dart';
import '../../domain/usecases/fetch_shipment_by_receipt_number_use_case.dart';
import '../../domain/usecases/fetch_shipment_reports_use_case.dart';
import '../../domain/usecases/fetch_shipments_use_case.dart';
import '../../domain/usecases/insert_shipment_document_use_case.dart';
import '../../domain/usecases/insert_shipment_use_case.dart';

part 'shipment_state.dart';

class ShipmentCubit extends Cubit<ShipmentState> {
  ShipmentCubit({
    required CreateShipmentReportUseCase createShipmentReportUseCase,
    required DeleteShipmentUseCase deleteShipmentUseCase,
    required DownloadShipmentReportUseCase downloadShipmentReportUseCase,
    required FetchShipmentByIdUseCase fetchShipmentByIdUseCase,
    required FetchShipmentByReceiptNumberUseCase
        fetchShipmentByReceiptNumberUseCase,
    required FetchShipmentReportsUseCase fetchShipmentReportsUseCase,
    required FetchShipmentsUseCase fetchShipmentsUseCase,
    required InsertShipmentDocumentUseCase insertShipmentDocumentUseCase,
    required InsertShipmentUseCase insertShipmentUseCase,
  })  : _createShipmentReportUseCase = createShipmentReportUseCase,
        _deleteShipmentUseCase = deleteShipmentUseCase,
        _downloadShipmentReportUseCase = downloadShipmentReportUseCase,
        _fetchShipmentByIdUseCase = fetchShipmentByIdUseCase,
        _fetchShipmentByReceiptNumberUseCase =
            fetchShipmentByReceiptNumberUseCase,
        _fetchShipmentReportsUseCase = fetchShipmentReportsUseCase,
        _fetchShipmentsUseCase = fetchShipmentsUseCase,
        _insertShipmentUseCase = insertShipmentUseCase,
        _insertShipmentDocumentUseCase = insertShipmentDocumentUseCase,
        super(ShipInitial());

  final CreateShipmentReportUseCase _createShipmentReportUseCase;
  final DeleteShipmentUseCase _deleteShipmentUseCase;
  final DownloadShipmentReportUseCase _downloadShipmentReportUseCase;
  final FetchShipmentByIdUseCase _fetchShipmentByIdUseCase;
  final FetchShipmentByReceiptNumberUseCase
      _fetchShipmentByReceiptNumberUseCase;
  final FetchShipmentReportsUseCase _fetchShipmentReportsUseCase;
  final FetchShipmentsUseCase _fetchShipmentsUseCase;
  final InsertShipmentUseCase _insertShipmentUseCase;
  final InsertShipmentDocumentUseCase _insertShipmentDocumentUseCase;

  var _currentPage = 1;
  final _shipments = <ShipmentEntity>[];
  final _shipmentReports = <ShipmentReportEntity>[];

  Future<void> createShipmentReport(
      {required DateTime startDate, required DateTime endDate}) async {
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

  Future<void> deleteShipment({required String shipmentId}) async {
    emit(DeleteShipmentLoading());

    final params = DeleteShipmentUseCaseParams(shipmentId: shipmentId);
    final result = await _deleteShipmentUseCase(params);

    result.fold(
      (failure) => emit(DeleteShipmentError(message: failure.message)),
      (message) => emit(DeleteShipmentLoaded(message: message)),
    );
  }

  Future<void> downloadShipmentReport(
      {required ShipmentReportEntity shipmentReportEntity}) async {
    emit(DownloadShipmentReportLoading(
        shipmentReportId: shipmentReportEntity.id));

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

  Future<void> fetchShipmentById({required String shipmentId}) async {
    emit(FetchShipmentDetailLoading());

    final params = FetchShipmentByIdUseCaseParams(shipmentId: shipmentId);
    final result = await _fetchShipmentByIdUseCase(params);

    result.fold(
      (failure) => emit(FetchShipmentDetailError(message: failure.message)),
      (shipmentDetail) =>
          emit(FetchShipmentDetailLoaded(shipmentDetail: shipmentDetail)),
    );
  }

  Future<void> fetchShipmentByReceiptNumber(
      {required String receiptNumber}) async {
    emit(FetchReceiptStatusLoading());

    final params =
        FetchShipmentByReceiptNumberUseCaseParams(receiptNumber: receiptNumber);
    final result = await _fetchShipmentByReceiptNumberUseCase(params);

    result.fold(
      (failure) => emit(FetchReceiptStatusError(failure: failure)),
      (shipmentHistory) =>
          emit(FetchReceiptStatusLoaded(shipmentHistory: shipmentHistory)),
    );
  }

  Future<void> fetchShipmentReports(
      {required DateTime startDate,
      required DateTime endDate,
      required String status}) async {
    emit(FetchShipmentReportsLoading());

    final params = FetchShipmentReportsUseCaseParams(
      startDate: startDate,
      endDate: endDate,
      status: status,
      page: _currentPage = 1,
    );
    final result = await _fetchShipmentReportsUseCase(params);

    result.fold(
      (failure) => emit(FetchShipmentReportsError(message: failure.message)),
      (shipmentReports) => emit(FetchShipmentReportsLoaded(
          shipmentReports: _shipmentReports
            ..clear()
            ..addAll(shipmentReports))),
    );
  }

  Future<void> fetchShipmentReportsPaginate(
      {required DateTime startDate,
      required DateTime endDate,
      required String status}) async {
    emit(ListPaginateLoading());

    final params = FetchShipmentReportsUseCaseParams(
      startDate: startDate,
      endDate: endDate,
      status: status,
      page: ++_currentPage,
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
          emit(FetchShipmentReportsLoaded(
              shipmentReports: _shipmentReports..addAll(shipmentReports)));
        }
      },
    );
  }

  Future<void> fetchShipments(
      {required DateTime date, required String stage, String? keyword}) async {
    emit(FetchShipmentsLoading());

    final params = FetchShipmentsUseCaseParams(
      date: date,
      stage: stage,
      keyword: keyword,
      page: _currentPage = 1,
    );
    final result = await _fetchShipmentsUseCase(params);

    result.fold(
      (failure) => emit(FetchShipmentsError(message: failure.message)),
      (shipments) => emit(FetchShipmentsLoaded(
          shipments: _shipments
            ..clear()
            ..addAll(shipments))),
    );
  }

  Future<void> fetchShipmentsPaginate(
      {required DateTime date, required String stage, String? keyword}) async {
    emit(ListPaginateLoading());

    final params = FetchShipmentsUseCaseParams(
        date: date, stage: stage, keyword: keyword, page: ++_currentPage);
    final result = await _fetchShipmentsUseCase(params);

    result.fold(
      (failure) => emit(FetchShipmentsError(message: failure.message)),
      (shipments) {
        if (shipments.isEmpty) {
          _currentPage = 1;
          emit(ListPaginateLast());
        } else {
          emit(ListPaginateLoaded());
          emit(FetchShipmentsLoaded(shipments: _shipments..addAll(shipments)));
        }
      },
    );
  }

  Future<void> insertShipment(
      {required String receiptNumber, required String stage}) async {
    emit(InsertShipmentLoading());

    final params =
        InsertShipmentUseCaseParams(receiptNumber: receiptNumber, stage: stage);

    final result = await _insertShipmentUseCase(params);

    result.fold(
      (failure) => emit(InsertShipmentError(failure: failure)),
      (message) => emit(InsertShipmentLoaded(message: message)),
    );
  }

  Future<void> insertShipmentDocument(
      {required String shipmentId,
      required String documentPath,
      required String stage}) async {
    emit(InsertShipmentDocumentLoading());

    final params = InsertShipmentDocumentUseCaseParams(
        shipmentId: shipmentId, documentPath: documentPath, stage: stage);

    final result = await _insertShipmentDocumentUseCase(params);

    result.fold(
      (failure) => emit(InsertShipmentDocumentError(message: failure.message)),
      (message) => emit(InsertShipmentDocumentLoaded(message: message)),
    );
  }
}
