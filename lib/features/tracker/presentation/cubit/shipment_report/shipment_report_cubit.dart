import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../../common/constants/app_constants.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/services/file_interaction_service.dart';
import '../../../../../core/services/file_service.dart';
import '../../../../../core/usecase/use_case.dart';
import '../../../data/models/shipment_report_ui_model.dart';
import '../../../domain/entities/shipment_report_entity.dart';
import '../../../domain/usecases/check_shipment_report_existence_use_case.dart';
import '../../../domain/usecases/download_shipment_report_use_case.dart';
import '../../../domain/usecases/fetch_shipment_reports_use_case.dart';

part 'shipment_report_state.dart';

class ShipmentReportCubit extends Cubit<ShipmentReportState> {
  ShipmentReportCubit({
    required DownloadShipmentReportUseCase downloadShipmentReportUseCase,
    required CheckShipmentReportExistenceUseCase
    checkShipmentReportExistenceUseCase,
    required FetchShipmentReportsUseCase fetchShipmentReportsUseCase,
    required FileInteractionService fileInteractionService,
    required FileService fileService,
  }) : _downloadShipmentReportUseCase = downloadShipmentReportUseCase,
       _checkShipmentReportExistenceUseCase =
           checkShipmentReportExistenceUseCase,
       _fetchShipmentReportsUseCase = fetchShipmentReportsUseCase,
       _fileInteractionService = fileInteractionService,
       _fileService = fileService,
       super(const ShipmentReportState());

  final DownloadShipmentReportUseCase _downloadShipmentReportUseCase;
  final CheckShipmentReportExistenceUseCase
  _checkShipmentReportExistenceUseCase;
  final FetchShipmentReportsUseCase _fetchShipmentReportsUseCase;
  final FileInteractionService _fileInteractionService;
  final FileService _fileService;

  Future<void> downloadShipmentReport({
    required ShipmentReportEntity report,
  }) async {
    emit(state.copyWith(downloadingReportId: report.id));

    final params = DownloadShipmentReportUseCaseParams(
      fileUrl: report.file,
      savedFilename: report.savedFilename,
    );
    final result = await _downloadShipmentReportUseCase(params);

    result.fold(
      (failure) =>
          emit(state.copyWith(failure: failure, downloadingReportId: '-1')),
      (message) => emit(
        state.copyWith(
          message: message,
          reports: state.reports
              .map(
                (reportUi) => reportUi.entity.id == report.id
                    ? reportUi.copyWith(isDownloaded: true)
                    : reportUi,
              )
              .toList(),
          downloadingReportId: '1',
        ),
      ),
    );
  }

  Future<void> fetchShipmentReports({
    DateTimeRange? dateTimeRange,
    String? status,
  }) async {
    final effectiveDateTimeRange =
        dateTimeRange ??
        state.dateTimeRange ??
        DateTimeRange(start: DateTime.now(), end: DateTime.now());
    final effectiveStatus = status ?? state.filterStatus;

    emit(
      state.copyWith(
        status: .inProgress,
        dateTimeRange: effectiveDateTimeRange,
        filterStatus: effectiveStatus,
        currentPage: 1,
        hasReachedMax: false,
        isPaginating: false,
      ),
    );

    final params = FetchShipmentReportsUseCaseParams(
      startDate: effectiveDateTimeRange.start,
      endDate: effectiveDateTimeRange.end,
      status: effectiveStatus,
    );
    final result = await _fetchShipmentReportsUseCase(params);

    result.fold(
      (failure) => emit(state.copyWith(status: .failure, failure: failure)),
      (reports) async {
        final uiModels = await _mapReportsToUiModels(reports);

        emit(
          state.copyWith(
            status: .success,
            reports: uiModels,
            hasReachedMax: reports.isEmpty,
          ),
        );
      },
    );
  }

  Future<void> fetchShipmentReportsPaginate() async {
    if (state.hasReachedMax || state.isPaginating) return;

    emit(state.copyWith(isPaginating: true));

    final params = FetchShipmentReportsUseCaseParams(
      startDate: state.dateTimeRange!.start,
      endDate: state.dateTimeRange!.end,
      status: state.filterStatus,
      paginate: PaginateParams(page: state.currentPage + 1),
    );
    final result = await _fetchShipmentReportsUseCase(params);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: .failure,
          hasReachedMax: true,
          isPaginating: false,
          failure: failure,
        ),
      ),
      (reports) async {
        if (reports.isEmpty) {
          return emit(state.copyWith(hasReachedMax: true, isPaginating: false));
        }

        final uiModels = await _mapReportsToUiModels(reports);

        emit(
          state.copyWith(
            status: .success,
            reports: [...state.reports, ...uiModels],
            currentPage: state.currentPage + 1,
            isPaginating: false,
          ),
        );
      },
    );
  }

  Future<void> openReport(String filename) async {
    await _fileInteractionService.openFile(
      await _fileService.getFullPath(filename),
    );
  }

  Future<void> shareReport(List<String> filenames) async {
    final paths = await Future.wait(filenames.map(_fileService.getFullPath));
    await _fileInteractionService.shareFiles(paths);
  }

  set dateTimeRange(DateTimeRange? dateTimeRange) =>
      emit(state.copyWith(dateTimeRange: dateTimeRange));

  set filterStatus(String filterStatus) =>
      emit(state.copyWith(filterStatus: filterStatus));

  Future<List<ShipmentReportUiModel>> _mapReportsToUiModels(
    List<ShipmentReportEntity> reports,
  ) async {
    return Future.wait(
      reports.map((e) async {
        final checkParams = CheckShipmentReportExistenceUseCaseParams(
          filename: e.savedFilename,
        );
        final isExists = await _checkShipmentReportExistenceUseCase(
          checkParams,
        );

        return ShipmentReportUiModel(
          entity: e,
          isDownloaded: isExists.getOrElse(() => false),
        );
      }),
    );
  }
}
