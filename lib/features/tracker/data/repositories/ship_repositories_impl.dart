import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ship_tracker/features/tracker/data/models/ship_from_ships_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

import '../../../../core/common/constants.dart';
import '../../../../core/exceptions/network_exception.dart';
import '../../../../core/exceptions/receipt_exception.dart';
import '../../../../core/failure/failure.dart';
import '../../../../core/helpers/is_internet_connected.dart';
import '../../../../service_container.dart';
import '../../domain/entities/ship_entity.dart';
import '../../domain/repositories/ship_repositories.dart';
import '../datasources/ship_local_data_source.dart';
import '../datasources/ship_remote_data_source.dart';
import '../models/ship_from_ships_detail_model.dart';

class ShipRepositoriesImpl extends ShipRepositories {
  final ShipRemoteDataSource shipRemote;
  final ShipLocalDataSource shipLocal;

  ShipRepositoriesImpl({
    required this.shipRemote,
    required this.shipLocal,
  });

  @override
  Future<Either<Failure, List<ShipEntity>>> getShips(
      int stageId, DateTime date) async {
    try {
      if (!await isInternetConnected()) throw NetworkException();

      final datas = await shipRemote.getShipsByStageId(stageId, date);

      return Right(
          datas.map((e) => ShipFromShipsDetailModel.fromJson(e)).toList());
    } on NetworkException catch (ne) {
      return Left(Failure(message: ne.message));
    } catch (e) {
      return Left(Failure());
    }
  }

  @override
  Future<Either<Failure, String>> insertShip(
      String receiptNumber, String name, int stageId) async {
    try {
      if (!await isInternetConnected()) throw NetworkException();

      final currentUserId = getIt.get<SupabaseClient>().auth.currentUser?.id;

      if (currentUserId == null) {
        throw ReceiptException(
            statusCode: 403, message: 'Pengguna harus login');
      }

      if (stageId > scanStage) {
        final datas = await shipRemote.getShipsByReceiptNumber(receiptNumber);

        if (datas.isEmpty) {
          throw ReceiptException(
              statusCode: 400, message: 'Nomor resi belum di scan sama sekali');
        }

        final data = datas.first;
        final String remoteStageName =
            data['stage_id']['name'].toString().toLowerCase();
        final int shipId = data['id'];

        if (data['stage_id']['id'] == stageId) {
          throw ReceiptException(
              statusCode: 401, message: 'Nomor resi sudah di $remoteStageName');
        }

        if (data['stage_id']['id'] > stageId) {
          throw ReceiptException(
              statusCode: 400,
              message: 'Ga bisa mundur, udah nyampe $remoteStageName');
        }

        if (data['stage_id']['id'] < stageId - 1) {
          throw ReceiptException(
              statusCode: 400,
              message:
                  'Jangan loncat, resi ini baru sampai tahap $remoteStageName');
        }

        await shipRemote.insertShip(
            currentUserId, receiptNumber, name, stageId, shipId);
      } else {
        await shipRemote.insertShip(
            currentUserId, receiptNumber, name, stageId, -1);
      }

      return const Right('Berhasil Menyimpan');
    } on PostgrestException catch (pe) {
      switch (pe.code) {
        case '23505':
          return Left(
              Failure(statusCode: 23505, message: 'Nomor resi sudah di scan'));
        default:
          return Left(Failure());
      }
    } on NetworkException catch (ne) {
      return Left(Failure(message: ne.message));
    } on ReceiptException catch (re) {
      return Left(Failure(statusCode: re.statusCode, message: re.message));
    } catch (e) {
      return Left(Failure());
    }
  }

  @override
  Future<Either<Failure, String>> createReport(DateTime date) async {
    try {
      final ships = (await shipRemote.getAllShips(date))
          .map((e) => ShipFromShipsDetailModel.fromJson(e))
          .toList();

      final workbook = Workbook(7);
      final sheet1 = workbook.worksheets[0];
      final sheet2 = workbook.worksheets[1];
      final sheet3 = workbook.worksheets[2];
      final sheet4 = workbook.worksheets[3];
      final sheet5 = workbook.worksheets[4];
      final sheet6 = workbook.worksheets[5];
      final sheet7 = workbook.worksheets[6];

      sheet1.name = 'Semua';
      sheet2.name = 'Scan';
      sheet3.name = 'Ambil Barang';
      sheet4.name = 'Check';
      sheet5.name = 'Pack';
      sheet6.name = 'Kirim';
      sheet7.name = 'Return';

      generateSheetsData(
        isFirstSheet: true,
        sheet: sheet1,
        datas: ships,
        title: [
          'Scan Resi',
          'Ambil Barang',
          'Check Resi',
          'Packing',
          'Kirim',
          'Return',
        ],
      );
      generateSheetsData(
        sheet: sheet2,
        datas: ships,
        title: ['Scan Resi'],
        stageName: 'Scan',
      );
      generateSheetsData(
        sheet: sheet3,
        datas: ships,
        title: ['Ambil Barang'],
        stageName: 'Pick Up',
      );
      generateSheetsData(
        sheet: sheet4,
        datas: ships,
        title: ['Check Resi'],
        stageName: 'Check',
      );
      generateSheetsData(
        sheet: sheet5,
        datas: ships,
        title: ['Packing'],
        stageName: 'Pack',
      );
      generateSheetsData(
        sheet: sheet6,
        datas: ships,
        title: ['Kirim'],
        stageName: 'Send',
      );
      generateSheetsData(
        sheet: sheet7,
        datas: ships,
        title: ['Return'],
        stageName: 'Return',
      );

      final bytes = workbook.saveSync();
      workbook.dispose();

      final directory = await getExternalStorageDirectory();
      final path = directory?.path;
      File file = File(
          '$path/report_${DateFormat('d-M-y_H:mm:s').format(DateTime.now())}.xlsx');
      await file.writeAsBytes(bytes, flush: true);

      return const Right('Berhasil Membuat Laporan');
    } catch (e) {
      return Left(Failure());
    }
  }

  @override
  Either<Failure, String> getImageUrl(String path) {
    try {
      final imgPath = shipRemote.getImageUrl(path);

      return Right(imgPath);
    } catch (e) {
      return Left(Failure());
    }
  }

  @override
  Future<Either<Failure, String>> uploadImage(String toPath, File file) async {
    try {
      if (!await isInternetConnected()) throw NetworkException();

      final fullPath = await shipRemote.uploadImage(toPath, file);

      return Right(fullPath);
    } on NetworkException catch (ne) {
      return Left(Failure(message: ne.message));
    } catch (e) {
      return Left(Failure());
    }
  }

  @override
  Future<Either<Failure, List<String>>> getAllSpreadsheetFiles() async {
    try {
      final directory = (await getExternalStorageDirectory())!;
      final files = await shipLocal.getAllFiles(directory);

      return Right(files.map((e) => e.path).toList());
    } catch (e) {
      return Left(Failure());
    }
  }

  @override
  Future<Either<Failure, String>> deleteShip(int shipId) async {
    try {
      if (!await isInternetConnected()) throw NetworkException();

      await shipRemote.deleteShip(shipId);
      return const Right('Berhasil Menghapus Resi');
    } on NetworkException catch (ne) {
      return Left(Failure(message: ne.message));
    } catch (e) {
      return Left(Failure());
    }
  }

  @override
  Future<Either<Failure, ShipEntity>> getReceiptStatus(
      String receiptNumber) async {
    try {
      if (!await isInternetConnected()) throw NetworkException();

      final data = await shipRemote.getReceiptStatus(receiptNumber);

      if (data.isEmpty) {
        return Left(Failure(message: 'Nomor resi tidak ditemukan'));
      }

      print(data);
      return Right(ShipFromShipsModel.fromJson(data.first));
    } on NetworkException catch (ne) {
      return Left(Failure(message: ne.message));
    } catch (e, s) {
      print(e);
      print(s);
      return Left(Failure(message: e.toString()));
    }
  }
}

void generateSheetsData({
  bool isFirstSheet = false,
  required Worksheet sheet,
  required List<ShipEntity> datas,
  required List<String> title,
  String? stageName,
}) {
  if (isFirstSheet) {
    final receipts = datas.map((e) => e.receipt).toSet().toList();

    sheet.getRangeByIndex(1, 1).setText('No');
    sheet.getRangeByIndex(1, 2).setText('Nomor Resi');
    sheet.getRangeByIndex(1, 3).setText(title[0]);
    sheet.getRangeByIndex(1, 4).setText(title[1]);
    sheet.getRangeByIndex(1, 5).setText(title[2]);
    sheet.getRangeByIndex(1, 6).setText(title[3]);
    sheet.getRangeByIndex(1, 7).setText(title[4]);
    sheet.getRangeByIndex(1, 8).setText('Tanggal');

    for (int i = 0; i < receipts.length; i++) {
      // Filter the current receipt same with receipt in datas variable
      final temp = datas.where((e) => e.receipt == receipts[i]).toList();
      // Get name from the filtered receipt
      final names = temp.map((e) => e.name).toList();

      // check that every stage has name, if length is 5 (total stage) there is no stage has not scanned
      switch (names.length) {
        case 0:
          names.addAll(['-', '-', '-', '-', '-']);
          break;
        case 1:
          names.addAll(['-', '-', '-', '-']);
          break;
        case 2:
          names.addAll(['-', '-', '-']);
          break;
        case 3:
          names.addAll(['-', '-']);
          break;
        case 4:
          names.addAll(['-']);
          break;
        default:
          break;
      }

      List<String> data = [
        '${i + 1}',
        receipts[i],
        ...names,
        DateFormat('d-M-y').format(temp.last.syncWithWIB)
      ];

      for (int j = 0; j < data.length; j++) {
        sheet.getRangeByIndex(i + 2, j + 1).setText(data[j]);
      }
    }
  } else {
    final filtered = datas.where((e) => e.stage == stageName).toList();

    sheet.getRangeByIndex(1, 1).setText('No');
    sheet.getRangeByIndex(1, 2).setText('Nomor Resi');
    sheet.getRangeByIndex(1, 3).setText(title.first);
    sheet.getRangeByIndex(1, 4).setText('Tanggal');
    sheet.getRangeByIndex(1, 5).setText('Jam');

    for (int i = 0; i < filtered.length; i++) {
      final ready = [
        '${i + 1}',
        filtered[i].receipt,
        filtered[i].name,
        DateFormat('d-M-y').format(filtered[i].syncWithWIB),
        // Add 7 hours to sync with WIB
        DateFormat.Hms().format(filtered[i].syncWithWIB)
      ];

      for (int j = 0; j < 5; j++) {
        sheet.getRangeByIndex(i + 2, j + 1).setText(ready[j]);
      }
    }
  }
}
