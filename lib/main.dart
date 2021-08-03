// This sample shows adding an action to an [AppBar] that opens a shopping cart.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:wq_fotune/global.dart';
import 'package:wq_fotune/main_page.dart';
import 'package:wq_fotune/page/home/home_page.dart';
import 'package:wq_fotune/page/home/strategy_details.dart';
import 'package:wq_fotune/page/login/login_page.dart';
import 'package:wq_fotune/page/login/register_page.dart';
import 'package:wq_fotune/page/mine/exchange_manager.dart';
import 'package:wq_fotune/page/mine/recharge_page.dart';
import 'package:wq_fotune/utils/ui_data.dart';
import 'package:wq_fotune/utils/device_utils.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Global.init().then((e) => runApp(MainApp()));
}

void initUtils() async {
  try {
    // 设置状态栏
    if (Device.isIOS) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    }

    if (Device.isAndroid) {
      SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.light);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }
  } catch (_) {}
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    initUtils();
    return MaterialApp(
      title: UIData.appName,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            try {
              SystemChannels.textInput.invokeMethod('TextInput.hide');
            } catch (e) {
              print("${e}");
            }
          },
          child: FlutterEasyLoading(
            child: MaterialApp(
              home: child,
              debugShowCheckedModeBanner: false,
              theme: new ThemeData(
                visualDensity: VisualDensity.adaptivePlatformDensity,
                brightness: Brightness.light,
                primaryColor: UIData.primary_color,
                backgroundColor: Colors.white,
              ),
            ),
          ),
        );
        // return FlutterEasyLoading(child: MaterialApp(home: child,));
      },
      home: MainPageWidget(),
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/strategyDetails': (context) => StrategyDetails(),
        '/register': (context) => RegisterPage(),
        '/exchange': (context) => ExchangeM(),
        '/recharge': (context) => RechargePage(),
      },
    );
  }
}
