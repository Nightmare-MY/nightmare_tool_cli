import 'dart:io';

const String arrowChar = ' \x1b[1;32m←\x1b[0m ';
const String cursorUpChar = '\x1b[A';
const String cursorDownChar = '\x1b[B';
const String cursorLeftChar = '\x1b[D';
const String cursorRightChar = '\x1b[C';
// 从当前光标的位置删至行的末尾
const String deleteOneChar = '\x1b[0K';
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

Future<void> main(List<String> arguments) async {
  stdin.echoMode = false;
  stdin.lineMode = false;
  bool csiStart = false;
  bool escStart = false;
  print('1.文件转换\n');
  print('2.动态模块\n');
  print('3.一键执行');
  // cursorLeft();
  showArrow();
  // 隐藏光标，没有生效
  print('\x1b[?25l');
  while (true) {
    final int input = stdin.readByteSync();
    if (input != -1) {
      if (csiStart) {
        csiStart = false;
        // print(input);
        switch (input) {
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
            // left
            // print('press left');
            break;
          case 67:
            // right
            // print('press right');
            break;
        }
      }
      if (escStart) {
        escStart = false;
        if (input == 91) {
          csiStart = true;
        }
      }
      if (input == 27) {
        escStart = true;
      }
    }
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }
}

void print(Object object) {
  stdout.write(object);
}
