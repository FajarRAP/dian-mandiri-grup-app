import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/usecase/use_case.dart';
import '../../../domain/usecases/create_shipment_report_use_case.dart';

part 'create_shipment_report_state.dart';

class CreateShipmentReportCubit extends Cubit<CreateShipmentReportState> {
  CreateShipmentReportCubit({
    required CreateShipmentReportUseCase createShipmentReportUseCase,
  }) : _createShipmentReportUseCase = createShipmentReportUseCase,
       super(const CreateShipmentReportState());

  final CreateShipmentReportUseCase _createShipmentReportUseCase;

  Future<void> createShipmentReport({DateTimeRange? dateTimeRange}) async {
    emit(state.copyWith(status: .inProgress, dateTimeRange: dateTimeRange));

    final params = CreateShipmentReportUseCaseParams(
      startDate: state.dateTimeRange!.start,
      endDate: state.dateTimeRange!.end,
    );
    final result = await _createShipmentReportUseCase(params);

    result.fold(
      (failure) => emit(state.copyWith(status: .failure, failure: failure)),
      (message) => emit(state.copyWith(status: .success, message: message)),
    );
  }

  set dateTimeRange(DateTimeRange? dateTimeRange) =>
      emit(state.copyWith(dateTimeRange: dateTimeRange));
}
