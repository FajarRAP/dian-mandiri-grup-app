import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../../../core/failure/failure.dart';
import '../../domain/entities/shipment_detail_entity.dart';
import '../../domain/entities/shipment_entity.dart';
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
    required FetchShipmentByIdUseCase fetchShipmentByIdUseCase,
    required FetchShipmentByReceiptNumberUseCase
        fetchShipmentByReceiptNumberUseCase,
    required FetchShipmentReportsUseCase fetchShipmentReportsUseCase,
    required FetchShipmentsUseCase fetchShipmentsUseCase,
    required InsertShipmentDocumentUseCase insertShipmentDocumentUseCase,
    required InsertShipmentUseCase insertShipmentUseCase,
    required DownloadShipmentReportUseCase downloadShipmentReportUseCase,
  })  : _createShipmentReportUseCase = createShipmentReportUseCase,
        _deleteShipmentUseCase = deleteShipmentUseCase,
        _fetchShipmentByIdUseCase = fetchShipmentByIdUseCase,
        _fetchShipmentByReceiptNumberUseCase =
            fetchShipmentByReceiptNumberUseCase,
        _fetchShipmentReportsUseCase = fetchShipmentReportsUseCase,
        _fetchShipmentsUseCase = fetchShipmentsUseCase,
        _insertShipmentDocumentUseCase = insertShipmentDocumentUseCase,
        _insertShipmentUseCase = insertShipmentUseCase,
        _downloadShipmentReportUseCase = downloadShipmentReportUseCase,
        super(ShipInitial());

  final CreateShipmentReportUseCase _createShipmentReportUseCase;
  final DeleteShipmentUseCase _deleteShipmentUseCase;
  final FetchShipmentByIdUseCase _fetchShipmentByIdUseCase;
  final FetchShipmentByReceiptNumberUseCase
      _fetchShipmentByReceiptNumberUseCase;
  final FetchShipmentReportsUseCase _fetchShipmentReportsUseCase;
  final FetchShipmentsUseCase _fetchShipmentsUseCase;
  final InsertShipmentDocumentUseCase _insertShipmentDocumentUseCase;
  final InsertShipmentUseCase _insertShipmentUseCase;
  final DownloadShipmentReportUseCase _downloadShipmentReportUseCase;

  late ShipmentDetailEntity shipmentDetail;
  var _currentPage = 1;
  final _shipments = <ShipmentEntity>[];

  Future<void> createShipmentReport(
      {required String startDate, required String endDate}) async {
    emit(CreateShipmentReportLoading());

    final params =
        CreateShipmentReportParams(startDate: startDate, endDate: endDate);
    final result = await _createShipmentReportUseCase(params);

    result.fold(
      (l) => emit(CreateShipmentReportError(message: l.message)),
      (r) => emit(CreateShipmentReportLoaded(message: r)),
    );
  }

  Future<void> deleteShipment({required String shipmentId}) async {
    emit(DeleteShipmentLoading());

    final result = await _deleteShipmentUseCase(shipmentId);

    result.fold(
      (l) => emit(DeleteShipmentError(message: l.message)),
      (r) => emit(DeleteShipmentLoaded(message: r)),
    );
  }

  Future<void> downloadShipmentReport(
      {required ShipmentReportEntity shipmentReportEntity}) async {
    emit(DownloadShipmentReportLoading());

    final result = await _downloadShipmentReportUseCase(shipmentReportEntity);

    result.fold(
      (l) => emit(DownloadShipmentReportError(message: l.message)),
      (r) => emit(DownloadShipmentReportLoaded(message: r)),
    );
  }

  Future<void> fetchShipmentById({required String shipmentId}) async {
    emit(FetchShipmentDetailLoading());

    final result = await _fetchShipmentByIdUseCase(shipmentId);

    result.fold(
      (l) => emit(FetchShipmentDetailError(message: l.message)),
      (r) => emit(FetchShipmentDetailLoaded(shipmentDetail: r)),
    );
  }

  Future<void> fetchShipmentByReceiptNumber(
      {required String receiptNumber}) async {
    emit(FetchReceiptStatusLoading());

    final result = await _fetchShipmentByReceiptNumberUseCase(receiptNumber);

    result.fold(
      (l) => emit(FetchReceiptStatusError(failure: l)),
      (r) => emit(FetchReceiptStatusLoaded(shipmentDetail: r)),
    );
  }

  Future<void> fetchShipmentReports(
      {required String startDate,
      required String endDate,
      required String status}) async {
    emit(FetchShipmentReportsLoading());

    final params = FetchShipmentReportsParams(
        startDate: startDate, endDate: endDate, status: status);
    final result = await _fetchShipmentReportsUseCase(params);

    result.fold(
      (l) => emit(FetchShipmentReportsError(message: l.message)),
      (r) => emit(FetchShipmentReportsLoaded(shipmentReports: r)),
    );
  }

  Future<void> fetchShipments(
      {required String date, required String stage, String? keyword}) async {
    _currentPage = 1;

    emit(FetchShipmentsLoading());

    final params =
        FetchShipmentsParams(date: date, stage: stage, keyword: keyword);
    final result = await _fetchShipmentsUseCase(params);

    result.fold(
      (l) => emit(FetchShipmentsError(message: l.message)),
      (r) {
        _shipments
          ..clear()
          ..addAll(r);
        emit(FetchShipmentsLoaded(shipments: _shipments));
      },
    );
  }

  Future<void> fetchShipmentsPaginate(
      {required String date, required String stage, String? keyword}) async {
    emit(ListPaginateLoading());

    final params = FetchShipmentsParams(
        date: date, stage: stage, keyword: keyword, page: ++_currentPage);
    final result = await _fetchShipmentsUseCase(params);

    result.fold(
      (l) => emit(FetchShipmentsError(message: l.message)),
      (r) {
        if (r.isEmpty) {
          _currentPage = 1;
          emit(ListPaginateLast());
        } else {
          _shipments.addAll(r);
          emit(ListPaginateLoaded());
          emit(FetchShipmentsLoaded(shipments: _shipments));
        }
      },
    );
  }

  Future<void> insertShipment(
      {required String receiptNumber, required String stage}) async {
    emit(InsertShipmentLoading());

    final params =
        InsertShipmentParams(receiptNumber: receiptNumber, stage: stage);

    final result = await _insertShipmentUseCase(params);

    result.fold(
      (l) => emit(InsertShipmentError(failure: l)),
      (r) => emit(InsertShipmentLoaded(message: r)),
    );
  }

  Future<void> insertShipmentDocument(
      {required String shipmentId,
      required String documentPath,
      required String stage}) async {
    emit(InsertShipmentDocumentLoading());

    final params = InsertShipmentDocumentParams(
        shipmentId: shipmentId, documentPath: documentPath, stage: stage);

    final result = await _insertShipmentDocumentUseCase(params);

    result.fold(
      (l) => emit(InsertShipmentDocumentError(message: l.message)),
      (r) => emit(InsertShipmentDocumentLoaded(message: r)),
    );
  }
}
