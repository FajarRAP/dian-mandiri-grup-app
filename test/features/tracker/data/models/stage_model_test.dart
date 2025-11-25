import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:ship_tracker/features/tracker/data/models/stage_model.dart';
import 'package:ship_tracker/features/tracker/domain/entities/stage_entity.dart';

import '../../../../core/utils/fixture_reader.dart';
import '../../../../helpers/testdata/tracker_test_data.dart';

void main() {
  const fixtureReader = FixtureReader(domain: 'tracker');
  final stageEntity = tStageEntity;
  final stageModel = tStageModel;

  group('Stage model test', () {
    test('should be a subclass of StageEntity', () {
      // assert
      expect(stageModel, isA<StageEntity>());
    });

    test('should return valid model from json', () {
      // arrange
      final jsonString = fixtureReader.model('stage.json');
      final json = jsonDecode(jsonString);

      // act
      final result = StageModel.fromJson(json);

      // assert
      expect(result, stageModel);
    });

    test('should not bring implementation details', () {
      // assert
      expect(stageModel.toEntity(), isNot(isA<StageModel>()));
      expect(stageModel.toEntity(), stageEntity);
    });
  });
}
