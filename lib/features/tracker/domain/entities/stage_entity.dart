import 'package:equatable/equatable.dart';

import 'shipment_user_entity.dart';

class StageEntity extends Equatable {
  const StageEntity({
    required this.stage,
    required this.date,
    required this.user,
    required this.document,
  });

  final String stage;
  final String? document;
  final DateTime date;
  final ShipmentUserEntity user;

  @override
  List<Object?> get props => [stage, date, user, document];
}
