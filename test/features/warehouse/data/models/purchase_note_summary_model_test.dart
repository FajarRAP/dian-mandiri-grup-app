import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:ship_tracker/features/warehouse/data/models/purchase_note_summary_model.dart';
import 'package:ship_tracker/features/warehouse/domain/entities/purchase_note_summary_entity.dart';

import '../../../../core/utils/fixture_reader.dart';
import '../../../../helpers/testdata/warehouse_test_data.dart';

void main() {
  const fixtureReader = FixtureReader(domain: 'warehouse');
  final purchaseNoteEntity = tPurchaseNoteSummaryEntity;
  final purchaseNoteModel = tPurchaseNoteSummaryModel;

  group('purchase note summary model test', () {
    test('should be a subclass of PurchaseNoteSummaryEntity', () {
      // assert
      expect(purchaseNoteModel, isA<PurchaseNoteSummaryEntity>());
    });

    test('should return valid model from json', () {
      // arrange
      final jsonString = fixtureReader.model('purchase_note_summary.json');
      final json = jsonDecode(jsonString);

      // act
      final result = PurchaseNoteSummaryModel.fromJson(json);

      // assert
      expect(result, purchaseNoteModel);
    });

    test('should not bring implementation details', () {
      // assert
      expect(
          purchaseNoteModel.toEntity(), isNot(isA<PurchaseNoteSummaryModel>()));
      expect(purchaseNoteModel.toEntity(), purchaseNoteEntity);
    });
  });
}
