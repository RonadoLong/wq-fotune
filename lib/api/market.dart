
import 'package:dio/dio.dart';

class MarketApi {
  static Future<dynamic> getSwapPrice() async {
    try {
      Response response = await Dio().get("https://www.okex.me/api/swap/v3/instruments/ticker");
      return response;
    } catch (e) {
      print(e);
      return null;
    }
  }
}