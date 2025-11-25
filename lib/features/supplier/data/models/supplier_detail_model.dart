import '../../../../core/utils/typedefs.dart';
import '../../domain/entities/supplier_detail_entity.dart';

class SupplierDetailModel extends SupplierDetailEntity {
  const SupplierDetailModel({
    required super.id,
    super.avatarUrl,
    required super.name,
    required super.phoneNumber,
    super.address,
    super.email,
  });

  factory SupplierDetailModel.fromEntity(SupplierDetailEntity entity) {
    return SupplierDetailModel(
      id: entity.id,
      avatarUrl: entity.avatarUrl,
      name: entity.name,
      phoneNumber: entity.phoneNumber,
      address: entity.address,
      email: entity.email,
    );
  }

  factory SupplierDetailModel.fromJson(JsonMap json) {
    return SupplierDetailModel(
      id: json['id'],
      avatarUrl: json['avatar'],
      name: json['name'],
      phoneNumber: json['phone'],
      address: json['address'],
      email: json['email'],
    );
  }

  JsonMap toJson() {
    return {
      'id': id,
      'name': name,
      'phone_number': phoneNumber,
      'address': address,
      'email': email,
    };
  }

  SupplierDetailEntity toEntity() {
    return SupplierDetailEntity(
      id: id,
      avatarUrl: avatarUrl,
      name: name,
      phoneNumber: phoneNumber,
      address: address,
      email: email,
    );
  }
}
