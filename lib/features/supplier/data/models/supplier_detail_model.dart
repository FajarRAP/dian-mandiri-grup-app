import '../../domain/entities/supplier_detail_entity.dart';

class SupplierDetailModel extends SupplierDetailEntity {
  const SupplierDetailModel({
    required super.id,
    required super.avatarUrl,
    required super.name,
    required super.phoneNumber,
    required super.address,
    required super.email,
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

  Map<String, dynamic> toJsonWithAvatar() => {
        'id': id,
        'avatar': avatarUrl,
        'name': name,
        'phone': phoneNumber,
        'address': address,
        'email': email,
      };

  Map<String, dynamic> toJsonWithoutAvatar() => {
        'id': id,
        'name': name,
        'phone': phoneNumber,
        'address': address,
        'email': email,
      };
}
