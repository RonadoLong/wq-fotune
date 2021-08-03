import 'package:wq_fotune/model/base_resp.dart';
import 'http_utils.dart';

class MineAPI {
  /// 客服联系
  /// by heqingqing 2020/05/25
  static Future<BaseResp> commonContact() async {
    var url = "/common/contact";
    var response = await Http().get(url);
    var res = BaseResp.fromJson(response);
    return res;
  }

  /// 获取交易所信息
  /// by heqingqing 2020/05/25
  static Future<BaseResp> getExchangeInfo() async {
    var url = "/exchange-order/exchange/info";
    var response = await Http().get(url);
    var res = BaseResp.fromJson(response);
    return res;
  }

  /// apikey列表
  /// by heqingqing 2020/05/25
  static Future<BaseResp> getExchangeApiList() async {
    var url = "/exchange-order/exchange/api/list";
    var response = await Http().get(url);
    var res = BaseResp.fromJson(response);
    return res;
  }

  /// 用户添加apikey
  /// by heqingqing 2020/05/26
  static Future<BaseResp> addExchangeOrderApi(params) async {
    var url = "/exchange-order/api/add";
    var response = await Http().post(url, data: params);
    var res = BaseResp.fromJson(response);
    return res;
  }

  /// 删除apikey
  /// by heqingqing 2020/05/26
  static Future<BaseResp> delExchangeApi(id) async {
    var url = "/exchange-order/exchange/api/$id";
    var response = await Http().delete(url);
    var res = BaseResp.fromJson(response);
    return res;
  }

  /// 修改apikey
  /// by heqingqing 2020/05/27
  static Future<BaseResp> updateExchangeOrderExchangeApi(params) async {
    var url = "/exchange-order/exchange/api/update";
    var response = await Http().put(url, data: params);
    var res = BaseResp.fromJson(response);
    return res;
  }

  static Future<BaseResp> getExchangeAccountList() async {
    var url = "/exchange-order/user/exchange/pos";
    var response = await Http().get(url);
    var res = BaseResp.fromJson(response);
    return res;
  }

  //获取app版本
  //by heqingqing 2020/07/09
  static Future<BaseResp> getAppVersion(params) async {
    var url = "/common/appVersion/$params";
    var response = await Http().get(url);
    var res = BaseResp.fromJson(response);
    return res;
  }

  //usdt钱包
  static Future<BaseResp> getWalletUsdt() async {
    var url = "/wallet/usdt";
    var response = await Http().get(url);
    var res = BaseResp.fromJson(response);
    return res;
  }

  //ifc钱包
  static Future<BaseResp> getWalletIfc() async {
    var url = "/wallet/ifc";
    var response = await Http().get(url);
    var res = BaseResp.fromJson(response);
    return res;
  }

  //usdt充值地址
  static Future<BaseResp> usdtDepositAddr() async {
    var url = "/wallet/usdt/depositAddr";
    var response = await Http().get(url);
    var res = BaseResp.fromJson(response);
    return res;
  }

  //钱包兑换提示
  static Future<BaseResp> postWalletConvertCoinTips(params) async {
    var url = "/wallet/convertCoinTips";
    var response = await Http().post(url, data: params);
    var res = BaseResp.fromJson(response);
    return res;
  }

  //钱包兑换计算
  static Future<BaseResp> postWalletConvertCoin(params) async {
    var url = "/wallet/convertCoin";
    var response = await Http().post(url, data: params);
    var res = BaseResp.fromJson(response);
    return res;
  }

  //钱包划转
  static Future<BaseResp> postWalletTransfer(params) async {
    var url = "/wallet/transfer";
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
    var url = "/wallet/totalRebate";
    var response = await Http().get(url);
    var res = BaseResp.fromJson(response);
    return res;
  }
}
