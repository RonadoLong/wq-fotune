import 'dart:async';
import 'dart:convert';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wq_fotune/api/common.dart';
import 'package:wq_fotune/api/exchange.dart';
import 'package:wq_fotune/model/user_info.dart';

import 'common/EventBus.dart';
import 'common/load_recommned.dart';
import 'utils/ui_data.dart';
import 'utils/device_utils.dart';
import 'utils/update_manager.dart';

// 提供五套可选主题色
const _themes = <MaterialColor>[
  Colors.blue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.red,
];

class HttpStatus {
  static const int success = 10000;
  static const int fail = 99999;
}

class EventUtils {
  // 自定义键盘下一项事件
  static const KeyBoardNextEventKey = "KeyBoardNextEventKey";
  // 键盘整单事件
  static const KeyBoardOrderEventKey = "KeyBoardOrderEventKey";
  // 切换键盘单位的事件 {"inputLeftText": "", "inputRightText": ""}
  static const KeyBoardChangeTextEventKey = "KeyBoardChangeTextEventKey";
  // 初始化按钮事件
  static const KeyBoardInitEventKey = "KeyBoardInitEventKey";
  // 初始化完毕事件
  static const KeyBoardFinishEventKey = "KeyBoardFinishEventKey";
  // 初始化完毕事件
  static const KeyBoardConfirmEventKey = "KeyBoardConfirmEventKey";
}


Map globalCacheMarketData; //行情数据

class Global {
  static SharedPreferences _prefs;

  static UserInfo userInfo;

  static Color primaryColor = UIData.primary_color;

  static EventBus get eventBus => new EventBus(); //事件

// 网络缓存对象
//static NetCache netCache = NetCache();

// 可选的主题列表
  static List<MaterialColor> get themes => _themes;

// 是否为release版
  static bool get isRelease => bool.fromEnvironment("dart.vm.product");

  static bool isShowVersion = true;

//初始化全局信息，会在APP启动时执行
  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
    userInfo = getUserInfo();
    getRecommend();
    // WebSocketManager.connectWS();

    LogUtil.init(isDebug: true);
    initLoading();

    _getTick();
  }

  static initLoading() {
    EasyLoading.instance
      ..maskType = EasyLoadingMaskType.custom
      ..radius = 10
      ..fontSize = 16
      ..textColor = UIData.default_color
      ..loadingStyle = EasyLoadingStyle.light
      ..maskColor = Colors.black.withOpacity(0.5)
      ..displayDuration = const Duration(seconds: 1)
      ..errorWidget = Container(
        child: Icon(
          Icons.cancel,
          color: UIData.red_color,
          size: 40,
        ),
      )
      ..infoWidget = Container(
        child: Icon(
          Icons.info,
          color: UIData.primary_color,
          size: 40,
        ),
      );
  }

  static Future<bool> clearUserInfoCache() {
    userInfo = null;
    return _prefs.clear();
  }

  static bool isLogin() {
    return Global.getUserInfo() != null;
  }

  static UserInfo getUserInfo() {
    if (_prefs == null) {
      return null;
    }
    dynamic user = _prefs.getString("userInfo");
    if (user == null || user == "") {
      return null;
    }
    Map<String, dynamic> userJson = json.decode(user);
    return UserInfo.fromJson(userJson);
  }

  static Future<bool> saveUserInfo(UserInfo user) {
    userInfo = user;
    String userStr = json.encode(user);
    return _prefs.setString("userInfo", userStr);
  }

  static void log(dynamic msg, {String tag}) {
    LogUtil.e(msg, tag: tag);
  }

  static void logDev(dynamic msg, {String tag}) {
    LogUtil.v(msg, tag: tag);
  }

  static void changeWinPrimaryColor() {
    primaryColor = UIData.win_color;
  }

  static void changeBluePrimaryColor() {
    primaryColor = UIData.primary_color;
  }

  static void startTimerCheckVersion(context) async {
    if (!Device.isWeb && isRelease) {
      return;
    }
    checkVersion(context);
    Timer.periodic(Duration(minutes: 1), (timer) {
      if (isShowVersion && isRelease) {
        checkVersion(context);
      }
    });
  }

  static void checkVersion(context) async {
    var params = Device.isAndroid ? 1 : 2;
    CommonApi.getAppVersion(params).then((res) async {
      if (res.code == 0) {
        // PackageInfo packageInfo = await PackageInfo.fromPlatform();
        // String version = packageInfo.version;
        // print("${res.data["versionName"]} ======= $version");
        // if (res.data["versionName"] == version) {
        //   return;
        // }
        // if (res.data["isIgnorable"] == true) {
        //   return;
        // }
        // isShowVersion = false;
        // UpdateManager.openURL(context, res.data);
      }
    });
  }

  static _getTick() async {
    //获取行情
    getTick();
  }

  static getTick() async {
    ExchangeApi.getTicks().then((res) {
      if (res.code == 0) {
        globalCacheMarketData = res.data;
        Global.eventBus.emit("refreshMarket", res.data);
      } else {
        globalCacheMarketData = {};
      }
    }).catchError((onError) {
      print(onError);
      globalCacheMarketData = {};
    });
    const timeout = const Duration(seconds: 5);
    Future.delayed(timeout, () => {getTick()});
  }
}
