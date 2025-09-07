// lib/models/user_profile.dart

class UserProfile {
  String name;
  String email;
  String mobileNumber;
  String? profileImagePath; // Path to the image file, or URL

  UserProfile({
    required this.name,
    required this.email,
    required this.mobileNumber,
    this.profileImagePath,
  });

  // Optional: A method to create a copy for easy modification
  UserProfile copyWith({
    String? name,
    String? email,
    String? mobileNumber,
    String? profileImagePath,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      profileImagePath: profileImagePath ?? this.profileImagePath,
    );
  }
}