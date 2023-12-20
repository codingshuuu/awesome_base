import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:awesome_ext/awesome_ext.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:get/get.dart';
import 'package:root_access/root_access.dart';

class Global {
  ///初始化全局信息
  ///[callback] 初始化完成回调, SP、BaseConfig、AwesomeExt、PackageUtils、屏幕像素
  ///[w] 设计稿宽度, [h] 设计稿高度, [orientation] 设备方向, 0 竖屏, 1 横屏
  ///[banRootAccess]是否判断越狱的手机，默认true，禁止越狱的手机使用
  static Future init(
    VoidCallback callback, {
    double? w,
    double? h,
    int orientation = 0,
    bool banRootAccess = true,
  }) async {
    w ??= 375.0;
    h ??= 812.0;

    //确保初始化完成才可用
    WidgetsFlutterBinding.ensureInitialized();
    //sp release初始化30毫秒，debug初始化100毫秒
    await AwesomeExt.init();
    //设计稿大小
    setDesignWHD(w, h);
    //初始化设备 在进入
    await PackageUtils.instance.init();

    callback();
    if (kReleaseMode) {
      debugPrint = (String? message, {int? wrapWidth}) {};
    }
    if (banRootAccess) {
      if (GetPlatform.isIOS) {
        final bool jailbroken = await FlutterJailbreakDetection.jailbroken;
        if (jailbroken) {
          SystemNavigator.pop();
        }
      } else if (GetPlatform.isAndroid) {
        final bool rootAccess = await RootAccess.requestRootAccess;
        if (rootAccess) {
          SystemNavigator.pop();
        }
      }
    }

    if (GetPlatform.isAndroid) {
      // 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
      const SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor: Colors.transparent);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
      if (orientation == 0) {
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      } else if (orientation == 1) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      }
    }
  }

  static Future<void> checkRootAccess() async {
    bool rootAccess = false;
    bool checkRootAccess = SpUtil.getBool('checkRootAccess', defValue: false) ?? false;
    if (GetPlatform.isIOS) {
      rootAccess = await FlutterJailbreakDetection.jailbroken;
    } else if (GetPlatform.isAndroid) {
      rootAccess = await RootAccess.requestRootAccess;
    }

    if (rootAccess && !checkRootAccess) {
      SpUtil.putBool('checkRootAccess', true);
      showDialog(
          context: Get.context!,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                '安全提示',
                style: TextStyle(color: Colors.black, fontSize: 18.sp),
              ),
              content: Text('检测到您当前设备可能已root，请注意财产安全', style: TextStyle(color: Colors.black, fontSize: 14.sp)),
              actions: <Widget>[
                MaterialButton(
                  child: Text('确定', style: TextStyle(color: Colors.blue, fontSize: 14.sp)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    }
  }

  static void setTable(double w, double h) {
    setDesignWHD(w, h);
  }
}
