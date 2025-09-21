import '../../domain/entities/stage_entity.dart';
import 'shipment_user_model.dart';

class StageModel extends StageEntity {
  const StageModel({
    required super.stage,
    required super.date,
    required super.user,
    required super.document,
  });

  factory StageModel.fromJson(Map<String, dynamic> json) => StageModel(
      stage: json['stage'],
      document: json['document'],
      date: DateTime.parse(json['date']),
      user: ShipmentUserModel.fromJson(json['user']));

  StageEntity toEntity() =>
      StageEntity(stage: stage, document: document, date: date, user: user);
}
