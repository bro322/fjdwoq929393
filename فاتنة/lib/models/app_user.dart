
class AppUser {
  final String uid;
  final String email;
  final String fullName;
  final String role; // student | teacher | admin
  final String? gradeLevel; // الصف/البرنامج للطلاب

  AppUser({required this.uid, required this.email, required this.fullName, required this.role, this.gradeLevel});

  factory AppUser.fromMap(String uid, Map<String, dynamic> m) => AppUser(
    uid: uid,
    email: m['email'] ?? '',
    fullName: m['fullName'] ?? '',
    role: m['role'] ?? 'student',
    gradeLevel: m['gradeLevel'],
  );

  Map<String, dynamic> toMap() => {
    'email': email,
    'fullName': fullName,
    'role': role,
    'gradeLevel': gradeLevel,
  };
}
