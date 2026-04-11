class Participant {
  final String? id;
  final String? name;
  final String? email;
  final String? role;
  final String? status;
  final String? profilePictureUrl;

  const Participant({
    this.id,
    this.name,
    this.email,
    this.role,
    this.status,
    this.profilePictureUrl,
  });

  String get initials {
    if (name == null || name!.isEmpty) return '';
    final parts = name!.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return parts.first[0].toUpperCase();
  }

  factory Participant.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>?;
    return Participant(
      id: user?['id'] as String?,
      name: user?['name'] as String?,
      email: user?['email'] as String?,
      role: json['role'] as String?,
      status: json['status'] as String?,
      profilePictureUrl: user?['profile_picture_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'role': role,
        'status': status,
        'profile_picture_url': profilePictureUrl,
      };
}
