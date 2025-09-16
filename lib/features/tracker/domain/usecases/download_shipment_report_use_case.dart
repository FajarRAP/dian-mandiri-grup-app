import 'package:dartz/dartz.dart';

import '../../../../core/common/use_cases.dart';
import '../../../../core/failure/failure.dart';
import '../repositories/shipment_repositories.dart';

class DownloadShipmentReportUseCase
    implements AsyncUseCaseParams<String, DownloadShipmentReportUseCaseParams> {
  const DownloadShipmentReportUseCase({required this.shipmentRepositories});

  final ShipmentRepositories shipmentRepositories;

  @override
  Future<Either<Failure, String>> call(
      DownloadShipmentReportUseCaseParams params) async {
    return await shipmentRepositories.downloadShipmentReport(params: params);
  }
}

final class DownloadShipmentReportUseCaseParams {
  const DownloadShipmentReportUseCaseParams({
    required this.fileUrl,
    required this.filename,
    required this.createdAt,
  });

  final String fileUrl;
  final String filename;
  final DateTime createdAt;
}
