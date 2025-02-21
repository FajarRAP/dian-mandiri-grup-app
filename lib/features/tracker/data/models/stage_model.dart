import '../../domain/entities/stage_entity.dart';

class StageModel extends StageEntity {
  const StageModel({
    required super.stage,
    required super.date,
  });

  factory StageModel.fromJson(Map<String, dynamic> json) => StageModel(
        stage: json['stage'],
        date: DateTime.parse(json['date']),
      );
}
