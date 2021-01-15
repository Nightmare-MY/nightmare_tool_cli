import 'dart:math';

String randomBit(int len) {
  const String scopeF = '123456789'; //首位
  const String scopeC = '0123456789'; //中间
  String result = '';
  for (int i = 0; i < len; i++) {
    if (i == 0) {
      result = scopeF[Random().nextInt(scopeF.length)];
    } else {
      result = result + scopeC[Random().nextInt(scopeC.length)];
    }
  }
  return result;
}
