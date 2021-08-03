import 'package:wq_fotune/model/base_resp.dart';

import 'http_utils.dart';

//用户策略列表
Future<BaseResp> getExchangeOrderUserStrategy() async {
  var url = "exchange-order/user/strategy";
  var response = await Http().get(url);
  var res = BaseResp.fromJson(response);
  return res;
}

//用户策略详情
Future<BaseResp> getStrategyDetail(strategy_id) async {
  var url = "exchange-order/user/strategy/detail/$strategy_id";
  var response = await Http().get(url);
  var res = BaseResp.fromJson(response);
  return res;
}

//盈亏列表
Future<BaseResp> getStrategyProfit(trategyId) async {
  var url = "exchange-order/user/strategy/profit/$trategyId";
  var response = await Http().get(url);
  var res = BaseResp.fromJson(response);
  return res;
}

//交易记录列表
Future<BaseResp> getUserTrade(strategyid, pagenum, pagesize) async {
  var url = "exchange-order/user/trade/$strategyid/$pagenum/$pagesize";
  var response = await Http().get(url);
  var res = BaseResp.fromJson(response);
  return res;
}

//设置初始资金
Future<BaseResp> SetBalance(params) async {
  var url = "exchange-order/user/strategy/set/balance";
  var response = await Http().put(url, data: params);
  var res = BaseResp.fromJson(response);
  return res;
}

//设置api
Future<BaseResp> SetApi(params) async {
  var url = "exchange-order/user/strategy/set/api";
  var response = await Http().put(url, data: params);
  var res = BaseResp.fromJson(response);
  return res;
}

Future<BaseResp> runStrategy(params) async {
  var url = "exchange-order/user/strategy/run";
  var response = await Http().put(url, data: params);
  var res = BaseResp.fromJson(response);
  return res;
}

//获取可交易品种
Future<BaseResp> getSymbols(exchange) async {
  var url = "exchange-order/exchange/symbols/$exchange/usdt";
  var response = await Http().get(url);
  var res = BaseResp.fromJson(response);
  return res;
}

//计算网格总共需要资金(启动策略前使用)
Future<BaseResp> postGridCalculateMoney(params) async {
  var url = "grid/strategy/grid/calculateMoney";
  var response = await Http().post(url, data: params);
  var res = BaseResp.fromJson(response);
  return res;
}

//新的用户策略列表
Future<BaseResp> getStrategyList(uid, page, limit) async {
  var url = "grid/strategy/list?uid=$uid&page=$page&limit=$limit";
  var response = await Http().get(url);
  var res = BaseResp.fromJson(response);
  return res;
}

//获取策略类型列表
Future<BaseResp> getStrategyTypes(page, limit) async {
  var url = "grid/strategy/types?page=$page&limit=$limit";
  var response = await Http().get(url);
  var res = BaseResp.fromJson(response);
  return res;
}

//启动网格交易策略
Future<BaseResp> postGridStartup(params) async {
  var url = "grid/strategy/grid/startup";
  var response = await Http().post(url, data: params);
  var res = BaseResp.fromJson(response);
  return res;
}

//停止网格交易策略
Future<BaseResp> postGridStop(params) async {
  var url = "grid/strategy/grid/stop";
  var response = await Http().post(url, data: params);
  var res = BaseResp.fromJson(response);
  return res;
}

//获取策略详情(网格策略)
Future<BaseResp> getStrategyDetails(id) async {
  var url = "grid/strategy/detail/$id";
  var response = await Http().get(url);
  var res = BaseResp.fromJson(response);
  return res;
}

//获取最小投入资金
Future<BaseResp> getMinMoney(params) async {
  var url = "grid/strategy/grid/auto/minMoney";
  params['exchange'] = params['exchange'].toString().toLowerCase();
  var response = await Http().get(url, queryParameters: params);
  var res = BaseResp.fromJson(response);
  return res;
}

//根据投入资金自动生成网格参数
Future<BaseResp> getGridParams(params) async {
  var url = "grid/strategy/grid/auto/gridParams";
  params['exchange'] = params['exchange'].toString().toLowerCase();
  print("getGridParams = $params");
  var response = await Http().get(url, queryParameters: params);
  var res = BaseResp.fromJson(response);
  return res;
}

//根据最低价和利润率生成网格参数(无限网格使用)
Future<BaseResp> getAutoGridParams(Map<String, dynamic> params) async {
  var url = 'grid/strategy/bigGrid/auto/gridParams';
  print("getAutoGridParams = $params");
  var response = await Http().get(url, queryParameters: params);
  var res = BaseResp.fromJson(response);
  return res;
}

//获取策略简要信息
Future<BaseResp> getStrategySimple(id) async {
  var url = "grid/strategy/simple/" + id;
  var response = await Http().get(url);
  var res = BaseResp.fromJson(response);
  return res;
}

Future<BaseResp> postStrategyGridUpdate(params) async {
  var url = "grid/strategy/grid/update";
  var response = await Http().post(url, data: params);
  var res = BaseResp.fromJson(response);
  return res;
}
