import 'dart:convert' show json;

T asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }

  return null;
}

class UserRegisterModel {
  UserRegisterModel({
    this.username,
    this.password,
    this.email,
  });

  factory UserRegisterModel.fromJson(Map<String, dynamic> jsonRes) =>
      jsonRes == null
          ? null
          : UserRegisterModel(
              username: asT<String>(jsonRes['username']),
              password: asT<String>(jsonRes['password']),
              email: asT<String>(jsonRes['email']),
            );

  String username;
  String password;
  String email;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'username': username,
        'password': password,
        'email': email,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}
