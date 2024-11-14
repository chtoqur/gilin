class User {
  final String name;
  final String gender;
  final int age;

  // 생성자에 named parameters 추가
  const User({
    required this.name,
    required this.gender,
    required this.age,
  });

  // JSON 데이터로부터 User 객체 생성을 위한 팩토리 생성자
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] as String? ?? '',  // null 처리
      gender: json['gender'] as String? ?? '',  // null 처리
      age: json['age'] as int? ?? 0,  // null 처리
    );
  }

  // User 객체를 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'gender': gender,
      'age': age,
    };
  }

  @override
  String toString() {
    return 'User(name: $name, gender: $gender, age: $age)';
  }
}