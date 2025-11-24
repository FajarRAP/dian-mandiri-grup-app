import 'package:ship_tracker/features/tracker/data/models/shipment_detail_model.dart';
import 'package:ship_tracker/features/tracker/data/models/shipment_history_model.dart';
import 'package:ship_tracker/features/tracker/data/models/shipment_model.dart';
import 'package:ship_tracker/features/tracker/data/models/shipment_report_model.dart';
import 'package:ship_tracker/features/tracker/data/models/shipment_user_model.dart';
import 'package:ship_tracker/features/tracker/data/models/stage_model.dart';
import 'package:ship_tracker/features/tracker/domain/entities/shipment_entity.dart';
import 'package:ship_tracker/features/tracker/domain/entities/shipment_detail_entity.dart';
import 'package:ship_tracker/features/tracker/domain/entities/shipment_history_entity.dart';
import 'package:ship_tracker/features/tracker/domain/entities/shipment_report_entity.dart';
import 'package:ship_tracker/features/tracker/domain/entities/shipment_user_entity.dart';
import 'package:ship_tracker/features/tracker/domain/entities/stage_entity.dart';

final tShipmentEntity = ShipmentEntity(
  id: '05c0cef6-9c5d-4165-9145-b2c41f43a5e8',
  courier: 'Shopee Express',
  date: DateTime.parse('2024-10-10T14:05:11.400718Z'),
  receiptNumber: 'SPXID04751919594A',
);
final tShipmentModel = ShipmentModel(
  id: '05c0cef6-9c5d-4165-9145-b2c41f43a5e8',
  courier: 'Shopee Express',
  date: DateTime.parse('2024-10-10T14:05:11.400718Z'),
  receiptNumber: 'SPXID04751919594A',
);

const tShipmentUserEntity = ShipmentUserEntity(
  id: '05be1bd7-fdc9-488e-ac94-98eba66d1bd4',
  name: 'mamy',
);
const tShipmentUserModel = ShipmentUserModel(
  id: '05be1bd7-fdc9-488e-ac94-98eba66d1bd4',
  name: 'mamy',
);

final tShipmentDetailEntity = ShipmentDetailEntity(
  id: '05c0cef6-9c5d-4165-9145-b2c41f43a5e8',
  courier: 'Shopee Express',
  date: DateTime.parse('2024-10-10T14:05:11.531361Z'),
  receiptNumber: 'SPXID04751919594A',
  stage: 'scan',
  document: null,
  user: const ShipmentUserEntity(
    id: '05be1bd7-fdc9-488e-ac94-98eba66d1bd4',
    name: 'mamy',
  ),
);
final tShipmentDetailModel = ShipmentDetailModel(
  id: '05c0cef6-9c5d-4165-9145-b2c41f43a5e8',
  courier: 'Shopee Express',
  date: DateTime.parse('2024-10-10T14:05:11.531361Z'),
  receiptNumber: 'SPXID04751919594A',
  stage: 'scan',
  document: null,
  user: const ShipmentUserModel(
    id: '05be1bd7-fdc9-488e-ac94-98eba66d1bd4',
    name: 'mamy',
  ),
);

final tStageEntity = StageEntity(
  stage: 'scan',
  date: DateTime.parse('2024-10-10T14:05:11.531361Z'),
  user: const ShipmentUserEntity(
    id: '05be1bd7-fdc9-488e-ac94-98eba66d1bd4',
    name: 'mamy',
  ),
  document: null,
);
final tStageModel = StageModel(
  stage: 'scan',
  date: DateTime.parse('2024-10-10T14:05:11.531361Z'),
  user: const ShipmentUserModel(
    id: '05be1bd7-fdc9-488e-ac94-98eba66d1bd4',
    name: 'mamy',
  ),
  document: null,
);

final tShipmentHistoryEntity = ShipmentHistoryEntity(
  id: '05c0cef6-9c5d-4165-9145-b2c41f43a5e8',
  receiptNumber: 'SPXID04751919594A',
  courier: 'Shopee Express',
  date: DateTime.parse('2024-10-10T14:05:11.531361Z'),
  stages: [
    StageEntity(
      stage: 'scan',
      date: DateTime.parse('2024-10-10T14:05:11.531361Z'),
      user: const ShipmentUserEntity(
        id: '05be1bd7-fdc9-488e-ac94-98eba66d1bd4',
        name: 'mamy',
      ),
      document: null,
    )
  ],
);
final tShipmentHistoryModel = ShipmentHistoryModel(
  id: '05c0cef6-9c5d-4165-9145-b2c41f43a5e8',
  receiptNumber: 'SPXID04751919594A',
  courier: 'Shopee Express',
  date: DateTime.parse('2024-10-10T14:05:11.531361Z'),
  stages: [
    StageModel(
      stage: 'scan',
      date: DateTime.parse('2024-10-10T14:05:11.531361Z'),
      user: const ShipmentUserModel(
        id: '05be1bd7-fdc9-488e-ac94-98eba66d1bd4',
        name: 'mamy',
      ),
      document: null,
    )
  ],
);

final tShipmentReportEntity = ShipmentReportEntity(
  id: '669f9bcb-0153-4f1e-9750-c7c0c04cdb87',
  name: 'Reporting of 2025-09-21 - 2025-09-21 16:30:07',
  status: 'completed',
  file:
      'https://storage.dianmandirigrup.id/staging-app/shipment/report/ab1b64ef-a540-46ce-b17e-fbf0877da515.xlsx',
  date: DateTime.parse('2025-09-21T16:30:12.164136Z'),
);
final tShipmentReportModel = ShipmentReportModel(
  id: '669f9bcb-0153-4f1e-9750-c7c0c04cdb87',
  name: 'Reporting of 2025-09-21 - 2025-09-21 16:30:07',
  status: 'completed',
  file:
      'https://storage.dianmandirigrup.id/staging-app/shipment/report/ab1b64ef-a540-46ce-b17e-fbf0877da515.xlsx',
  date: DateTime.parse('2025-09-21T16:30:12.164136Z'),
);
