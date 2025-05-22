import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(includeIfNull: false)
class User {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String email;
  final String? password;
  final String? role;

  User({
    this.id,
    this.firstName,
    this.lastName,
    required this.email,
    this.password,
    this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
