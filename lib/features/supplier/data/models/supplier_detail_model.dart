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

  factory SupplierDetailModel.fromEntity(SupplierDetailEntity entity) =>
      SupplierDetailModel(
        id: entity.id,
        avatarUrl: entity.avatarUrl,
        name: entity.name,
        phoneNumber: entity.phoneNumber,
        address: entity.address,
        email: entity.email,
      );

  factory SupplierDetailModel.fromJson(Map<String, dynamic> json) =>
      SupplierDetailModel(
        id: json['id'],
        avatarUrl: json['avatar'],
        name: json['name'],
        phoneNumber: json['phone'],
        address: json['address'],
        email: json['email'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone_number': phoneNumber,
        'address': address,
        'email': email,
      };
}
