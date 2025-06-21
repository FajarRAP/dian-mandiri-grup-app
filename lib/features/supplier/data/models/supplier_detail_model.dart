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

  factory SupplierDetailModel.fromJson(Map<String, dynamic> json) =>
      SupplierDetailModel(
        id: json['id'],
        avatarUrl: json['avatar'],
        name: json['name'],
        phoneNumber: json['phone_number'],
        address: json['address'],
        email: json['email'],
      );

  Map<String, dynamic> toJsonWithAvatar() => {
        'avatar': avatarUrl,
        'name': name,
        'phone_number': phoneNumber,
        'address': address,
        'email': email,
      };

  Map<String, dynamic> toJsonWithoutAvatar() => {
        'name': name,
        'phone_number': phoneNumber,
        'address': address,
        'email': email,
      };
}
