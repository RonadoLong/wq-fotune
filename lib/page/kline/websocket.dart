
import 'dart:convert';

import 'package:wq_fotune/common/EventBus.dart';
import 'package:wq_fotune/global.dart';
import 'package:wq_fotune/model/kline.dart';
import 'package:wq_fotune/page/common/CommonWidget.dart';
import 'package:wq_fotune/page/kline/web_socket_utility.dart';
bool inProduction = const bool.fromEnvironment("dart.vm.product");
String purl = 'wss://yun.mateforce.cn/test/quote/v1/ws?uid=';
String turl = 'ws://192.168.5.3:9530/quote/v1/ws?uid=';

class WebSocketUtils {
  String url = "";
  WebSocketUtils(String userId) {
    DateTime now = DateTime.now();
    purl = purl + (userId ?? now.millisecond.toString());
    turl = turl + (userId ?? now.millisecond.toString());
    url = inProduction ? purl : turl ;
  }

  void initChannel() {
    WebSocketUtility(this.url).initWebSocket(onOpen: () {
      WebSocketUtility(this.url).initHeartBeat();
    }, onMessage: (data) {
      final parseJson = json.decode(data);
      if (parseJson is int) {
        return;
      }
      Kline kline = Kline.fromJson(parseJson);
      if (!kline.symbol.contains("1m")) {
        print("${kline.toJson()}");
      }
      Global.eventBus.emit("refresh_kline", kline);
    }, onError: (e) {
      print(e);
    });
  }
}
