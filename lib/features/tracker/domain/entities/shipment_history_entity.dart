import 'shipment_entity.dart';
import 'stage_entity.dart';

class ShipmentHistoryEntity extends ShipmentEntity {
  const ShipmentHistoryEntity({
    required super.id,
    required super.receiptNumber,
    required super.courier,
    required super.date,
    required this.stages,
  });

  final List<StageEntity> stages;

  @override
  List<Object?> get props => [...super.props, stages];
}
