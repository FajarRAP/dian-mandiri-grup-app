import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/usecase/use_case.dart';
import '../../../data/models/shipment_report_ui_model.dart';
import '../../../domain/entities/shipment_report_entity.dart';
import '../../../domain/usecases/check_shipment_report_existence_use_case.dart';
import '../../../domain/usecases/create_shipment_report_use_case.dart';
import '../../../domain/usecases/download_shipment_report_use_case.dart';
import '../../../domain/usecases/fetch_shipment_reports_use_case.dart';

part 'shipment_report_state.dart';

class ShipmentReportCubit extends Cubit<ShipmentReportState> {
  ShipmentReportCubit({
    required CreateShipmentReportUseCase createShipmentReportUseCase,
    required DownloadShipmentReportUseCase downloadShipmentReportUseCase,
    required CheckShipmentReportExistenceUseCase
    checkShipmentReportExistenceUseCase,
    required FetchShipmentReportsUseCase fetchShipmentReportsUseCase,
  }) : _createShipmentReportUseCase = createShipmentReportUseCase,
       _downloadShipmentReportUseCase = downloadShipmentReportUseCase,
       _checkShipmentReportExistenceUseCase =
           checkShipmentReportExistenceUseCase,
       _fetchShipmentReportsUseCase = fetchShipmentReportsUseCase,
       super(ShipmentReportState.initial());

  final CreateShipmentReportUseCase _createShipmentReportUseCase;
  final DownloadShipmentReportUseCase _downloadShipmentReportUseCase;
  final CheckShipmentReportExistenceUseCase
  _checkShipmentReportExistenceUseCase;
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
    required ShipmentReportEntity report,
  }) async {
    emit(state.copyWith(downloadingReportId: report.id));

    final params = DownloadShipmentReportUseCaseParams(
      fileUrl: report.file,
      savedFilename: report.savedFilename,
    );
    final result = await _downloadShipmentReportUseCase(params);

    result.fold(
      (failure) => emit(
        state.copyWith(
          failure: failure,
          message: failure.message,
          downloadingReportId: null,
        ),
      ),
      (message) {
        emit(
          state.copyWith(
            failure: null,
            message: message,
            reports: state.reports
                .map(
                  (reportUi) => reportUi.entity.id == report.id
                      ? reportUi.copyWith(isDownloaded: true)
                      : reportUi,
                )
                .toList(),
            downloadingReportId: null,
          ),
        );
      },
    );
  }

  Future<void> fetchShipmentReports({
    required DateTime startDate,
    required DateTime endDate,
    required String status,
  }) async {
    emit(state.copyWith(status: .inProgress, actionStatus: .initial));

    final params = FetchShipmentReportsUseCaseParams(
      startDate: startDate,
      endDate: endDate,
      status: status,
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
            currentPage: 1,
            hasReachedMax: reports.isEmpty,
            isPaginating: false,
          ),
        );
      },
    );
  }

  Future<void> fetchShipmentReportsPaginate({
    required DateTime startDate,
    required DateTime endDate,
    required String status,
  }) async {
    if (state.hasReachedMax || state.isPaginating) return;

    emit(state.copyWith(isPaginating: true));

    final params = FetchShipmentReportsUseCaseParams(
      startDate: startDate,
      endDate: endDate,
      status: status,
      paginate: PaginateParams(page: state.currentPage + 1),
    );
    final result = await _fetchShipmentReportsUseCase(params);

    result.fold(
      (failure) => emit(
        state.copyWith(status: .failure, failure: failure, isPaginating: false),
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
