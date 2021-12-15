import 'package:wq_fotune/model/base_resp.dart';
import 'http_utils.dart';

class MineAPI {
  /// 获取交易所信息
  static Future<BaseResp> getExchangeInfo() async {
    var url = "exchange/v1/exchange/info";
    var response = await Http().get(url);
    var res = BaseResp.fromJson(response);
    return res;
  }

  /// apikey列表
  static Future<BaseResp> getExchangeApiList() async {
    var url = "exchange/v1/exchange/api/list";
    var response = await Http().get(url);
    print("$response");
    var res = BaseResp.fromJson(response);
    return res;
  }

  /// 用户添加apikey
  static Future<BaseResp> addExchangeOrderApi(params) async {
    var url = "exchange/v1/api/add";
    var response = await Http().post(url, data: params);
    var res = BaseResp.fromJson(response);
    return res;
  }

  /// 删除apikey
  static Future<BaseResp> delExchangeApi(id) async {
    var url = "exchange/v1/exchange/api/$id";
    var response = await Http().delete(url);
    var res = BaseResp.fromJson(response);
    return res;
  }

  /// 修改apikey
  static Future<BaseResp> updateExchangeOrderExchangeApi(params) async {
    var url = "exchange/v1/exchange/api/update";
    var response = await Http().put(url, data: params);
    var res = BaseResp.fromJson(response);
    return res;
  }

  static Future<BaseResp> getExchangeAccountList() async {
    var url = "exchange/v1/user/exchange/pos";
    var response = await Http().get(url);
    var res = BaseResp.fromJson(response);
    return res;
  }

  //usdt钱包
  static Future<BaseResp> getWalletUsdt() async {
    var url = "/wallet/v1/usdt";
    var response = await Http().get(url);
    var res = BaseResp.fromJson(response);
    return res;
  }

  //ifc钱包
  static Future<BaseResp> getWalletIfc() async {
    var url = "/wallet/v1/ifc";
    var response = await Http().get(url);
    var res = BaseResp.fromJson(response);
    return res;
  }

  //usdt充值地址
  static Future<BaseResp> usdtDepositAddr() async {
    var url = "/wallet/v1/usdt/depositAddr";
    var response = await Http().get(url);
    var res = BaseResp.fromJson(response);
    return res;
  }

  //钱包兑换提示
  static Future<BaseResp> postWalletConvertCoinTips(params) async {
    var url = "/wallet/v1/convertCoinTips";
    var response = await Http().post(url, data: params);
    var res = BaseResp.fromJson(response);
    return res;
  }

  //钱包兑换计算
  static Future<BaseResp> postWalletConvertCoin(params) async {
    var url = "/wallet/v1/convertCoin";
    var response = await Http().post(url, data: params);
    var res = BaseResp.fromJson(response);
    return res;
  }

  //钱包划转
  static Future<BaseResp> postWalletTransfer(params) async {
    var url = "/wallet/v1/transfer";
    var response = await Http().post(url, data: params);
    var res = BaseResp.fromJson(response);
    return res;
  }

  //钱包提现
  static Future<BaseResp> postWalletWithdrawal(params) async {
    var url = "/wallet/withdrawal";
    var response = await Http().post(url, data: params);
    var res = BaseResp.fromJson(response);
    return res;
  }

  //返佣接口
  static Future<BaseResp> getWalletTotalRebate() async {
    var url = "/wallet/v1/totalRebate";
    var response = await Http().get(url);
    var res = BaseResp.fromJson(response);
    return res;
  }
}
