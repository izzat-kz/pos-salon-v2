class Staff {
  final int id;
  final String name;
  final String password;

  Staff({
    required this.id,
    required this.name,
    required this.password,
  });

  factory Staff.fromMap(Map<String, dynamic> map) {
    return Staff(
      id: map['staff_id'],
      name: map['staff_name'] ?? '',
      password: map['password'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'staff_id': id,
      'staff_name': name,
      'password': password,
    };
  }
}
