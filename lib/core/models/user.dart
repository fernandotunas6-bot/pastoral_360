class User {
  final String id;
  final String email;
  final String name;
  final String? avatarUrl;
  final String role;
  final DateTime createdAt;
  final bool isActive;
  final String? department;
  final String? phone;
  final DateTime? lastLogin;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.avatarUrl,
    required this.role,
    required this.createdAt,
    required this.isActive,
    this.department,
    this.phone,
    this.lastLogin,
  });

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? avatarUrl,
    String? role,
    DateTime? createdAt,
    bool? isActive,
    String? department,
    String? phone,
    DateTime? lastLogin,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
      department: department ?? this.department,
      phone: phone ?? this.phone,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'] as String? ?? '',
    email: json['email'] as String? ?? '',
    name: json['name'] as String? ?? '',
    avatarUrl: json['avatarUrl'] as String?,
    role: json['role'] as String? ?? 'user',
    createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : DateTime.now(),
    isActive: json['isActive'] as bool? ?? true,
    department: json['department'] as String?,
    phone: json['phone'] as String?,
    lastLogin: json['lastLogin'] != null ? DateTime.parse(json['lastLogin'] as String) : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'name': name,
    'avatarUrl': avatarUrl,
    'role': role,
    'createdAt': createdAt.toIso8601String(),
    'isActive': isActive,
    'department': department,
    'phone': phone,
    'lastLogin': lastLogin?.toIso8601String(),
  };
}