import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:ship_tracker/features/supplier/data/models/supplier_model.dart';
import 'package:ship_tracker/features/supplier/domain/entities/supplier_entity.dart';

import '../../../../core/utils/fixture_reader.dart';
import '../../../../helpers/testdata/supplier_test_data.dart';

void main() {
  const fixtureReader = FixtureReader(domain: 'supplier');
  const supplierEntity = tSupplierEntity;
  const supplierModel = tSupplierModel;

  group('supplier model test', () {
    test('should be a subclass of SupplierEntity', () {
      // assert
      expect(supplierModel, isA<SupplierEntity>());
    });

    test('should return valid model from json', () {
      // arrange
      final jsonString = fixtureReader.model('supplier.json');
      final json = jsonDecode(jsonString);

      // act
      final result = SupplierModel.fromJson(json);

      // assert
      expect(result, supplierModel);
    });

    test('should not bring implementation details', () {
      // assert
      expect(supplierModel.toEntity(), isNot(isA<SupplierModel>()));
      expect(supplierModel.toEntity(), supplierEntity);
    });
  });
}
