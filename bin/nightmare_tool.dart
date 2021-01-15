import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:args/args.dart'; // 使用其中两个类ArgParser和ArgResults
import 'package:ffi/ffi.dart';

import 'screen/login.dart';
import 'utils/custom_log.dart';

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
void showArrow() {
  for (int i = 3 - chooseIndex; i > 0; i--) {
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
  // for (int i = chooseIndex; i <= 3; i++) {
  //   print(deleteOneLine);
  //   cursorDown();
  // }
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

Future<void> main(List<String> arguments) async {
  Log.e('欢迎使用 魇·工具箱 终端版');
  await login();
  stdin.echoMode = false;
  stdin.lineMode = false;

  print('\x1b[2J');
  print('\x1b[0;0H');
  print('1.文件转换\n');
  print('2.动态模块\n');
  print('3.一键执行');
  // cursorLeft();
  showArrow();
  // 隐藏光标，没有生效
  print('\x1b[?25l');
  await onKeyListiner(
    (key) {
      if (key == 13 || key == 10) {
        clear();
        switch (chooseIndex) {
          case 1:
            fileConvert();
            break;
        }
        return true;
        // print(chooseIndex);
      }
      if (csiStart) {
        csiStart = false;
        // print(key);
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
            if (chooseIndex < 3) {
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
            if (chooseIndex < 3) {
              chooseIndex++;
              deleteArrow();
              cursorDown();
              print(arrowChar);
            }
            break;
        }
        return false;
      }
    },
  );
}

void print(Object object) {
  stdout.write(object);
}

void println(Object object) {
  stdout.write('$object\n');
}

int maxLine = 0;
Future<void> fileConvert() async {
  print('1.解压刷机包\n');
  print('2.整合刷机文件\n');
  print('3.打包刷机包\n');
  print('0.返回上级\n');
  maxLine = 4;
  print('\x1b[4A');
  print('\x1b[14C');
  chooseIndex = 1;
  print(arrowChar);
  await onKeyListiner((key) {
    // print('object');
    if (key == 13 || key == 10) {
      print('object');
      clear();
      switch (chooseIndex) {
        case 1:
          // fileConvert();
          execUnzip();
          break;
      }
      return true;
      // print(chooseIndex);
    }
    if (csiStart) {
      csiStart = false;
      // print(key);
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
          if (chooseIndex < maxLine) {
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
          if (chooseIndex < maxLine) {
            chooseIndex++;
            deleteArrow();
            cursorDown();
            print(arrowChar);
          }
          break;
      }
      return false;
    }
  });
}

Future<void> execUnzip() async {}
