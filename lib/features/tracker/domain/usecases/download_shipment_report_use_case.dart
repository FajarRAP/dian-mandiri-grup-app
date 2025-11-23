import 'package:dartz/dartz.dart';

import '../../../../core/common/use_cases.dart';
import '../../../../core/failure/failure.dart';
import '../repositories/shipment_repository.dart';

class DownloadShipmentReportUseCase
    implements UseCase<String, DownloadShipmentReportUseCaseParams> {
  const DownloadShipmentReportUseCase({required this.shipmentRepository});

  final ShipmentRepository shipmentRepository;

  @override
  Future<Either<Failure, String>> call(
      DownloadShipmentReportUseCaseParams params) async {
    return await shipmentRepository.downloadShipmentReport(params: params);
  }
}

final class DownloadShipmentReportUseCaseParams {
  const DownloadShipmentReportUseCaseParams({
    required this.externalPath,
    required this.fileUrl,
    required this.filename,
    required this.createdAt,
  });

  final String externalPath;
  final String fileUrl;
  final String filename;
  final DateTime createdAt;
}
