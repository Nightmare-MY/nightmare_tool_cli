import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:args/args.dart'; // 使用其中两个类ArgParser和ArgResults
import 'package:custom_log/custom_log.dart';
import 'package:ffi/ffi.dart';

import 'global/rom_instance.dart';
import 'screen/login.dart';
import 'utils/script_generate.dart' as scripts;

const String arrowChar = ' \x1b[1;32m←\x1b[0m ';
const String cursorUpChar = '\x1b[A';
const String cursorDownChar = '\x1b[B';
const String cursorLeftChar = '\x1b[D';
const String cursorRightChar = '\x1b[C';
// 从当前光标的位置删至行的末尾
const String deleteOneChar = '\x1b[0K';
const String deleteOneLine = '\x1b[1K';
void cursorUp() => print(cursorUpChar);
void cursorDown() => print(cursorDownChar);
void cursorLeft() => print(cursorLeftChar);
void cursorRight() => print(cursorRightChar);
void deleteOne() => print(deleteOneChar);

int chooseIndex = 1;
int showLine = 0;
void showArrow(int maxLine) {
  for (int i = maxLine - chooseIndex; i > 0; i--) {
    cursorUp();
  }
  print(arrowChar);
}

void deleteArrow() {
  cursorLeft();
  cursorLeft();
  cursorLeft();
  deleteOne();
}

bool csiStart = false;
bool escStart = false;
void clear() {
  print('\x1b[2J');
  print('\x1b[0;0H');
}

Future<void> onKeyListiner(bool Function(int key) onKey) async {
  while (true) {
    final int key = stdin.readByteSync();
    if (escStart) {
      escStart = false;
      if (key == 91) {
        csiStart = true;
      }
      continue;
    }
    if (key == 27) {
      escStart = true;
      continue;
    }
    final bool exit = onKey(key);
    if (exit != null && exit) {
      break;
    }
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }
}

void moveArrow(int key) {
  switch (key) {
    case 65:
      if (chooseIndex > 1) {
        chooseIndex--;
        deleteArrow();
        cursorUp();
        print(arrowChar);
      }
      // up
      // print('press up');
      break;
    case 66:
      // down
      // print('press down');
      if (chooseIndex < showLine) {
        chooseIndex++;
        deleteArrow();
        cursorDown();
        print(arrowChar);
      }
      break;
    case 68:
      if (chooseIndex > 1) {
        chooseIndex--;
        deleteArrow();
        cursorUp();
        print(arrowChar);
      }
      break;
    case 67:
      if (chooseIndex < showLine) {
        chooseIndex++;
        deleteArrow();
        cursorDown();
        print(arrowChar);
      }
      break;
  }
}

extension NiDirectory on Directory {
  String get name => path.replaceAll(RegExp('.*/'), '');
}

Future<void> main(List<String> arguments) async {
  Log.e('欢迎使用 魇·工具箱 终端版');
  await login();
  // stdin.echoMode = false;
  // stdin.lineMode = false;
  Directory('Rom').createSync();
  selectProject();
}

String green = '\x1b[32m';
String red = '\x1b[31m';
String yellow = '\x1b[33m';
String blue = '\x1b[34m';
String def = '\x1b[0m';
void selectProject() {
  clear();
  List<FileSystemEntity> dirs = Directory('Rom').listSync();
  List<String> projects = [];
  if (dirs.isEmpty) {
    println('$yellow当前没有发现任何工程');
  } else {
    println('$green选择工程');
    for (FileSystemEntity dir in dirs) {
      if (dir is Directory) {
        projects.add(dir.name);
      }
    }
  }
  for (int i = 0; i < projects.length; i++) {
    print('$blue${i + 1}.${projects[i]}\n');
  }
  println('${red}x.创建工程$def');

  print('请选择 : ');
  final String input = stdin.readLineSync();
  if (input == 'x') {
    createProject();
  } else {
    RomInstance.instance.currentProjectName = projects[int.tryParse(input) - 1];
    RomInstance.instance.currentProjectPath =
        'Rom/${projects[int.tryParse(input) - 1]}';
    home();
  }
}

void createProject() {
  print('请输入工程名:');
  final String input = stdin.readLineSync();
  Directory('Rom/$input').createSync();
  selectProject();
}

List<String> romDirs = <String>[
  'Config',
  'OutFile',
  'UnpackedImg',
  'UnpackedRom',
];
Future<void> home() async {
  print('\x1b[2J');
  print('\x1b[0;0H');
  final String pro = RomInstance.instance.currentProjectName;
  for (String dir in romDirs) {
    Directory directory = Directory('Rom/$pro/$dir');
    if (!directory.existsSync()) {
      directory.createSync();
    }
  }
  print('$yellow当前的工程为:$green${RomInstance.instance.currentProjectName}\n$def');
  print('1.文件转换\n');
  print('2.动态模块\n');
  print('3.一键执行\n');
  print('请选择 : ');
  final String input = stdin.readLineSync();
  print(input);
  switch (input) {
    case '1':
      fileConvert();
      break;
    case '2':
      break;
    case '3':
      break;
    default:
  }
  // cursorLeft();
  // showArrow(3);
  // 隐藏光标，没有生效
  // print('\x1b[?25l');
  showLine = 3;

  // await onKeyListiner(
  //   (key) {
  //     if (key == 13 || key == 10) {
  //       clear();
  //       switch (chooseIndex) {
  //         case 1:
  //           fileConvert();
  //           break;
  //       }
  //       return true;
  //       // print(chooseIndex);
  //     }
  //     if (csiStart) {
  //       csiStart = false;
  //       // print(key);
  //       moveArrow(key);
  //       return false;
  //     }
  //   },
  // );
}

void print(Object object) {
  stdout.write(object);
}

void println(Object object) {
  stdout.write('$object\n');
}

Future<void> fileConvert() async {
  clear();
  print('1.解压刷机包\n');
  print('2.整合刷机文件\n');
  print('3.打包刷机包\n');
  print('4.解压br文件\n');
  print('0.返回上级\n');
  print('请选择 : ');
  final String input = stdin.readLineSync();
  print(input);
  switch (input) {
    case '1':
      execUnzip();
      break;
    case '2':
      break;
    case '3':
      break;
    case '0':
      home();
      break;
    default:
  }
  // showLine = 5;
  // print('\x1b[4A');
  // print('\x1b[14C');
  // chooseIndex = 1;
  // showArrow(showLine);
}

void unzipSystemBr() {
  File('define').writeAsStringSync(
    scripts.unZipBrScript('UnpackedRom/system.new.dat.br'),
  );
  // system('source define && rm -rf define && unZipBrsystem\n');
  stdin.readLineSync();
  clear();
  fileConvert();
}

// int chooseIndex = 1;
// void showArrow() {
//   for (int i = 3 - chooseIndex; i > 0; i--) {
//     cursorUp();
//   }
//   print(arrowChar);
// }
// void system(String script) {
//   CStdlib cStdlib;
//   DynamicLibrary dynamicLibrary = DynamicLibrary.process();
//   cStdlib = CStdlib(dynamicLibrary);
//   final Pointer<Int8> nativeString = Utf8.toUtf8(script).cast();
//   cStdlib.system(nativeString);
//   free(nativeString);
//   return;
//   // print(args);
//   CUnistd cunistd;
//   cunistd = CUnistd(dynamicLibrary);
//   Pointer<Pointer<Utf8>> argv;

//   // argv = allocate<Pointer<Utf8>>(count: args.length + 1);

//   // /// 将Map内容拷贝到二维数组
//   // for (int i = 0; i < args.length; i++) {
//   //   argv[i] = Utf8.toUtf8(
//   //     args[i],
//   //   );
//   // }

//   // argv[args.length] = nullptr;
//   // cunistd.execvp(nativeString, argv.cast());
//   // free(argv);
//   // free(nativeString);
// }

Future<void> execUnzip() async {
  clear();
  List<FileSystemEntity> dirs = Directory.current.listSync();
  List<String> zipFiles = [];
  chooseIndex = 1;
  dirs.forEach((element) {
    if (element.path.endsWith('zip')) {
      zipFiles.add(element.path);
    }
  });
  for (int i = 0; i < zipFiles.length; i++) {
    println('${i + 1}.${zipFiles[i].replaceAll(RegExp('.*/'), '')}');
  }
  print('请选择 : ');
  String input = stdin.readLineSync();
  String script = scripts.unZipRomScript(zipFiles[int.tryParse(input) - 1]);
  File('define').writeAsStringSync(script);
  Pointer<Utf8> env = Utf8.toUtf8(
    'CUR_PRO=${RomInstance.instance.currentProjectPath}',
  );
  // CStdlib cStdlib;
  final DynamicLibrary dynamicLibrary = DynamicLibrary.process();
  // cStdlib = CStdlib(dynamicLibrary);
  // cStdlib.putenv(env.cast());
  // system('source define && rm -rf define && unZipRom\n');
  // await onKeyListiner((key) {
  //   // print('object');
  //   if (key == 13 || key == 10) {
  //     print('object');
  //     clear();
  //     String script = '''
  //     function unZipRom(){
  //         #python_check
  //         #7z_check
  //         echo "\x1b[1;31m>>> 完整解压ROM中...\x1b[0m"
  //         7z x -aoa "${zipFiles[chooseIndex - 1]}" -o"./UnpackedRom" >/dev/null
  //         echo "<<< 刷机包解压结束..."
  //     }
  //     ''';
  //     File('define').writeAsStringSync(script);
  //     switch (chooseIndex) {
  //       case 1:
  //         // fileConvert();
  //         // print('7z');
  //         // system('sh', ['sh', '-c', 'pwd']);
  //         system('source define && rm -rf define && unZipRom\n');
  //         clear();
  //         fileConvert();
  //         // system('sh', ['sh', '-c', './define']);
  //         // system('7z', ['7z', 't', zipFiles[chooseIndex]]);
  //         // print('Platform.environment -> ${Platform.environment['TMPDIR']}');
  //         // execUnzip();

  //         break;
  //     }
  //     return true;
  //     // print(chooseIndex);
  //   }
  //   if (csiStart) {
  //     csiStart = false;
  //     // print(key);
  //     moveArrow(key);
  //     return false;
  //   }
  // });
}
