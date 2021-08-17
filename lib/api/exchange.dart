import 'package:wq_fotune/model/base_resp.dart';

import 'http_utils.dart';

class ExchangeApi {
  //策略列表
  static Future<BaseResp> getStrategies(pageNum, pageSize) async {
    var url = "exchange/v1/strategies/$pageNum/$pageSize";
    var response = await Http().get(url);
    var res = BaseResp.fromJson(response);
    return res;
  }

//策略详情
  static Future<BaseResp> getStrategyDetail(id) async {
    var url = "exchange/v1/strategy/detail/$id";
    var response = await Http().get(url);
    var res = BaseResp.fromJson(response);
    return res;
  }

  static Future<BaseResp> createStrategy(params) async {
    var url = "exchange/v1/user/strategy/create";
    var response = await Http().post(url, data: params);
    var res = BaseResp.fromJson(response);
    return res;
  }

//http 行情接口 获取所有品种行情
  static Future<BaseResp> getTicks() async {
    var url = "quote/v1/ticks";
    var response = await Http().get(url);
    var res = BaseResp.fromJson(response);
    return res;
  }

  static Future<BaseResp> getExchangeAssert() async {
    var url = "exchange/v1/user/exchange/assert";
    var response = await Http().get(url);
    var res = BaseResp.fromJson(response);
    return res;
  }

//推荐策略
  static Future<BaseResp> getExchangeSymbolRank() async {
    var url = "exchange/v1/exchange/symbolRank";
    var response = await Http().get(url);
    var res = BaseResp.fromJson(response);
    return res;
  }
}
