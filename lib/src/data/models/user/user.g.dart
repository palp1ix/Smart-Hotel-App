// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: (json['id'] as num?)?.toInt(),
  firstName: json['firstName'] as String?,
  lastName: json['lastName'] as String?,
  email: json['email'] as String,
  password: json['password'] as String?,
  role: json['role'] as String?,
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  if (instance.id case final value?) 'id': value,
  if (instance.firstName case final value?) 'firstName': value,
  if (instance.lastName case final value?) 'lastName': value,
  'email': instance.email,
  if (instance.password case final value?) 'password': value,
  if (instance.role case final value?) 'role': value,
};
