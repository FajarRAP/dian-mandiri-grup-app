import '../../domain/entities/supplier_entity.dart';

class SupplierModel extends SupplierEntity {
  const SupplierModel({
    required super.id,
    required super.avatarUrl,
    required super.name,
    required super.phoneNumber,
  });

  factory SupplierModel.fromJson(Map<String, dynamic> json) => SupplierModel(
        id: json['id'],
        avatarUrl: json['avatar'],
        name: json['name'],
        phoneNumber: json['phone_number'],
      );
}
