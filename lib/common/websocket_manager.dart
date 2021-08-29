import 'dart:convert';

import 'package:flustars/flustars.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:wq_fotune/global.dart';
import 'package:wq_fotune/model/ticker.dart';
import 'package:wq_fotune/page/common/CommonWidget.dart';

/// todo 运行web的时候打开
//import 'package:web_socket_channel/html.dart';

/// todo 运行手机的时候打开
import 'package:web_socket_channel/io.dart';

class WebSocketManager {
  static WebSocketChannel channel;
  // String url = "wss://www.ifortune.io/api/v1/quote/ticks/realtime";
  static String url = 'wss://yun.mateforce.cn/test/quote/v1/ticks/realtime';

  static WebSocketChannel initializeWebSocketChannel(String url) {
    /// todo 运行手机的时候打开
    return IOWebSocketChannel.connect(url);

    /// todo 运行web的时候打开
//     return HtmlWebSocketChannel.connect(url);
  }

  static void initChannel(String url) {
    url = url;
    channel = initializeWebSocketChannel(url);
  }

  static connectWS() async {
    initChannel(url);
    channel.stream.listen((message) {
      if (message != null) {
        Map resp = json.decode(message);
        var data = resp["data"];
        if (data == null) {
          return;
        }
        var dataList = new List<Ticker>();
        for (var item in data) {
          var t = Ticker.fromJson(item);
          SpUtil.putObject(t.symbol, t);
          dataList.add(t);
        }
        handleRefresh(() {
          Global.eventBus.emit("refreshMarket", dataList);
        });
      }
    }, onError: (err) {
      print("链接失败， 重连, ${err.toString()}");
      handleRefreshWithDuration(() {
        connectWS();
      }, Duration(seconds: 5));
    }, onDone: () {});
  }
}
