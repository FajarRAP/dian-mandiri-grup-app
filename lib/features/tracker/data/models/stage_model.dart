import '../../domain/entities/stage_entity.dart';
import 'user_model.dart';

class StageModel extends StageEntity {
  const StageModel({
    required super.stage,
    required super.date,
    required this.user,
  });

  final UserModel user;

  factory StageModel.fromJson(Map<String, dynamic> json) => StageModel(
      stage: json['stage'],
      date: DateTime.parse(json['date']),
      user: UserModel.fromJson(json['user']));
}
