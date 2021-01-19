import 'dart:convert';
import 'dart:io';

import 'package:custom_log/custom_log.dart';
import 'package:dio/dio.dart';

import '../http/http.dart';
import '../user/model/user_info.dart';
import '../user/repository/user_repository.dart';

const String userJson = 'userinfo.json';
File userLocalfile = File(userJson);
Future<void> login() async {
  if (userLocalfile.existsSync()) {
    final UserInfo userInfo = UserInfo.fromJson(
      json.decode(userLocalfile.readAsStringSync()) as Map<String, dynamic>,
    );
    // Log.v(userInfo);
    Log.i('欢迎回来 ${userInfo.username}');
    await Future<void>.delayed(const Duration(milliseconds: 300));
  } else {
    // Log.e('object');
    // print('欢迎使用魇·工具箱终端版');
    print('当前登录状态，未登录');

    // cstdio = CStdio(dynamicLibrary);
    // print('');
    // final Pointer<Utf8> utf8Pointer = Utf8.toUtf8('hello');
    // cunistd.write(
    //   1,
    //   utf8Pointer.cast(),
    //   cstring.strlen(utf8Pointer.cast()),
    // );
    // free(utf8Pointer);
    // print('test');
    // cstdio.printf(Utf8.toUtf8('输入账号:').cast());
    // cstdio.fflush(1);;

    stdout.write('输入账号: ');
    final String user = stdin.readLineSync();
    // cstdio.printf(Utf8.toUtf8('输入密码:').cast());
    stdout.write('输入密码: ');
    final String pass = stdin.readLineSync();
    UserInfo userInfo;
    try {
      userInfo = await UserRepository.login(
        userName: user,
        passWord: pass,
      );
    } on DioError catch (e) {
      final StatusException statusException = e.error as StatusException;
      Log.d('error----->${statusException.message}');
    }
    if (userInfo != null) {
      // Log.v(userInfo);
      userLocalfile.writeAsString(UserInfo.fromJson(<String, String>{
        'username': userInfo.username,
        'sessionToken': userInfo.sessionToken,
      }).toString());
      Log.i('欢迎回来 ${userInfo.username}');
      await Future<void>.delayed(const Duration(seconds: 1));
    } else {
      login();
    }
  }
}
