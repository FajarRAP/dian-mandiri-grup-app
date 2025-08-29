import 'package:dartz/dartz.dart';

import '../../../../core/common/use_cases.dart';
import '../../../../core/failure/failure.dart';
import '../entities/shipment_report_entity.dart';
import '../repositories/shipment_repositories.dart';

class DownloadShipmentReportUseCase
    implements AsyncUseCaseParams<String, ShipmentReportEntity> {
  const DownloadShipmentReportUseCase({required this.shipmentRepositories});

  final ShipmentRepositories shipmentRepositories;

  @override
  Future<Either<Failure, String>> call(ShipmentReportEntity params) async {
    return await shipmentRepositories.downloadShipmentReport(
        shipmentReportEntity: params);
  }
}
