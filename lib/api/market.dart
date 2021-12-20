
import 'package:dio/dio.dart';
import 'package:wq_fotune/model/base_resp.dart';

import 'http_utils.dart';

class MarketApi {
  /// 获取交易所信息
  static Future<BaseResp> getKline({String symbol, String interval}) async {
    var url = "quote/v1/kline?symbol=${symbol.toLowerCase()}&period=$interval" ;
    var response = await Http().get(url);
    var res = BaseResp.fromJson(response);
    return res;
  }
}