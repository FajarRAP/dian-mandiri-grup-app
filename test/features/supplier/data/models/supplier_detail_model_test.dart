import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:ship_tracker/features/supplier/data/models/supplier_detail_model.dart';
import 'package:ship_tracker/features/supplier/domain/entities/supplier_detail_entity.dart';

import '../../../../core/utils/fixture_reader.dart';
import '../../../../helpers/testdata/supplier_test_data.dart';

void main() {
  const fixtureReader = FixtureReader(domain: 'supplier');
  const supplierDetailEntity = tSupplierDetailEntity;
  const supplierDetailModel = tSupplierDetailModel;

  group('supplier detail model test', () {
    test('should be a subclass of SupplierDetailEntity', () {
      // assert
      expect(supplierDetailModel, isA<SupplierDetailEntity>());
    });

    test('should return valid model from json', () {
      // arrange
      final jsonString = fixtureReader.model('supplier_detail.json');
      final json = jsonDecode(jsonString);

      // act
      final result = SupplierDetailModel.fromJson(json);

      // assert
      expect(result, supplierDetailModel);
    });

    test('should return json from model', () {
      // arrange
      final expectedJson = {
        'id': '71213ab2-eb64-4873-9732-a77681c9523f',
        'name': 'ayyubi',
        'phone_number': '087885020053',
        'address': 'pergudangan gracia tunggak jati jl. proklamasi',
        'email': 'tk.ajib@gmail.com',
      };

      // act
      final result = supplierDetailModel.toJson();

      // assert
      expect(result, expectedJson);
    });

    test('should not bring implementation details', () {
      // assert
      expect(supplierDetailModel.toEntity(), isNot(isA<SupplierDetailModel>()));
      expect(supplierDetailModel.toEntity(), supplierDetailEntity);
    });
  });
}
