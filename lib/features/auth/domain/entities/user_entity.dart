import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.permissions,
  });

  final String id;
  final String name;
  final String email;
  final List<String> permissions;

  String get initials {
    final names = name.split(' ');
    if (names.length == 1) {
      return names.first.substring(0, 1).toUpperCase();
    } else {
      return names.map((n) => n.substring(0, 1).toUpperCase()).take(2).join();
    }
  }

  bool can(String permission) => permissions.any((p) => p == permission);
  bool canAny(List<String> permissions) => permissions.any(can);
  bool canAll(List<String> permissions) => permissions.every(can);

  @override
  List<Object?> get props => [id, name, email, permissions];
}
