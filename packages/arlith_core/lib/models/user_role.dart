enum UserRole {
  candidate,
  teacher,
  parent,
  admin,
  superAdmin;

  static UserRole fromString(String role) {
    return UserRole.values.firstWhere(
      (e) => e.name == role,
      orElse: () => UserRole.candidate,
    );
  }
}
