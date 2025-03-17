import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/exceptions/refresh_token.dart';
import '../../../../core/failure/failure.dart';
import '../../../../service_container.dart';
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
  ShipmentCubit(
      {required CreateShipmentReportUseCase createShipmentReportUseCase,
      required DeleteShipmentUseCase deleteShipmentUseCase,
      required FetchShipmentByIdUseCase fetchShipmentByIdUseCase,
      required FetchShipmentByReceiptNumberUseCase
          fetchShipmentByReceiptNumberUseCase,
      required FetchShipmentReportsUseCase fetchShipmentReportsUseCase,
      required FetchShipmentsUseCase fetchShipmentsUseCase,
      required InsertShipmentDocumentUseCase insertShipmentDocumentUseCase,
      required InsertShipmentUseCase insertShipmentUseCase,
      required DownloadShipmentReportUseCase downloadShipmentReportUseCase})
      : _createShipmentReportUseCase = createShipmentReportUseCase,
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
  late String externalPath;
  final shipments = <ShipmentEntity>[];
  var _fetchShipmentsPage = 1;
  var isEndPage = false;

  Future<void> getExternalPath() async {
    final dir = await getExternalStorageDirectory();
    externalPath = '${dir?.path}';
  }

  Future<void> fetchShipmentByReceiptNumber(
      {required String receipNumber}) async {
    emit(FetchReceiptStatusLoading());
    final refreshToken =
        await getIt.get<FlutterSecureStorage>().read(key: refreshTokenKey);
    final result = await _fetchShipmentByReceiptNumberUseCase(receipNumber);

    result.fold(
      (l) {
        if (l is RefreshToken && refreshToken != null) {
          fetchShipmentByReceiptNumber(receipNumber: receipNumber);
        } else {
          emit(FetchReceiptStatusError(message: l.message));
        }
      },
      (r) => emit(FetchReceiptStatusLoaded(shipmentDetail: r)),
    );
  }

  Future<void> fetchShipments(
      {required String date, required String stage, String? keyword}) async {
    shipments.clear();
    isEndPage = false;
    _fetchShipmentsPage = 1;
    emit(FetchShipmentsLoading());
    final params =
        FetchShipmentsParams(date: date, stage: stage, keyword: keyword);
    final refreshToken =
        await getIt.get<FlutterSecureStorage>().read(key: refreshTokenKey);
    final result = await _fetchShipmentsUseCase(params);

    result.fold(
      (l) {
        if (l is RefreshToken && refreshToken != null) {
          fetchShipments(date: date, stage: stage, keyword: keyword);
        } else {
          emit(FetchShipmentsError(message: l.message));
        }
      },
      (r) {
        shipments.addAll(r['shipments']);
        if (_fetchShipmentsPage < r['totalPage']) {
          _fetchShipmentsPage++;
        } else {
          isEndPage = true;
        }
        emit(FetchShipmentsLoaded(shipments: shipments));
      },
    );
  }

  Future<void> fetchShipmentsPaginate(
      {required String date, required String stage}) async {
    final params = FetchShipmentsParams(
        date: date, stage: stage, page: _fetchShipmentsPage);
    final refreshToken =
        await getIt.get<FlutterSecureStorage>().read(key: refreshTokenKey);
    final result = await _fetchShipmentsUseCase(params);

    result.fold(
      (l) {
        if (l is RefreshToken && refreshToken != null) {
          fetchShipmentsPaginate(date: date, stage: stage);
        } else {
          emit(FetchShipmentsError(message: l.message));
        }
      },
      (r) {
        if (_fetchShipmentsPage < r['totalPage']) {
          isEndPage = false;
          _fetchShipmentsPage++;
          shipments.addAll(r['shipments']);
        } else {
          isEndPage = true;
        }
        emit(FetchShipmentsLoaded(shipments: shipments));
      },
    );
  }

  Future<void> searchShipments(
      {required String date, required String stage, String? keyword}) async {
    emit(FetchShipmentsLoading());
    final params =
        FetchShipmentsParams(date: date, stage: stage, keyword: keyword);
    final refreshToken =
        await getIt.get<FlutterSecureStorage>().read(key: refreshTokenKey);
    final result = await _fetchShipmentsUseCase(params);

    result.fold(
      (l) {
        if (l is RefreshToken && refreshToken != null) {
          searchShipments(date: date, stage: stage, keyword: keyword);
        } else {
          emit(FetchShipmentsError(message: l.message));
        }
      },
      (r) => emit(SearchShipmentsLoaded(shipments: r['shipments'])),
    );
  }

  Future<void> insertShipment(
      {required String receiptNumber, required String stage}) async {
    emit(InsertShipmentLoading());
    final params =
        InsertShipmentParams(receiptNumber: receiptNumber, stage: stage);
    final refreshToken =
        await getIt.get<FlutterSecureStorage>().read(key: refreshTokenKey);
    final result = await _insertShipmentUseCase(params);

    result.fold(
      (l) {
        if (l is RefreshToken && refreshToken != null) {
          insertShipment(receiptNumber: receiptNumber, stage: stage);
        } else {
          emit(InsertShipmentError(failure: l));
        }
      },
      (r) => emit(InsertShipmentLoaded(message: r)),
    );
  }

  Future<void> fetchShipmentById({required String shipmentId}) async {
    emit(FetchShipmentDetailLoading());
    final refreshToken =
        await getIt.get<FlutterSecureStorage>().read(key: refreshTokenKey);
    final result = await _fetchShipmentByIdUseCase(shipmentId);

    result.fold(
      (l) {
        if (l is RefreshToken && refreshToken != null) {
          fetchShipmentById(shipmentId: shipmentId);
        } else {
          emit(FetchShipmentDetailError(message: l.message));
        }
      },
      (r) => emit(FetchShipmentDetailLoaded(shipmentDetail: r)),
    );
  }

  Future<void> insertShipmentDocument(
      {required String shipmentId,
      required XFile image,
      required String stage}) async {
    emit(InsertShipmentDocumentLoading());
    final params = InsertShipmentDocumentParams(
        shipmentId: shipmentId, document: image, stage: stage);
    final refreshToken =
        await getIt.get<FlutterSecureStorage>().read(key: refreshTokenKey);
    final result = await _insertShipmentDocumentUseCase(params);

    result.fold(
      (l) {
        if (l is RefreshToken && refreshToken != null) {
          insertShipmentDocument(
              shipmentId: shipmentId, image: image, stage: stage);
        } else {
          emit(InsertShipmentDocumentError(message: l.message));
        }
      },
      (r) => emit(InsertShipmentDocumentLoaded(message: r)),
    );
  }

  Future<void> deleteShipment({required String shipmentId}) async {
    emit(DeleteShipmentLoading());
    final refreshToken =
        await getIt.get<FlutterSecureStorage>().read(key: refreshTokenKey);
    final result = await _deleteShipmentUseCase(shipmentId);

    result.fold(
      (l) {
        if (l is RefreshToken && refreshToken != null) {
          deleteShipment(shipmentId: shipmentId);
        } else {
          emit(DeleteShipmentError(message: l.message));
        }
      },
      (r) => emit(DeleteShipmentLoaded(message: r)),
    );
  }

  Future<void> fetchShipmentReports(
      {required String startDate,
      required String endDate,
      required String status}) async {
    emit(FetchShipmentReportsLoading());
    final params = FetchShipmentReportsParams(
        startDate: startDate, endDate: endDate, status: status);
    final refreshToken =
        await getIt.get<FlutterSecureStorage>().read(key: refreshTokenKey);
    final result = await _fetchShipmentReportsUseCase(params);

    result.fold(
      (l) {
        if (l is RefreshToken && refreshToken != null) {
          fetchShipmentReports(
              startDate: startDate, endDate: endDate, status: status);
        } else {
          emit(FetchShipmentReportsError(message: l.message));
        }
      },
      (r) => emit(FetchShipmentReportsLoaded(shipmentReports: r)),
    );
  }

  Future<void> createShipmentReport(
      {required String startDate, required String endDate}) async {
    emit(CreateShipmentReportLoading());
    final params =
        CreateShipmentReportParams(startDate: startDate, endDate: endDate);
    final refreshToken =
        await getIt.get<FlutterSecureStorage>().read(key: refreshTokenKey);
    final result = await _createShipmentReportUseCase(params);

    result.fold(
      (l) {
        if (l is RefreshToken && refreshToken != null) {
          createShipmentReport(startDate: startDate, endDate: endDate);
        } else {
          emit(CreateShipmentReportError(message: l.message));
        }
      },
      (r) => emit(CreateShipmentReportLoaded(message: r)),
    );
  }

  Future<void> downloadShipmentReport(
      {required ShipmentReportEntity shipmentReportEntity}) async {
    emit(DownloadShipmentReportLoading());
    final refreshToken =
        await getIt.get<FlutterSecureStorage>().read(key: refreshTokenKey);
    final result = await _downloadShipmentReportUseCase(shipmentReportEntity);

    result.fold(
      (l) {
        if (l is RefreshToken && refreshToken != null) {
          downloadShipmentReport(shipmentReportEntity: shipmentReportEntity);
        }
        emit(DownloadShipmentReportError(message: l.message));
      },
      (r) => emit(DownloadShipmentReportLoaded(message: r)),
    );
  }
}
