part of 'ship_cubit.dart';

@immutable
sealed class ShipState {}

final class ShipInitial extends ShipState {}

class GetShip extends ShipState {}

class InsertShip extends ShipState {}

class DeleteShip extends ShipState {}

class ShipLoading extends GetShip {}

class ShipLoaded extends GetShip {
  final List<ShipEntity> ships;

  ShipLoaded(this.ships);
}

class ShipEmpty extends GetShip {}

class ShipError extends GetShip {
  final String message;

  ShipError(this.message);
}

class InsertShipLoading extends InsertShip {}

class InsertShipFinished extends InsertShip {
  final String message;

  InsertShipFinished(this.message);
}

class InsertShipError extends InsertShip {
  final int statusCode;
  final String message;

  InsertShipError(this.statusCode, this.message);
}

class DeleteShipLoading extends DeleteShip {}

class DeleteShipSuccess extends DeleteShip {
  final String message;

  DeleteShipSuccess(this.message);
}

class DeleteShipError extends DeleteShip {
  final String message;

  DeleteShipError(this.message);
}

class ReportLoading extends ShipState {}

class ReportLoaded extends ShipState {}

class AllReport extends ReportLoaded {
  final List<String> reports;

  AllReport(this.reports);
}

class CreateReport extends ReportLoaded {
  final String message;

  CreateReport(this.message);
}

class ReportError extends ShipState {
  final String message;

  ReportError(this.message);
}

class ReceiptImageState extends ShipState {}

class ImageLoading extends ReceiptImageState {}

class ImageLoaded extends ReceiptImageState {
  final String path;

  ImageLoaded(this.path);
}

class ImageError extends ReceiptImageState {
  final String message;

  ImageError(this.message);
}

class UploadImage extends ShipState {}

class ImageUploading extends UploadImage {}

class ImageUploaded extends UploadImage {
  final String path;

  ImageUploaded(this.path);
}

class UploadImageError extends UploadImage {
  final String message;

  UploadImageError(this.message);
}

class CheckReceiptStatusLoading extends ShipState {}
class CheckReceiptStatusLoaded extends ShipState {
  final ShipEntity ship;

  CheckReceiptStatusLoaded(this.ship);
}
class CheckReceiptStatusError extends ShipState {
  final String message;

  CheckReceiptStatusError(this.message);
}
