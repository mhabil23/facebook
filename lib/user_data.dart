class UserData {
  String? firstName;
  String? lastName;
  String? email;
  String? password;
  DateTime? birthDate;
  String? phoneNumber;

  UserData({
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.birthDate,
    this.phoneNumber,
  });

  // Buat factory untuk parsing dari JSON (jika nanti perlu)
  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      birthDate: json['birth_date'] != null
          ? DateTime.tryParse(json['birth_date'])
          : null,
      phoneNumber: json['phone_number'] as String?,
    );
  }

  // Serialize ke JSON untuk dikirim ke backend
  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password': password,
      'birth_date': birthDate?.toIso8601String(),
      'phone_number': phoneNumber,
    };
  }

  // Contoh helper validasi sederhana (optional)
  bool get isComplete {
    return firstName != null &&
        lastName != null &&
        email != null &&
        password != null &&
        birthDate != null &&
        phoneNumber != null;
  }
}
