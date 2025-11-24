import '../../../../core/utils/typedefs.dart';
import '../../domain/entities/supplier_entity.dart';

class SupplierModel extends SupplierEntity {
  const SupplierModel({
    required super.id,
    required super.avatarUrl,
    required super.name,
    required super.phoneNumber,
  });

  factory SupplierModel.fromJson(JsonMap json) {
    return SupplierModel(
      id: json['id'],
      avatarUrl: json['avatar'],
      name: json['name'],
      phoneNumber: json['phone'],
    );
  }

  SupplierEntity toEntity() {
    return SupplierEntity(
      id: id,
      avatarUrl: avatarUrl,
      name: name,
      phoneNumber: phoneNumber,
    );
  }
}
