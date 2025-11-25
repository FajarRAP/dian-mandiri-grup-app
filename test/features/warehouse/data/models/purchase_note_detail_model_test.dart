import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:ship_tracker/features/warehouse/data/models/purchase_note_detail_model.dart';
import 'package:ship_tracker/features/warehouse/domain/entities/purchase_note_detail_entity.dart';

import '../../../../core/utils/fixture_reader.dart';
import '../../../../helpers/testdata/warehouse_test_data.dart';

void main() {
  const fixtureReader = FixtureReader(domain: 'warehouse');
  final purhcaseNoteDetailEntity = tPurchaseNoteDetailEntity;
  final purhcaseNoteDetailModel = tPurchaseNoteDetailModel;

  group('purchase note detail model test', () {
    test('should be a subclass of PurchaseNoteDetailEntity', () {
      // assert
      expect(purhcaseNoteDetailModel, isA<PurchaseNoteDetailEntity>());
    });

    test('should return valid model from json', () {
      // arrange
      final jsonString = fixtureReader.model('purchase_note_detail.json');
      final json = jsonDecode(jsonString);

      // act
      final result = PurchaseNoteDetailModel.fromJson(json);

      // assert
      expect(result, purhcaseNoteDetailModel);
    });

    test('should not bring implementation details', () {
      // assert
      expect(purhcaseNoteDetailModel.toEntity(),
          isNot(isA<PurchaseNoteDetailModel>()));
      expect(purhcaseNoteDetailModel.toEntity(), purhcaseNoteDetailEntity);
    });
  });
}
