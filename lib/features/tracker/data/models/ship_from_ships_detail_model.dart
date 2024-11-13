import '../../domain/entities/ship_entity.dart';

class ShipFromShipsDetailModel extends ShipEntity {
  ShipFromShipsDetailModel({
    required super.id,
    required super.receipt,
    required super.stage,
    required super.name,
    required super.userId,
    required super.createdAt,
  });

  

  factory ShipFromShipsDetailModel.fromJson(Map<String, dynamic> json) => ShipFromShipsDetailModel(
        id: json['receipt_number']['id'],
        receipt: json['receipt_number']['receipt_number'],
        name: json['name'],
        stage: json['stage_name']['name'],
        userId: json['receipt_number']['user_id'],
        createdAt: DateTime.parse(json['created_at']),
      );
}
