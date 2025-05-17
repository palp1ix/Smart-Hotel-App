class User {
  final int? id;
  final int? companyId;
  final bool? isMaster;
  final String? name;
  final String email;
  final String? password;

  User({
    this.id,
    this.companyId,
    this.isMaster,
    this.name,
    required this.email,
    this.password,
  });
}
