import '../model/user_info.dart';
import '../model/user_register_model.dart';
import 'user_http_api.dart';

class UserRepository {
  UserRepository._();
  static final UserHttpApi _httpApi = UserHttpApi();
  static Future<UserInfo> registerUser(UserRegisterModel userInfo) async {
    final resp = await _httpApi.registerUser(userInfo);
    final userinfo = UserInfo.fromJson(resp.data);
    // final teamModel = ProjectsEntity.fromJson(resp.data);
    return userinfo;
  }

  static Future<UserInfo> getUserInfo(String objectId) async {
    final resp = await _httpApi.getUserInfo(objectId);
    // Log.d('resp----->$resp');
    final userinfo = UserInfo.fromJson(resp.data);
    // final teamModel = ProjectsEntity.fromJson(resp.data);
    return userinfo;
  }

  static Future<UserInfo> login({String userName, String passWord}) async {
    final resp = await _httpApi.login(userName, passWord);
    // Log.d('resp----->$resp');
    final userinfo = UserInfo.fromJson(resp.data);
    // final teamModel = ProjectsEntity.fromJson(resp.data);
    return userinfo;
  }

  static Future<bool> modifyUserName(String objectId, String userName) async {
    final resp = await _httpApi.modifyUserName(objectId, userName);
    // Log.d(resp.data);
    // Log.d(resp.statusCode == 200);
    return resp.statusCode == 200;
    // final teamModel = ProjectsEntity.fromJson(resp.data);
    // return userinfo;
  }

  static Future<bool> modifyUserInfo(String objectId, UserInfo userInfo) async {
    final resp = await _httpApi.modifyUserInfo(objectId, userInfo);
    // Log.d(resp.data);
    // Log.d(resp.statusCode == 200);
    return resp.statusCode == 200;
    // final teamModel = ProjectsEntity.fromJson(resp.data);
    // return userinfo;
  }

  static Future<bool> modifyUserPass(
    String objectId,
    String oldPassword,
    String newPassword,
  ) async {
    final resp = await _httpApi.updatePassword(
      objectId,
      oldPassword,
      newPassword,
    );
    // Log.d(resp.data);
    // Log.d(resp.statusCode == 200);
    return resp.statusCode == 200;
    // final teamModel = ProjectsEntity.fromJson(resp.data);
    // return userinfo;
  }
}
