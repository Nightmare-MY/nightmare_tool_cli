class RomInstance {
  // 工厂模式

  factory RomInstance() => _getInstance();
  RomInstance._internal();
  String currentProjectPath;
  String currentProjectName;
  static RomInstance get instance => _getInstance();
  static RomInstance _instance;

  static RomInstance _getInstance() {
    _instance ??= RomInstance._internal();
    return _instance;
  }
}
