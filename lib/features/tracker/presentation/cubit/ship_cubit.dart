import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:ship_tracker/features/tracker/domain/usecases/get_receipt_status_use_case.dart';

import '../../domain/entities/ship_entity.dart';
import '../../domain/usecases/create_report_use_case.dart';
import '../../domain/usecases/delete_ship_use_case.dart';
import '../../domain/usecases/get_all_spreadsheet_files_use_case.dart';
import '../../domain/usecases/get_image_url_use_case.dart';
import '../../domain/usecases/get_ships_use_case.dart';
import '../../domain/usecases/insert_ship_use_case.dart';
import '../../domain/usecases/upload_image_use_case.dart';

part 'ship_state.dart';

class ShipCubit extends Cubit<ShipState> {
  ShipCubit({
    required this.getShipsUseCase,
    required this.insertShipUseCase,
    required this.deleteShipUseCase,
    required this.createReportUseCase,
    required this.getAllSpreadsheetFilesUseCase,
    required this.getImageUrlUseCase,
    required this.uploadImageUseCase,
    required this.getReceiptStatusUseCase,
    required this.camera,
  }) : super(ShipInitial());

  final GetShipsUseCase getShipsUseCase;
  final InsertShipUseCase insertShipUseCase;
  final DeleteShipUseCase deleteShipUseCase;
  final CreateReportUseCase createReportUseCase;
  final GetAllSpreadsheetFilesUseCase getAllSpreadsheetFilesUseCase;
  final GetImageUrlUseCase getImageUrlUseCase;
  final UploadImageUseCase uploadImageUseCase;
  final GetReceiptStatusUseCase getReceiptStatusUseCase;
  final CameraDescription camera;

  late ShipEntity ship;
  late String picturePath;
  List<String> shortFilename = [];
  List<ShipEntity> ships = [];

  void filterShips(String value) {
    final data = ships.where((e) => e.receipt.contains(value)).toList();
    data.isEmpty ? emit(ShipEmpty()) : emit(ShipLoaded(data));
  }

  Future<void> getShips(int stageId, DateTime date) async {
    emit(ShipLoading());

    final result = await getShipsUseCase(stageId, date);

    result.fold(
      (l) => emit(ShipError(l.message)),
      (r) {
        if (r.isEmpty) {
          ships.clear();
          emit(ShipEmpty());
        } else {
          ships = r;
          emit(ShipLoaded(ships));
        }
      },
    );
  }

  Future<void> insertShip(
      String receiptNumber, String name, int stageId) async {
    emit(InsertShipLoading());

    final result = await insertShipUseCase(receiptNumber, name, stageId);

    result.fold(
      (l) => emit(InsertShipError(l.statusCode, l.message)),
      (r) => emit(InsertShipFinished(r)),
    );
  }

  Future<void> createReport(DateTime date) async {
    emit(ReportLoading());

    final result = await createReportUseCase(date);

    result.fold(
      (l) => emit(ReportError(l.message)),
      (r) => emit(CreateReport(r)),
    );
  }

  Future<void> getAllSpreadsheetFiles() async {
    emit(ReportLoading());

    final result = await getAllSpreadsheetFilesUseCase();

    result.fold(
      (l) => emit(ReportError(l.message)),
      (r) {
        shortFilename =
            r.map((e) => e.split(RegExp(r'.*files/')).last).toList();
        emit(AllReport(r));
      },
    );
  }

  void getImageUrl() {
    final result = getImageUrlUseCase('${ship.receipt}-${ship.stage}');

    result.fold(
      (l) => emit(ImageError(l.message)),
      (r) => emit(ImageLoaded(r)),
    );
  }

  Future<void> uploadImage(String toPath, File file) async {
    emit(ImageUploading());

    final result = await uploadImageUseCase(toPath, file);

    result.fold(
      (l) => emit(UploadImageError(l.message)),
      (r) => emit(ImageUploaded(r)),
    );
  }

  Future<void> deleteShip(int shipId) async {
    emit(DeleteShipLoading());
    final result = await deleteShipUseCase(shipId);

    result.fold(
      (l) => emit(DeleteShipError(l.message)),
      (r) => emit(DeleteShipSuccess('Berhasil menghapus resi')),
    );
  }

  Future<void> getReceiptStatus(String receiptNumber) async {
    emit(CheckReceiptStatusLoading());

    final result = await getReceiptStatusUseCase(receiptNumber);

    result.fold(
      (l) => emit(CheckReceiptStatusError(l.message)),
      (r) => emit(CheckReceiptStatusLoaded(r)),
    );
  }
}
