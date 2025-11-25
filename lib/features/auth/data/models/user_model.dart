import '../../../../core/utils/typedefs.dart';
import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.permissions,
  });

  factory UserModel.fromJson(JsonMap json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      permissions: List<String>.from(json['permissions']),
    );
  }

  JsonMap toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'permissions': permissions,
      };

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      email: email,
      permissions: permissions,
    );
  }
}
