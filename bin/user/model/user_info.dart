import 'dart:convert' show json;

T asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }

  return null;
}

class UserInfo {
  UserInfo({
    this.acl,
    this.createdAt,
    this.email,
    this.emailVerified,
    this.ispay,
    this.nickname,
    this.objectId,
    this.sessionToken,
    this.updatedAt,
    this.phoneKey,
    this.username,
    this.vipTime,
  });

  factory UserInfo.fromJson(Map<String, dynamic> jsonRes) => jsonRes == null
      ? null
      : UserInfo(
          acl: asT<Object>(jsonRes['ACL']),
          createdAt: asT<String>(jsonRes['createdAt']),
          email: asT<String>(jsonRes['email']),
          emailVerified: asT<bool>(jsonRes['emailVerified']),
          ispay: asT<bool>(jsonRes['ispay']),
          nickname: asT<String>(jsonRes['nickname']),
          objectId: asT<String>(jsonRes['objectId']),
          sessionToken: asT<String>(jsonRes['sessionToken']),
          updatedAt: asT<String>(jsonRes['updatedAt']),
          phoneKey: asT<String>(jsonRes['phoneKey']),
          username: asT<String>(jsonRes['username']),
          vipTime: asT<String>(jsonRes['vipTime']),
        );

  Object acl;
  String createdAt;
  String email;
  bool emailVerified;
  bool ispay;
  String nickname;
  String objectId;
  String sessionToken;
  String updatedAt;
  String phoneKey;
  String username;
  String vipTime;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'ACL': acl,
        'createdAt': createdAt,
        'email': email,
        'emailVerified': emailVerified,
        'ispay': ispay,
        'nickname': nickname,
        'objectId': objectId,
        'sessionToken': sessionToken,
        'updatedAt': updatedAt,
        'phoneKey': phoneKey,
        'username': username,
        'vipTime': vipTime,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}
