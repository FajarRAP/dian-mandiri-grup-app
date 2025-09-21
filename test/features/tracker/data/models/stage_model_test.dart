import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:ship_tracker/features/tracker/data/models/shipment_user_model.dart';
import 'package:ship_tracker/features/tracker/data/models/stage_model.dart';
import 'package:ship_tracker/features/tracker/domain/entities/stage_entity.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tShipmentUserModel = ShipmentUserModel(
    id: '05be1bd7-fdc9-488e-ac94-98eba66d1bd4',
    name: 'mamy',
  );
  final tStageModel = StageModel(
    stage: 'scan',
    date: DateTime.parse('2024-10-10T15:00:49.251932Z'),
    user: tShipmentUserModel,
    document: null,
  );

  group('Stage model test', () {
    test('should be a subclass of StageEntity', () {
      expect(tStageModel, isA<StageEntity>());
    });

    test('should not bring implementation details', () {
      expect(tStageModel.toEntity(), isA<StageEntity>());
      expect(tStageModel.toEntity(), isNot(isA<StageModel>()));
    });

    test('should return valid model from json', () {
      // arrange
      final jsonString = fixtureReader('models/stage.json');
      final json = jsonDecode(jsonString);

      // act
      final result = StageModel.fromJson(json);

      // assert
      expect(result.toEntity(), isA<StageEntity>());
    });
  });
}
