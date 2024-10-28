import 'package:ship_tracker/features/tracker/domain/entities/ship_entity.dart';

class ShipFromShipsModel extends ShipEntity {
  ShipFromShipsModel({
    required super.id,
    required super.receipt,
    required super.name,
    required super.stage,
    required super.userId,
    required super.createdAt,
  });

  factory ShipFromShipsModel.fromJson(Map<String, dynamic> json) =>
      ShipFromShipsModel(
        id: json['id'],
        receipt: json['receipt_number'],
        name: 'Person',
        stage: '${json['stage_id']}',
        userId: json['user_id'],
        createdAt: DateTime.parse(json['created_at']),
      );
}
