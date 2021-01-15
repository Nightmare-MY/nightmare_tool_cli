import 'dart:convert';

import 'package:dio/dio.dart';

import '../../http/http.dart';
import '../../utils/custom_log.dart';
import '../model/user_info.dart';
import '../model/user_register_model.dart';

class UserHttpApi {
  Future<Response<Map<String, dynamic>>> registerUser(
      UserRegisterModel userInfo) async {
    final Response<Map<String, dynamic>> response =
        await httpInstance.post<Map<String, dynamic>>(
      'https://api2.bmob.cn/1/classes/_User',
      data: jsonEncode(userInfo),
    );
    return response;
  }

  Future<Response<Map<String, dynamic>>> login(
      String username, String password) async {
    // print('login');
    final Response<Map<String, dynamic>> response =
        await httpInstance.get<Map<String, dynamic>>(
      'https://api2.bmob.cn/1/login',
      queryParameters: <String, dynamic>{
        'username': username,
        'password': password,
      },
    );
    // Log.d('response------>$response');
    return response;
  }

  Future<Response<Map<String, dynamic>>> getUserInfo(String objectId) async {
    final Response<Map<String, dynamic>> response =
        await httpInstance.get<Map<String, dynamic>>(
      'https://api2.bmob.cn/1/users/$objectId',
    );
    return response;
  }

  // 这个接口值用来修改key
  // 用来判定多设备不可同时登录
  Future<Response<Map<String, dynamic>>> modifyUserInfo(
      String objectId, UserInfo userInfo) async {
    // Log.d(userInfo);
    // Log.d('https://api2.bmob.cn/1/user/$objectId');
    final Response<Map<String, dynamic>> response =
        await httpInstance.put<Map<String, dynamic>>(
      'https://api2.bmob.cn/1/users/$objectId',
      data: json.encode(
        <String, dynamic>{
          'phoneKey': userInfo.phoneKey,
        },
      ),
    );
    return response;
  }

  Future<Response<Map<String, dynamic>>> modifyUserName(
      String objectId, String userName) async {
    final Response<Map<String, dynamic>> response =
        await httpInstance.put<Map<String, dynamic>>(
      'https://api2.bmob.cn/1/users/$objectId',
      data: json.encode(
        <String, dynamic>{
          'username': userName,
        },
      ),
    );
    // Log.d(response.data);
    return response;
  }

  Future<Response<Map<String, dynamic>>> updatePassword(
    String objectId,
    String oldPassword,
    String newPassword,
  ) async {
    // Log.d(<String, dynamic>{
    //   'oldPassword': oldPassword,
    //   'newPassword': newPassword,
    // });
    final Response<Map<String, dynamic>> response =
        await httpInstance.put<Map<String, dynamic>>(
      'https://api2.bmob.cn/1/updateUserPassword/$objectId',
      data: json.encode(<String, dynamic>{
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      }),
    );
    // Log.d(response.data);
    return response;
  }
}
