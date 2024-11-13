import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/failure/failure.dart';
import '../entities/ship_entity.dart';

abstract class ShipRepositories {
  Future<Either<Failure, List<ShipEntity>>> getShips(
      int stageId, DateTime date);
  Future<Either<Failure, String>> insertShip(
      String receiptNumber, String name, int stageId);
  Future<Either<Failure, String>> deleteShip(int shipId);
  Future<Either<Failure, String>> createReport(DateTime date);
  Future<Either<Failure, List<String>>> getAllSpreadsheetFiles();
  Future<Either<Failure, String>> uploadImage(String toPath, File file);
  Future<Either<Failure, ShipEntity>> getReceiptStatus(String receiptNumber);
  Either<Failure, String> getImageUrl(String path);
}
