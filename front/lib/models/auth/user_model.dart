// AppUser로 이름 변경
class AppUser {
  final String? name;
  final String? gender;
  final num? age;

  const AppUser({
    this.name,
    this.gender,
    this.age,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      name: json['name'] as String?,
      gender: json['gender'] as String?,
      age: json['age'] as num?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'gender': gender,
      'age': age,
    };
  }
}