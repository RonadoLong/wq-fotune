import 'package:wq_fotune/model/base_resp.dart';

import 'http_utils.dart';

Future<BaseResp> commonCarousels() async {
  var url = "common/carousels";
  var response = await Http().get(url);
  var res = BaseResp.fromJson(response);
  return res;
}

//策略列表
Future<BaseResp> getStrategies(pageNum, pageSize) async {
  var url = "exchange-order/strategies/$pageNum/$pageSize";
  var response = await Http().get(url);
  var res = BaseResp.fromJson(response);
  return res;
}

//策略详情
Future<BaseResp> getStrategyDetail(id) async {
  var url = "exchange-order/strategy/detail/$id";
  var response = await Http().get(url);
  var res = BaseResp.fromJson(response);
  return res;
}

Future<BaseResp> createStrategy(params) async {
  var url = "exchange-order/user/strategy/create";
  var response = await Http().post(url, data: params);
  var res = BaseResp.fromJson(response);
  return res;
}

//http 行情接口 获取所有品种行情
Future<BaseResp> getTicks() async {
  var url = "quote/ticks";
  var response = await Http().get(url);
  var res = BaseResp.fromJson(response);
  return res;
}

Future<BaseResp> getExchangeAssert() async {
  var url = "exchange-order/user/exchange/assert";
  var response = await Http().get(url);
  var res = BaseResp.fromJson(response);
  return res;
}

//推荐策略
Future<BaseResp> getExchangeSymbolRank() async {
  var url = "exchange-order/exchange/symbolRank";
  var response = await Http().get(url);
  var res = BaseResp.fromJson(response);
  return res;
}
