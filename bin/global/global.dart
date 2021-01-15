import 'dart:convert';
import 'dart:io';

import '../user/model/user_info.dart';

// enum ThemeMode{
//   dark,
//   light,
//   followSystem,
// }
// 全局类里面有主题、用户信息、外部路径
class Global {
  // 工厂模式
  factory Global() => _getInstance();
  Global._internal() {
    themeFollowSystem = true;
  }
  // 用户信息
  UserInfo userInfo;
  // 主题状态
  bool themeFollowSystem;
  String doucumentDir;
  static Global get instance => _getInstance();
  static Global _instance;

  static Global _getInstance() {
    _instance ??= Global._internal();
    return _instance;
  }

  Future<void> initGlobal() async {
    // doucumentDir = await PlatformUtil.getDocumentDirectory();
  }
}
