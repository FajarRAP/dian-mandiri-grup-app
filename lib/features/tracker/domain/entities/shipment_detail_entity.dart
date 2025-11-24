import 'shipment_entity.dart';
import 'shipment_user_entity.dart';

class ShipmentDetailEntity extends ShipmentEntity {
  const ShipmentDetailEntity({
    required super.id,
    required super.courier,
    required super.receiptNumber,
    required super.date,
    required this.stage,
    required this.document,
    required this.user,
  });

  final String stage;
  final String? document;
  final ShipmentUserEntity user;

  @override
  List<Object?> get props => [...super.props, stage, document, user];
}
