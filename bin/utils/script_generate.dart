import 'dart:io';

import 'package:custom_log/custom_log.dart';

// 需要几个Shell变量
// CUR_PRO工程路径
// NIGHTMARE_PATH
const String packageName = 'com.nightmare';
String dataPath = '/data/data/$packageName';
String filesPath = '$dataPath/files';
String usrPath = '$dataPath/files/usr';
String binPath = '$usrPath/bin';
String tmpPath = '$usrPath/tmp';
String termLockFilePath = '$usrPath/tmp/termare_pop_lock';

String exitScript = 'echo -e "\\033[1;32m返回按键已释放。\\033[0m"\n'
    'rm -rf $termLockFilePath'; //终端模拟器退出的公用代码
const String fileurl = 'http://nightmare.fun/File/MToolkit'; //39.107.248.176

String loadingPrifix = './src/src/night';
String unZipRomScript(String filepath) {
  // 得到解压刷机包的命令行
  return '''
function unZipRom(){
  /bin/echo -n "\\033[1;31m>>> 完整解压ROM中...\\033[0m"
  $loadingPrifix '
  7z x -aoa "$filepath" -o"\$CUR_PRO/UnpackedRom" >/dev/null
  '
  echo "<<< 刷机包解压结束..."
}
''';
}

String unZipBrScript(String filepath) {
  final String _name = filepath.replaceAll(RegExp('.*/|\\..*'), '');
  //得到解压刷机包的命令行
  if (Platform.isWindows) {
    return """
  function unZipBr$_name()
  {
    echo -e '\\033[1;31m>>> 解压br中...\\033[0m'
    brotli -d -f $filepath
    echo -e '\\033[1;32m<<< 解压br结束\\033[0m'
  }
  """;
  }
  return """
function unZipBr$_name(){ 
  echo -n -e '\\033[1;31m>>> 解压 br 中...\\033[0m'
  brotli_auto
  $loadingPrifix '
  brotli_auto -d -f "$filepath"
  '
  echo "<<< br解压结束。"
}
""";
}

String zipBrScript(String filepath) {
  final String _name = filepath.replaceAll(RegExp('.*/|\\..*'), '');
  //得到解压刷机包的命令行
  if (Platform.isWindows) {
    return """
  function zipBr$_name()
  {
    echo -e '\\033[1;31m>>> 压缩br中...\\033[0m'
    brotli -q 3 -f $filepath 
    echo -e '\\033[1;32m<<< 压缩br结束\\033[0m'
  }
  """;
  }
  return """
function zipBr$_name(){ 
  echo -n -e '\\033[1;31m>>> 压缩 br 中...\\033[0m'
  $loadingPrifix '
  brotli_auto -q 3 -f "$filepath"
  '
  echo "<<< br压缩结束。"
}
""";
}

Future<String> unZipImgScript(String filepath) async {
  //得到解压刷机包的命令行
  Log.i('得到解压刷机包的命令行');
  final String _name = filepath.replaceAll(RegExp('.*/|\\..*'), '');
  String tmpPath;
  if (Platform.isWindows) {
    tmpPath = Platform.environment['Tmp'] + '\\YanTool';
    Directory(tmpPath).createSync();
  }
  String _str;

  if (Platform.isAndroid) {
    return
        // "echo 当前解压的img文件为$filepath\n" +
        //计算出镜像文件的字节总数，保存在shell变量中
        """
function unZipImg$_name(){
  touch $termLockFilePath
  rom-tool_auto
  filesize=\$(${Platform.isLinux ? "" : "busybox"} stat -c \"%s\" "$filepath")
  echo -n -e '\\033[1;31m>>> 解压 $_name img 中...\\033[0m'
  $loadingPrifix '
  7z x -y -aoa "$filepath" -o"\$CUR_PRO/UnpackedImg/$_name/" >/dev/null
  '
  rm -rf "\$CUR_PRO/UnpackedImg/$_name/[SYS]"
  touch "\$CUR_PRO/UnpackedImg/解压的Img目录"
  if [ -d \"\$CUR_PRO/UnpackedImg/$_name/system\" ]; then
    echo -e "\\033[1;32m>>> 当前为AB机型\\033[0m"
    point=/
  else
    point=$_name
  fi
  mkdir "\$CUR_PRO/Config" >/dev/null 2>&1
  echo -n -e '\\033[1;31m保存该img的context/fs_config/symbol_link...\\033[0m'
  echo -n \$filesize >"\$CUR_PRO/Config/$_name\_img_size"
  result=`7z t "$filepath"`
  result=`echo \$result | sed  's/.*Size: //'`
  result=`echo \$result | sed  's/ .*//'`
  echo -n \$result >"\$CUR_PRO/Config/$_name\_dir_size"
  7z x -y -aoa -p906262255 /data/data/com.nightmare/files/usr/bin/romtool -o/data/data/com.nightmare/files/home/bin/ >/dev/null 2>&1
  python3 /data/data/com.nightmare/files/home/bin/contexts_analyzer "$filepath" "\$point" >"\$CUR_PRO/Config/$_name\_file_contexts" 2>/dev/null
  python3 /data/data/com.nightmare/files/home/bin/fs_config_analyzer "$filepath" "\$point" >"\$CUR_PRO/Config/$_name\_fs_config" 2>/dev/null
  python3 /data/data/com.nightmare/files/home/bin/link_analyzer "$filepath" ./$_name >"\$CUR_PRO/Config/$_name\_links" 2>/dev/null
  touch "\$CUR_PRO/Config/Img的配置文件保存目录"
  rm -rf /data/data/com.nightmare/files/home/bin/
  echo 已保存。
  echo "<<< 解压结束,已保存相关信息。"
  $exitScript
}
""";
  }
  return '';
  // _str =
  // "echo 当前解压的img文件为$filepath\n" +
  //计算出镜像文件总节总数，保存在shell变量中
//         """
// function unZipImg$_name()
// {
//   touch $termLockFilePath
//   TMPDIR=${PlatformUtil.getUnixPath(tmpPath)}
//   LOG_PATH=${PlatformUtil.getUnixPath(PlatformUtil.documentsDir)}/YanTool/日志文件夹/ROM日志.txt
//   filesize=\$(stat -c \"%s\" $filepath)
//   echo -n -e '\\033[1;31m清空解压缓存...\\033[0m'
//   busybox rm -rf \$CUR_PRO/UnpackedImg/$_name/*
//   echo -----完成

//   echo -n -e '\\033[1;31m解压$_name img中...\\033[0m'
//   7z x -y -aoa $filepath -o\$CUR_PRO/UnpackedImg/$_name/ >/dev/null 2>>\$LOG_PATH
//   rm -rf \$CUR_PRO/UnpackedImg/$_name/[SYS]
//   touch \$CUR_PRO/UnpackedImg/解压的Img目录
//   if [ -d \"\$CUR_PRO/UnpackedImg/$_name/system\" ]; then
// echo -------当前为AB机型
// point=//
//   else
// point=$_name
//   fi
//   mkdir \$CUR_PRO/Config >/dev/null 2>&1
//   echo -n -e '\\033[1;31m保存该img的context/fs_config/symbol_link...\\033[0m'
//   echo -n \$filesize >\$CUR_PRO/Config/$_name\_size
//   7z x -y -aoa -p906262255 ${PlatformUtil.getUnixPath(binPath)}/msys-libcontext.dll -o${PlatformUtil.getUnixPath(tmpPath)} >/dev/null 2>&1
//   \$TMPDIR/msys-libcontext.dll ${PlatformUtil.getUnixPath(filepath)} \\
//   "\$point" >\$CUR_PRO/Config/$_name\_file_contexts \\
//   2>/dev/null
//   rm -rf \$TMPDIR/msys-libcontext.dll
//   7z x -y -aoa -p906262255 ${PlatformUtil.getUnixPath(binPath)}/msys-libfs.dll -o${PlatformUtil.getUnixPath(tmpPath)} >/dev/null 2>&1
//   dos2unix \$CUR_PRO/Config/$_name\_file_contexts >/dev/null 2>&1
//   \$TMPDIR/msys-libfs.dll ${PlatformUtil.getUnixPath(filepath)} \\
//   "\$point" >\$CUR_PRO/Config/$_name\_fs_config \\
//   2>/dev/null
//   rm -rf \$TMPDIR/msys-libfs.dll
//   7z x -y -aoa -p906262255 ${PlatformUtil.getUnixPath(binPath)}/msys-liblink.dll -o${PlatformUtil.getUnixPath(tmpPath)} >/dev/null 2>&1
//   dos2unix \$CUR_PRO/Config/$_name\_fs_config >/dev/null 2>&1
//   \$TMPDIR/msys-liblink.dll \\
//   ${PlatformUtil.getUnixPath(filepath)} ./$_name \\
//   >\$CUR_PRO/Config/$_name\_links 2>/dev/null
//   rm -rf \$TMPDIR/msys-liblink.dll
//   dos2unix \$CUR_PRO/Config/$_name\_links >/dev/null 2>&1
//   touch \$CUR_PRO/Config/Img的配置文件保存目录
//   echo -------已保存。
//   echo 解压结束,已保存相关信息。
//   $exitScript
// }
// """;

  // return _str;
}

String sdat2ImgScript(String dataFilePath, String listFilepath) {
  //得到Sdat2img的命令行
  final String _name = dataFilePath.replaceAll(RegExp('.*/|\\..*'), '');

  String _str;
  if (Platform.isAndroid) {
    _str = """
  function sdat2img$_name()
  {
    touch $termLockFilePath
    rom-tool_auto
    echo -n -e '\\033[1;31m>>> 转换dat中...\\033[0m'
    $loadingPrifix '
    python3 /data/data/com.nightmare/files/usr/python/sdat2img.py "$listFilepath" "$dataFilePath" "${File(dataFilePath).parent.path}/$_name.img" >/dev/null
    '
    echo "<<< 转换dat结束。"
    $exitScript
  }
  """;
  } else if (Platform.isLinux) {
    _str = """
  function sdat2img$_name()
  {
    touch $termLockFilePath
    echo -n -e '\\033[1;31m>>> 转换dat中...\\033[0m'
    $loadingPrifix '
    python3 $filesPath/usr/python/sdat2img.py $listFilepath $dataFilePath ${File(dataFilePath).parent.path}/$_name.img >/dev/null
    '
    echo "<<< 转换dat结束。"
    $exitScript
  }
  """;
  } else if (Platform.isWindows) {
    _str = """
  function sdat2img$_name()
  {
    echo -e '\\033[1;31m转换dat中...\\033[0m'
    sdat2img $listFilepath $dataFilePath ${File(dataFilePath).parent.path}/$_name.img >/dev/null
    echo -e '\\033[1;32m转换结束.\\033[0m'
    
  }
  """;
  }

  return _str;
}

String repackingBoot() {
  return """
  function repackBoot(){
    touch $termLockFilePath
    cd /data/data/com.nightmare/files/home/AIK-mobile/
    su -c '
    chmod 0777 repackimg.sh
    /system/bin/sh repackimg.sh
    sleep 2
    mkdir "\$CUR_PRO/OutFile" >/dev/null 2>&1
    mv 'image-new.img' "\$CUR_PRO/OutFile/boot.img"
    echo 清除缓存目录 ...
    chmod 0777 cleanup.sh
    /system/bin/sh cleanup.sh >/dev/null 2>&1
    rm -rf ./boot.img
    echo 生成至 "\$CUR_PRO/OutFile/boot.img"
    '
    $exitScript
  }
  """;
}

String buildUpdateScript(List<bool> _bool) {
  return '''
  busybox wget $fileurl/updater-script_build.py -O /data/data/com.nightmare/files/home/updater-script_build.py \\
  >/dev/null 2>&1
  python3 /data/data/com.nightmare/files/home/updater-script_build.py \\
  \$CUR_PRO/UnpackedRom/META-INF/com/google/android/updater-script \\
  \$CUR_PRO/UnpackedRom/META-INF/com/google/android/updater-script \\
  ${_bool[0]} ${_bool[2]} ${_bool[3]} ${_bool[4]}\\
  ''';
}

String deleteBootAvb() {
  return '''
  function deleteBootAvb(){
    touch $termLockFilePath
    magisk-boot_auto
    if [ ! -f "$filesPath/usr/python/delete_avb.py" ]; then
      echo  -e  "\\033[1;31m未发现avb算法下载中\\033[0m"
      mkdir $filesPath/usr/python >/dev/null 2>&1
      curl "$fileurl/Rom/python/delete_avb.py" -o $filesPath/usr/python/delete_avb.py
    fi
    echo -e "\\033[1;31m去除boot分区avb\\033[0m"

    su -c "
    export PATH=/data/data/com.nightmare/files/usr/bin:\$PATH
    $binPath/python $filesPath/usr/python/delete_avb.py /data/data/com.nightmare/files/home/AIK-mobile/ramdisk/fstab.qcom
    rm -rf /data/data/com.nightmare/files/home/AIK-mobile/ramdisk/verity_key
    magiskboot hexpatch \\
    /data/data/com.nightmare/files/home/AIK-mobile/split_img/boot.img-zImage 2C617662 00000000
    magiskboot hexpatch \\
    /data/data/com.nightmare/files/home/AIK-mobile/split_img/boot.img-zImage 2C766572696679 00000000000000
    magiskboot hexpatch \\
    /data/data/com.nightmare/files/home/AIK-mobile/split_img/boot.img-dtb 2C617662 00000000
    magiskboot hexpatch \\
    /data/data/com.nightmare/files/home/AIK-mobile/split_img/boot.img-dtb 2C766572696679 00000000000000
    "
    $exitScript
  }
  ''';
}

String doPermissiveScript() {
  //内核宽容脚本
  return """
  function doPermissive(){
    touch $termLockFilePath
    echo -e "\\033[1;31m执行内核宽容\\033[0m"
    su -c '
    cmdline=`cat /data/data/com.nightmare/files/home/AIK-mobile/split_img/boot.img-cmdline`
    cmdline=`echo \$cmdline`
    echo \"\$cmdline androidboot.verifiedbootstate=green androidboot.selinux=permissive\" \\
    >/data/data/com.nightmare/files/home/AIK-mobile/split_img/boot.img-cmdline
    '
    $exitScript
  }
  """;
}

String repackRom(String name) {
  return """
  function repackRom(){
    echo -n -e '\\033[1;31m打包中...\\033[0m'
    rm -rf \$CUR_PRO/UnpackedRom/文件的生成目录
    rm -rf \$CUR_PRO/UnpackedRom/compatibility.zip
    $loadingPrifix '
    7z -tZip a "\$CUR_PRO/UnpackedRom/$name.zip" \$CUR_PRO/UnpackedRom/* -mx1 >/dev/null
    '
    rm -rf \$CUR_PRO/UnpackedRom/system.*
    rm -rf \$CUR_PRO/UnpackedRom/vendor.*
  }
  """;
}

String img2sdatScript(String filepath) {
  //得到Sdat2img的命令行
  final String _name = filepath.replaceAll(RegExp('.*/|\\..*'), '');
  String _str;
  if (Platform.isWindows) {
    return '''
    function img2sdat$_name()
  {
    echo -n -e '\\033[1;31m转换Simg到Sdat中...\\033[0m'
    img2sdat -o ${File(filepath).parent.path} -v 4 -p $_name $filepath >/dev/null
    echo 已转换至${File(filepath).parent.path}文件夹下
    $exitScript
  }
    ''';
  }
  if (Platform.isAndroid) {
    _str = """
  function img2sdat$_name()
  {
    touch $termLockFilePath
    rom-tool_auto
    echo -n -e '\\033[1;31m转换Simg到Sdat中...\\033[0m'
    $loadingPrifix '
    python3 /data/data/com.nightmare/files/usr/python/img2sdat.py -o ${File(filepath).parent.path} -v 4 -p $_name $filepath >/dev/null 
    '
    echo 已转换至${File(filepath).parent.path}文件夹下
    $exitScript
  }
  """;
  } else {
    _str = """
  function img2sdat$_name()
  {
    touch $termLockFilePath
    echo -n -e '\\033[1;31m转换Simg到Sdat中...\\033[0m'
    $loadingPrifix '
    python3 $filesPath/usr/python/Img2sdat/img2sdat.py -o ${File(filepath).parent.path} -v 4 -p $_name $filepath >/dev/null 
    rm -rf /data/data/com.nightmare/files/home/bin/
    '
    echo 已转换至${File(filepath).parent.path}文件夹下
    $exitScript
  }
  """;
  }

  return _str;
}

//打包Img的脚本
String repackImgScript(String simg) {
  String _sh;
  if (Platform.isAndroid) {
    _sh = """
  function repackImg()
  {
    touch $termLockFilePath
    rom-tool_auto
    cd "\$CUR_PRO/UnpackedImg"
    directorys=\$(find ./ -maxdepth 1 -type d | sed 's/.\\///g')
    for flodername in \$directorys
      do
          if [ \"\$flodername\" != \"./\" ]; then
            cd /data/data/com.nightmare/files/home/
            echo 清空 \$flodername 历史缓存...
            rm -rf /data/data/com.nightmare/files/home/\$flodername
            echo -n -e "\\033[1;31m复制 \$flodername 到数据目录...\\033[0m"
            $loadingPrifix "
            cp -rf '\$CUR_PRO/UnpackedImg/\$flodername' /data/data/com.nightmare/files/home
            "
            echo -n -e "\\033[1;31m恢复 \$flodername 符号链接...\\033[0m"
            export link_name=\$flodername'_links'
            $loadingPrifix '
            cp -rf "\$CUR_PRO/Config/\$link_name" /data/data/com.nightmare/files/home/
            sh /data/data/com.nightmare/files/home/\$link_name >/dev/null 2>&1
            '
            size_file_name=\$flodername'_img_size'
            filesize=\$(cat "\$CUR_PRO/Config/\$size_file_name")
            echo 当前分区大小为\$filesize
            mkdir "\$CUR_PRO/OutFile" >/dev/null 2>&1
            touch "\$CUR_PRO/OutFile/文件的生成目录"
            if [ -d "\$CUR_PRO/UnpackedImg/\$flodername/system" ]; then
              point=/
            else
              point=\$flodername
            fi
            echo 获取fs补丁算法
            curl $fileurl/python/fs_config_add.py -o /data/data/com.nightmare/files/usr/python/fs_config_add.py
            echo 补丁中
            fs_name=\$flodername'_fs_config'
            python /data/data/com.nightmare/files/usr/python/fs_config_add.py \\
            "\$CUR_PRO/Config/\$fs_name" \\
            /data/data/com.nightmare/files/home/\$flodername \\
            \$point
            echo -e "\\033[1;31m>>> 生成 \$flodername.img中...\\033[0m"
            con_name=\$flodername'_file_contexts'
            make_ext4fs -L \$point -T 1230739200 $simg -S "\$CUR_PRO/Config/\$con_name" -C "\$CUR_PRO/Config/\$fs_name" -l \$filesize -a \$point "\$CUR_PRO/OutFile/\$flodername.img" /data/data/com.nightmare/files/home/\$flodername
            echo 清空数据目录\$flodername...
            rm -rf /data/data/com.nightmare/files/home/\$flodername
          fi
      done
      rm -rf /data/data/com.nightmare/files/home/\$flodername
      echo "<<< 打包结束。"
      $exitScript
  }
  """;
  } else if (Platform.isLinux) {
    _sh = """
  function repackImg()
  {
    touch $termLockFilePath
    python_check
    rom-tool_check
    echo -e "\\033[1;31m下载fs补丁算法...\\033[0m"
    busybox wget $fileurl/fs_config_add.py -O /data/data/com.nightmare/files/home/fs_config_add.py >/dev/null 2>&1
    mkdir /data/data/com.nightmare/files/home/bin >/dev/null 2>&1
    cd \$CUR_PRO/UnpackedImg
    directorys=\$(find ./ -maxdepth 1 -type d | sed 's/.\\///g')
    for flodername in \$directorys
      do
          if [ \"\$flodername\" != \"./\" ]; then
            echo -n -e "\\033[1;31m恢复 \$flodername 符号链接...\\033[0m"
            $loadingPrifix "
            sh \$CUR_PRO/Config/\$flodername'_links'
            "
            filesize=\$(cat \$CUR_PRO/Config/\$flodername'_size')
            echo 当前分区大小为\$filesize
            mkdir \$CUR_PRO/OutFile >/dev/null 2>&1
            touch \$CUR_PRO/OutFile/文件的生成目录
            if [ -d "\$CUR_PRO/UnpackedImg/\$flodername/system" ]; then
              point=/
            else
              point=\$flodername
              cp -rf \$CUR_PRO/Config/\$flodername'_fs_config' /data/data/com.nightmare/files/home/
              python3 /data/data/com.nightmare/files/home/fs_config_add.py \$flodername
              mv -f /data/data/com.nightmare/files/home/\$flodername'_fs_config' \$CUR_PRO/Config/
            fi
            echo -e "\\033[1;31m>>> 生成 \$flodername.img中...\\033[0m"
            ${binPath}/make_ext4fs -L \$point -T 1230739200$simg -S \$CUR_PRO/Config/\$flodername'_file_contexts' -C \$CUR_PRO/Config/\$flodername'_fs_config' -l \$filesize -a \$point \$CUR_PRO/OutFile/\$flodername.img \$flodername
            echo 清空数据目录\$flodername...
          fi
      done
      rm -rf /data/data/com.nightmare/files/home/bin/
      rm -rf /data/data/com.nightmare/files/home/*.py
      rm -rf /data/data/com.nightmare/files/home/\$flodername
      echo "<<< 打包结束。"
      $exitScript
  }
  """;
  } else if (Platform.isLinux || Platform.isWindows) {
    _sh = """
  function repackImg()
  {
    touch $termLockFilePath
    python_check
    busybox wget $fileurl/fs_config_add.py -O ${filesPath}/usr/python/fs_config_add.py >/dev/null 2>&1
    cd \$CUR_PRO/UnpackedImg
    directorys=\$(find ./ -maxdepth 1 -type d | sed 's/.\\///g')
    for flodername in \$directorys
      do
          if [ \"\$flodername\" != \"./\" ]; then
            echo \$flodername
            echo -n -e "\\033[1;31m恢复 \$flodername 符号链接...\\033[0m"
            sh \$CUR_PRO/Config/\$flodername'_links'
            echo "-完成。"
            filesize=\$(cat \$CUR_PRO/Config/\$flodername'_size')
            echo 当前分区大小为\$filesize
            mkdir \$CUR_PRO/OutFile >/dev/null 2>&1
            touch \$CUR_PRO/OutFile/文件的生成目录
            if [ -d "\$CUR_PRO/UnpackedImg/\$flodername/system" ]; then
              point=//
            else
              point=\$flodername
              # cp -rf \$CUR_PRO/Config/\$flodername'_fs_config' /data/data/com.nightmare/files/home/
              # python ${filesPath}/usr/python/fs_config_add.py \$flodername
              #mv -f /data/data/com.nightmare/files/home/\$flodername'_fs_config' \$CUR_PRO/Config/
            fi
            echo -e "\\033[1;31m生成 \$flodername.img中...\\033[0m"
            make_ext4fs -L \$point -T 1230739200$simg -S \$CUR_PRO/Config/\$flodername'_file_contexts' -C \$CUR_PRO/Config/\$flodername'_fs_config' -l \$filesize -a \$point \$CUR_PRO/OutFile/\$flodername.img \$CUR_PRO/UnpackedImg/\$flodername
          fi
      done
      echo 打包结束。
      $exitScript
  }
  """;
  }

  return _sh;
}

String deodexScript() {
  // Log.d("\$CUR_PRO/UnpackedRom/system/system");
  //得到解压刷机包的命令行
  // if (Platform.isWindows) {
  //   final String tmpPath = Platform.environment['Tmp'] + '\\YanTool';
  //   Directory(tmpPath).createSync();
  //   return '''
  // function deodexFunc()
  // {
  //   touch $termLockFilePath
  //   zip_check
  //   echo -e "\\033[1;31m下载deodex算法中\\033[0m"
  //   #busybox wget $fileurl/Deodex/Deodex1 -O "${PlatformUtil.getUnixPath(tmpPath)}/Deodex1" >/dev/null 2>&1
  //   #busybox wget $fileurl/Deodex/Deodex2 -O "${PlatformUtil.getUnixPath(tmpPath)}/Deodex2" >/dev/null 2>&1
  //   echo -e "\\033[1;31m下载结束,合并中\\033[0m"
  //   if [ -d "\$CUR_PRO/UnpackedImg/system/system" ]; then
  //     cd \$CUR_PRO/UnpackedImg/system/system
  //     sh python ${PlatformUtil.getUnixPath(tmpPath)}/Deodex1 \$CUR_PRO/UnpackedImg/system/system
  //     sh python ${PlatformUtil.getUnixPath(tmpPath)}/Deodex1 \$CUR_PRO/UnpackedImg/vendor
  //     sh python ${PlatformUtil.getUnixPath(tmpPath)}/Deodex2 \$CUR_PRO/UnpackedImg/system/system
  //   else
  //     cd \$CUR_PRO/UnpackedImg/system
  //     python ${PlatformUtil.getUnixPath(tmpPath)}/Deodex1 \$CUR_PRO/UnpackedImg/system
  //     python ${PlatformUtil.getUnixPath(tmpPath)}/Deodex1 \$CUR_PRO/UnpackedImg/vendor
  //     python ${PlatformUtil.getUnixPath(tmpPath)}/Deodex2 \$CUR_PRO/UnpackedImg/system
  //   fi
  //   #判断A/B机型并进入到system上一级文件夹
  //   echo -e "\\033[1;31m合并结束,清除剩余缓存\\033[0m"
  //   rm -rf ./framework/arm
  //   rm -rf ./framework/arm64
  //   rm -rf ./framework/oat
  //   rm -rf ./product/framework/oat
  //   find . -name \"*.vdex\" -exec rm -rf \{\} \\;
  //   #rm -rf ${PlatformUtil.getUnixPath(tmpPath)}/*
  //   $exitScript
  // }
  // ''';
  // }
  final String _str = '''
  function deodexFunc()
  {
    touch $termLockFilePath
    python_auto
    zip_auto
    echo -e "\\033[1;31m下载deodex算法中\\033[0m"
    curl "$fileurl/Deodex/Deodex1" -o "$tmpPath/Deodex1"
    curl "$fileurl/Deodex/Deodex2" -o "$tmpPath/Deodex2"
    echo -e "\\033[1;31m下载结束,合并中\\033[0m"
    if [ -d "\$CUR_PRO/UnpackedImg/system/system" ]; then
      cd "\$CUR_PRO/UnpackedImg/system/system"
      pwd
      python3 $tmpPath/Deodex1 \$CUR_PRO/UnpackedImg/system/system
      python3 $tmpPath/Deodex1 \$CUR_PRO/UnpackedImg/vendor
      python3 $tmpPath/Deodex2 \$CUR_PRO/UnpackedImg/system/system
    else
      cd "\$CUR_PRO/UnpackedImg/system"
      python3 $tmpPath/Deodex1 \$CUR_PRO/UnpackedImg/system
      python3 $tmpPath/Deodex1 \$CUR_PRO/UnpackedImg/vendor
      python3 $tmpPath/Deodex2 \$CUR_PRO/UnpackedImg/system
    fi
    #判断A/B机型并进入到system上一级文件夹
    echo -e "\\033[1;31m合并结束,清除剩余缓存\\033[0m"
    rm -rf ./framework/arm
    rm -rf ./framework/arm64
    rm -rf ./framework/oat
    rm -rf ./product/framework/oat
    find . -name \"*.vdex\" -exec rm -rf \{\} \\;
    rm -rf /data/data/com.nightmare/files/usr/tmp/*
    $exitScript
  }
  ''';
  return _str;
}

// > >(sed $'s,.*,\e[92m&\e[m,')  2> >(sed $'s,.*,\e[93m&\e[m,'>&2)
String patchServices() {
  return '''
${checkApktoolFramework()}
function patchServices(){
  checkApktoolFramework
  echo -e  "\\033[1;31m反编译services中\\033[0m"
  if [ -d "\$CUR_PRO/UnpackedImg/system/system" ]; then
    apktool d \$CUR_PRO/UnpackedImg/system/system/framework/services.jar \\
    -f -o \\
    $tmpPath/services \\
    -p \$NIGHTMARE_PATH/YanTool/Apktool/Framework
  else
    apktool d \$CUR_PRO/UnpackedImg/system/framework/services.jar \\
    -f -o \\
    $tmpPath/services \\
    -p  \$NIGHTMARE_PATH/YanTool/Apktool/Framework
  fi
  sleep 1
  echo -e "\\033[1;31m反编译完成,下载破解算法中\\033[0m"
  curl "$fileurl/Rom/ServicesPatch.py" -o $tmpPath/ServicesPatch.py
  echo -e "\\033[1;31m破解卡米\\033[0m"
  if [ -d "$tmpPath/services/smali_classes2" ]; then
    python3 $tmpPath/ServicesPatch.py $tmpPath/services/smali_classes2
  else
    python3 $tmpPath/ServicesPatch.py $tmpPath/services/smali
  fi
  rm -rf $tmpPath/ServicesPatch.py
  echo -e  "\\033[1;31m回编译Services...\\033[0m"
  apktool b -f \\
  $tmpPath/services \\
  -o \\
  $tmpPath/services.jar \\
  -p \\
  /data/data/com.nightmare/files/Apktool/Framework
  echo -e  "\\033[1;31m回编译结束 ...\\033[0m"
  cd $tmpPath/services/original
  zip -7 -r $tmpPath/services.jar META-INF
  echo 这儿会有 Bad system call 不影响
  if [ -d "\$CUR_PRO/UnpackedImg/system/system" ]; then
    mv -f $tmpPath/services.jar \$CUR_PRO/UnpackedImg/system/system/framework/services.jar
  else
    mv -f $tmpPath/services.jar \$CUR_PRO/UnpackedImg/system/framework/services.jar
  fi
  rm -rf $tmpPath/*
}
  ''';
}

//是否使用自定义二进制
String integrationMagisk(String version) {
  String _tmp = '';
  _tmp = """
  integrationMagisk(){
    magisk_file=Magisk-$version.zip
    echo -n -e "\\033[1;31m检测本地面具资源...\\033[0m"
    sleep 0.5
    if [ -f "$binPath/\$magisk_file" ]; then
      echo  "本地存在对应版本Magisk"
    else
      echo  "未发现本地Magisk"
      echo  "正在下载中..."
      curl "$fileurl/android/magisk/\$magisk_file" -o $binPath/\$magisk_file
    fi
    echo -n  -e  "\\033[1;31m集成中...\\033[0m"
    mkdir -p \$CUR_PRO/UnpackedRom/META-INF/com/google/android/Magisk
    cp -f $binPath/\$magisk_file \$CUR_PRO/UnpackedRom/META-INF/com/google/android/Magisk/Magisk.zip
    echo "集成完成"
    sleep 0.5
    lineWhich=`cat \$CUR_PRO/UnpackedRom/META-INF/com/google/android/updater-script | \\
    grep -n set_progress | \\
    awk -F ":" '{print \$1}'`
    echo \$lineWhich
    echo -n  -e  "\\033[1;31m添加刷机脚本中...\\033[0m"
    sed -i "\$lineWhich"' i\\run_program("/sbin/sh", "/tmp/script.sh", "dummy", "1", "/tmp/script.sh");' \\
    \$CUR_PRO/UnpackedRom/META-INF/com/google/android/updater-script
    sed -i "\$lineWhich"' i\\package_extract_file("META-INF/com/google/android/Magisk/Magisk.zip", "/tmp/Magisk.zip");' \\
    \$CUR_PRO/UnpackedRom/META-INF/com/google/android/updater-script
    sed -i "\$lineWhich"' i\\package_extract_file("META-INF/com/google/android/Magisk/script.sh", "/tmp/script.sh");' \\
    \$CUR_PRO/UnpackedRom/META-INF/com/google/android/updater-script
    sed -i "\$lineWhich"' i\\ui_print("- 安装Magisk_ROOT权限...");' \\
    \$CUR_PRO/UnpackedRom/META-INF/com/google/android/updater-script
    echo '
    #!/sbin/sh
    # mount -o rw /system || mount -o rw,remount /system
    # mount -o rw /system_root || mount -o rw,remount /system_root
    mkdir -p /tmp/magisk/
    cd /tmp/magisk/
    cp /tmp/Magisk.zip /tmp/magisk/magisk.zip
    unzip /tmp/magisk/magisk.zip
    /sbin/busybox sh /tmp/magisk/META-INF/com/google/android/update-binary dummy 1 /tmp/magisk/magisk.zip
    rm -rf /data/system/package_cache/*
    mount -o rw /cust || mount -o rw,remount /cust
    rm -rf /cust/app
    cp /tmp/Magisk.zip /cust/magisk.zip
    for list in `ls -d /data/adb/modules/*`; do
      touch \$list/disable
    done
    mount -o rw /persist || mount -o rw,remount /persist
    cp /tmp/Magisk.zip /persist/magisk.zip
    ' > \$CUR_PRO/UnpackedRom/META-INF/com/google/android/Magisk/script.sh
    sleep 0.5
    echo "添加完成"
  }
  """;

  return _tmp;
}

String checkApktoolFramework() {
  String _tmp;
  _tmp = '''
  function checkApktoolFramework(){
    if [ -f "\$NIGHTMARE_PATH/YanTool/Apktool/Framework/1.apk" ]; then
      echo -e "\\033[1;31m存在框架\\033[0m"
    else
      echo -e  "\\033[1;31m未发现框架,导入框架中\\033[0m"
      apkPath=`find \$CUR_PRO/UnpackedImg/system -name "framework-res.apk"`
      apktool if \$apkPath -p \$NIGHTMARE_PATH/YanTool/Apktool/Framework/
      apkPath=`find \$CUR_PRO/UnpackedImg/system -name "framework-ext-res.apk"`
      apktool if \$apkPath -p \$NIGHTMARE_PATH/YanTool/Apktool/Framework/
      apkPath=`find \$CUR_PRO/UnpackedImg/system -name "miuisystem.apk"`
      apktool if \$apkPath -p \$NIGHTMARE_PATH/YanTool/Apktool/Framework/
      apkPath=`find \$CUR_PRO/UnpackedImg/system -name "miui.apk"`
      apktool if \$apkPath -p \$NIGHTMARE_PATH/YanTool/Apktool/Framework/
      
    fi
  }
  ''';
  return _tmp;
}

String crackShowSecond() {
  String _tmp;
  _tmp = '''
  ${checkApktoolFramework()}
  function crackShowSecond1(){
    checkApktoolFramework
    aapt_auto
    zip_auto
    SystemUIPath=`find \$CUR_PRO/UnpackedImg/system -name "MiuiSystemUI.apk"`
    echo -e "\\033[1;31m反编译状态栏中\\033[0m"
    apktool d \$SystemUIPath \\
    -f -o \\
    $tmpPath/SystemUI \\
    -p \$NIGHTMARE_PATH/YanTool/Apktool/Framework
    if [ ! -f \"$filesPath/usr/bin/Nosdex\" ]; then
      echo -e "\\033[1;31m未发现Nosdex,下载中\\033[0m"
      mkdir $filesPath/usr/python >/dev/null 2>&1
      curl $fileurl/Rom/bin/Nosdex -o $filesPath/usr/bin/Nosdex
    fi
    echo -e "\\033[1;31m提取Nos的dex\\033[0m"
    baksmali d $binPath/Nosdex -o $tmpPath/SystemUI/smali
  }
  function crackShowSecond2(){
    echo -e  "\\033[1;31m对反编译后的状态栏进行代码插桩\\033[0m"
    if [ ! -f \"$filesPath/usr/python/PatchSystemUI.py\" ]; then
      echo -e "\\033[1;31m第一次使用，下载补丁算法\\033[0m"
      mkdir $filesPath/usr/python >/dev/null 2>&1
      busybox wget $fileurl/Rom/PatchSystemUI.py -O $filesPath/usr/python/PatchSystemUI.py >/dev/null 2>&1
    fi
    python3 $filesPath/usr/python/PatchSystemUI.py $tmpPath/SystemUI
    echo -e  "\\033[1;31m回编译状态栏\\033[0m"

    apktool b -f \\
    $tmpPath/SystemUI \\
    -o \\
    $tmpPath/SystemUI.apk \\
    -p \$NIGHTMARE_PATH/YanTool/Apktool/Framework
  }
  function crackShowSecond3(){
    echo -e  "\\033[1;31m整合状态栏\\033[0m"
    #cp -rf ../bin/BuildFile/assets ./
    #zip -r MiuiSystemUI.apk assets
    rm -rf $tmpPath/MiuiSystemUI.apk
    cp -f \$SystemUIPath $tmpPath/MiuiSystemUI.apk
    cd $tmpPath/SystemUI/build/apk
    zip ../../../MiuiSystemUI.apk res/layout/quick_status_bar_expanded_header.xml
    zip ../../../MiuiSystemUI.apk res/layout/status_bar_contents_clock.xml
    zip ../../../MiuiSystemUI.apk classes.dex
    cp -f $tmpPath/MiuiSystemUI.apk \$SystemUIPath 
  }

  ''';
  return _tmp;
}
//打包Img的脚本

String simg2Img(String filepath) {
  return '''function Simg2img(){
                rom-tool_auto
                echo -n -e '\\033[1;31m转换中...\\033[0m'
                $loadingPrifix '
                $binPath/simg2img $filepath ${File(filepath).parent.path}/system.rimg\n 2>>\$CUR_PRO/error_log.txt
                '
                echo 转换结束
              }''';
}

String img2Simg(String filepath) {
  final String _name = filepath.replaceAll(RegExp('.*/|\\..*'), '');
  return '''
                              function img2Simg(){
                                touch $termLockFilePath
                                rom-tool_auto
                                echo -n -e '\\033[1;31m转换中...\\033[0m'
                                $loadingPrifix '
                                img2simg $filepath ${File(filepath).parent.path}/$_name.simg\n 2>>\$CUR_PRO/error_log.txt
                                '
                                echo 已转换至${File(filepath).parent.path}/$_name.simg
                                $exitScript
                              }
                              ''';
}

String mke2fsRepack(String simg) {
  String _sh;
  if (Platform.isAndroid) {
    _sh = """
  function repackImg()
  {
    touch $termLockFilePath
    rom-tool_auto
    echo -e "\\033[1;34m使用新方案打包...\\033[0m"
    chmod 777 /data/data/com.nightmare/files/lib/ld-linux-aarch64.so.1
    chmod 777 /data/data/com.nightmare/files/lib/libc.so.6
    chmod 777 /data/data/com.nightmare/files/lib/libgcc_s.so.1
    chmod 777 /data/data/com.nightmare/files/lib/libm.so.6
    chmod 777 /data/data/com.nightmare/files/lib/libpcre2-8.so.0
    chmod 777 /data/data/com.nightmare/files/lib/libpthread.so.0
    chmod 777 /data/data/com.nightmare/files/lib/libstdc++.so.6
    chmod 777 /data/data/com.nightmare/files/lib/libz.so.1
    echo -e "\\033[1;34m获取相关算法中...\\033[0m"
    cd "\$CUR_PRO/UnpackedImg"
    directorys=\$(find ./ -maxdepth 1 -type d | sed 's/.\\///g')
    for flodername in \$directorys
      do
          if [ \"\$flodername\" != \"./\" ]; then
            cd /data/data/com.nightmare/files/home/
            echo -e "\\033[1;31m清空 \$flodername 数据残留...\\033[0m"
            rm -rf /data/data/com.nightmare/files/home/\$flodername
            echo -n -e "\\033[1;31m复制 \$flodername 到数据目录...\\033[0m"
            $loadingPrifix "
            cp -rf '\$CUR_PRO/UnpackedImg/\$flodername' /data/data/com.nightmare/files/home
            "
            echo -n -e "\\033[1;31m恢复 \$flodername 符号链接...\\033[0m"
            export link_name=\$flodername'_links'
            $loadingPrifix '
            cd /data/data/com.nightmare/files/home/
            cp -rf "\$CUR_PRO/Config/\$link_name" /data/data/com.nightmare/files/home/
            sh "/data/data/com.nightmare/files/home/\$link_name" 2>/dev/null
            '
            size_name=\$flodername'_img_size'
            filesize=\$(cat "\$CUR_PRO/Config/\$size_name")
            echo 当前分区大小为\$filesize
            mkdir "\$CUR_PRO/OutFile" >/dev/null 2>&1
            touch "\$CUR_PRO/OutFile/文件的生成目录"
            if [ -d "\$CUR_PRO/UnpackedImg/\$flodername/system" ]; then
              point=/
            else
              point=\$flodername
            fi
            echo 获取fs补丁算法
            curl $fileurl/python/fs_config_add.py -o /data/data/com.nightmare/files/usr/python/fs_config_add.py
            echo 补丁中
            fs_name=\$flodername'_fs_config'
            python /data/data/com.nightmare/files/usr/python/fs_config_add.py \\
            "\$CUR_PRO/Config/\$fs_name" \\
            /data/data/com.nightmare/files/home/\$flodername \\
            \$point
            cp -rf "\$CUR_PRO/Config" /data/data/com.nightmare/files/home/
            echo -e "\\033[1;31m生成 \$flodername.img中...\\033[0m"
            con_name=\$flodername'_file_contexts'
            cd /data/data/com.nightmare/files/
            export PATH=/data/data/com.nightmare/files/usr/bin:\$PATH
            mkuserimg_mke2fs.sh /data/data/com.nightmare/files/home/\$flodername "\$NIGHTMARE_PATH/YanTool/Rom/\$flodername.img" ext4 \$point \$filesize -T 1230768000 -C "/data/data/com.nightmare/files/home/Config/\$fs_name" -L \$point "/data/data/com.nightmare/files/home/Config/\$con_name"
            if [ -e \$NIGHTMARE_PATH/YanTool/Rom/\$flodername.img ]; then
              echo -e "\\033[1;32m打包成功\\033[0m"
            else
              echo -e "\\033[1;33m打包失败\\033[0m"
              return
              #kill -9 \$\$
            fi
              
            if [ "$simg" !=  "" ]; then
              echo -n -e '\\033[1;31m转换为simg中...\\033[0m'
              export flodername=\$flodername
              $loadingPrifix '
              img2simg "\$NIGHTMARE_PATH/YanTool/Rom/\$flodername.img" "\$CUR_PRO/OutFile/\$flodername.img"
              rm -rf \$NIGHTMARE_PATH/YanTool/Rom/\$flodername.img
              '
            else
              echo -e "\\033[1;31m移动\$flodername.img到OutFile...\\033[0m"
              mv -f \$NIGHTMARE_PATH/YanTool/Rom/\$flodername.img "\$CUR_PRO/OutFile/\$flodername.img"
            fi
            echo 清空本次使用的数据目录\$flodername...
            #rm -rf /data/data/com.nightmare/files/\$flodername.img
            #rm -rf /data/data/com.nightmare/files/home/\$flodername
          fi
      done
      echo 打包结束。
      $exitScript
  }
  """;
  } else if (Platform.isLinux) {
    _sh = """
  function repackImg()
  {
    touch $termLockFilePath
    busybox wget $fileurl/fs_config_add.py -O ${filesPath}/usr/python/fs_config_add.py >/dev/null 2>&1
    cd \$CUR_PRO/UnpackedImg
    directorys=\$(find ./ -maxdepth 1 -type d | sed 's/.\\///g')
    for flodername in \$directorys
      do
          if [ \"\$flodername\" != \"./\" ]; then
            #cd /data/data/com.nightmare/files/home/
            echo -n -e "\\033[1;31m恢复 \$flodername 符号链接...\\033[0m"
            $loadingPrifix "
            sh \$CUR_PRO/Config/\$flodername'_links' >/dev/null 2>&1
            "
            filesize=\$(cat \$CUR_PRO/Config/\$flodername'_size')
            echo 当前分区大小为\$filesize
            mkdir \$CUR_PRO/OutFile >/dev/null 2>&1
            touch \$CUR_PRO/OutFile/文件的生成目录
            if [ -d "\$CUR_PRO/UnpackedImg/\$flodername/system" ]; then
              point=/
            else
              point=\$flodername
              # cp -rf \$CUR_PRO/Config/\$flodername'_fs_config' /data/data/com.nightmare/files/home/
              # python ${filesPath}/usr/python/fs_config_add.py \$flodername
              #mv -f /data/data/com.nightmare/files/home/\$flodername'_fs_config' \$CUR_PRO/Config/
            fi
            echo "\033[1;31m生成 \$flodername.img中...\033[0m"
            make_ext4fs -L \$point -T 1230739200$simg -S \$CUR_PRO/Config/\$flodername'_file_contexts' -C \$CUR_PRO/Config/\$flodername'_fs_config' -l \$filesize -a \$point \$CUR_PRO/OutFile/\$flodername.img \$flodername
          fi
      done
      echo 打包结束。
      $exitScript
  }
  """;
  }

  return _sh;
}

String addMd5(String name) {
  return '''
    function addMd5(){
      echo -n "\x1b[1;31m计算md5中...\x1b[0m"
      md5=`md5sum \$CUR_PRO/UnpackedRom/$name.zip`
      mv \$CUR_PRO/UnpackedRom/$name.zip \$CUR_PRO/UnpackedRom/$name\_\${md5:0:9}.zip
      echo "已添加到文件名末尾"
    }
    ''';
}

String addVendorSize = () {
  return '''
    function addVendorSize(){
      dir_size_path="\$CUR_PRO/Config/vendor_dir_size"
      img_size_path="\$CUR_PRO/Config/vendor_img_size"
      dir_size=\$(cat \$dir_size_path)
      img_size=\$(cat \$img_size_path)
      echo 补丁前的大小为 \$img_size
      cur_size=\$(expr \$dir_size + 25165824)
      echo 补丁后的大小为 \$cur_size
      sed -i "s/\$img_size/\$cur_size/g" \$img_size_path
      sed -i "s/\$img_size/\$cur_size/g" "\$CUR_PRO/UnpackedRom/dynamic_partitions_op_list"
    }
    ''';
}();
String deleteAvb = () {
  return '''
function deleteAvb(){
  if [ ! -f "$filesPath/usr/python/delete_avb.py" ]; then
    echo  -e  "\\033[1;31m未发现avb算法，下载中\\033[0m"
    mkdir $filesPath/usr/python >/dev/null 2>&1
    curl "$fileurl/Rom/python/delete_avb.py" -o $filesPath/usr/python/delete_avb.py
  fi
    echo -e "\\033[1;31m>>> 去除vendor分区avb\\033[0m"
    fstab=\$CUR_PRO/UnpackedImg/vendor/etc/fstab.qcom
    #echo \$fstab
    python3 "$filesPath/usr/python/delete_avb.py" \$fstab
    echo -e "\\033[1;31m<<< 去除结束\\033[0m"
}
''';
}();
String zipAlign = () {
  String _tmp = '';
  _tmp = '''
function zipAlign(){
  zipalign_auto
  echo -e "\\033[1;31m执行优化\\033[0m"
  allApks=`find \$CUR_PRO/UnpackedImg -name \"*.apk\"`
  for apk in \$allApks\n
  do
    echo  "- \${apk##*/}..."
    zipalign -c 4 \$apk
  done
  echo -e "\\033[1;31m优化化束\\033[0m"
}
''';
  return _tmp;
}();
String deleteAdScript = () {
  //用于一键
  final List<String> dataApp = <String>[
    'XMPass',
    'WaliLive',
    'Userguide',
    'SmartHome',
    'O2O',
    'MiTalk',
    'MiShop',
    'MiMobileNoti',
    'MiLiveAssistant',
    'mihome',
    'MiFinance',
    'GameCenter',
    'Email',
    'ctrip.android.view',
    'com.zhihu.android',
    'com.ximalaya.ting.android',
    'com.xiaomi.youpin',
    'Youpin',
    'com.wuba',
    'com.tmall.wireless',
    'com.taobao.taobao',
    'com.suning.mobile.ebuy',
    'com.sina.weibo',
    'com.Qunar',
    'com.eg.android.AlipayGphone',
    'com.achievo.vipshop',
    'cn.wps.moffice_eng',
    'com.xunmeng.pinduoduo',
    'com.UCMobile',
    'com.baidu.haokan',
    'Huanji',
    'MiFinance',
    'XiaomiJrSecurity',
    'com.taobao.taobao_24',
    'com.Qunar_18',
    'com.sina.weibo_16',
    'com.eg.android.AlipayGphone_23',
    'com.xunmeng.pinduoduo_19',
    'com.achievo.vipshop_4',
    'com.baidu.searchbox_9',
    'com.ss.android.article.news_76',
    'com.wuba_96_miuiAdvancePreload',
    'GoogleContactsSyncAdapter',
    'tv.danmaku.bili_26',
  ];
  final List<String> privApp = <String>[
    // 'MiuiVideo',
    'MiGameCenterSDKService',
    'MiRcs',
  ];
  final List<String> app = <String>[
    'AnalyticsCore',
    'BackupAndRestore',
    'BasicDreams',
    'mab',
    // 'Mipay',
    // 'Updater',
  ];
  final List<String> verdorDataApp = <String>[
    'SmartHome',
    'wps-lite',
    'XMRemoteController',
    'YouPin',
    'Health'
  ];
  String deleteScript = '';

  deleteScript += '''
if [ -d \"\$CUR_PRO/UnpackedImg/system/system\" ]; then
  systemroot=\$CUR_PRO/UnpackedImg/system/system
else
  systemroot=\$CUR_PRO/UnpackedImg/system
fi
''';
  dataApp.forEach((String value) {
    deleteScript += "echo '- $value'\n" 'rm -rf \$systemroot/data-app/$value\n';
  });
  privApp.forEach((value) {
    deleteScript += "echo '- $value'\n" 'rm -rf \$systemroot/priv-app/$value\n';
  });
  app.forEach((value) {
    deleteScript += "echo '- $value'\n" 'rm -rf \$systemroot/app/$value\n';
  });
  verdorDataApp.forEach((value) {
    deleteScript += "echo '- $value'\n"
        'rm -rf \$CUR_PRO/UnpackedImg/vendor/data-app/$value\n';
  });
  deleteScript += "echo '- recovery-from-boot.p'\n"
      'rm -rf \$systemroot/recovery-from-boot.p\n';
  // File("/sdcard/123.txt").writeAsStringSync(deleteScript);
  // Log.d(deleteScript);
  return '''
  function deleteAd(){
    echo -e "\\033[1;31m执行删除中\\033[0m"
    $deleteScript
    echo -e "\\033[1;31m执行删除结束\\033[0m"
  }
  ''';
}();

String replaceVbmeta = () {
  return '''
    function replaceVbmeta(){
    if [ -f "\$CUR_PRO/UnpackedRom/firmware-update/vbmeta.img" ]; then
      echo 发现vbmeta分区
      if [ ! -f "${binPath}/vbmeta.img" ]; then
        echo  -e  "\\033[1;31m未发现可替换的avb,下载中\\033[0m"
        busybox wget $fileurl/Rom/vbmeta.img -O ${binPath}/vbmeta.img >/dev/null 2>&1
      fi
      echo 替换vbmeta分区中
      cp -f ${binPath}/vbmeta.img \$CUR_PRO/UnpackedRom/firmware-update/vbmeta.img
      echo 替换vbmeta结束
    else
      echo 未发现vbmeta.img分区
    fi   
    }

    ''';
}();
