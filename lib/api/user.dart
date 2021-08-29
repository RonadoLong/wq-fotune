import 'package:wq_fotune/model/base_resp.dart';

import 'http_utils.dart';

class UserApi {
// backPwd
  static Future<BaseResp> backPwd(params) async {
    var url = "/user/v1/backPwd";
    var response = await Http().put(url, data: params);
    var res = BaseResp.fromJson(response);
    return res;
  }

  static Future<BaseResp> postCode(params) async {
    var url = "/user/v1/send/validate-code";
    print(url + 'url');
    var response = await Http().post(url, data: params);
    print(response);
    var res = BaseResp.fromJson(response);
    print("PostCode call back $res");
    return res;
  }

  static Future<BaseResp> login(params) async {
    var url = "/user/v1/login";
    var response = await Http().post(url, data: params);
    var res = BaseResp.fromJson(response);
    print("Login call back $res");
    return res;
  }

  static Future<BaseResp> forgetPassword(params) async {
    var url = "/user/v1/forget/password";
    var response = await Http().put(url, data: params);
    var res = BaseResp.fromJson(response);
    print("ForgetPassword call back $res");
    return res;
  }

  static Future<BaseResp> resetPassword(params) async {
    var url = "/user/v1/reset/password";
    var response = await Http().put(url, data: params);
    var res = BaseResp.fromJson(response);
    print("ForgetPassword call back $res");
    return res;
  }

  static Future<BaseResp> updateUser(params) async {
    var url = "/user/v1/update";
    var response = await Http().put(url, data: params);
    var res = BaseResp.fromJson(response);
    print("ForgetPassword call back $res");
    return res;
  }

  static Future<BaseResp> userRegister(params) async {
    var url = "/user/v1/register";
    var response = await Http().post(url, data: params);
    var res = BaseResp.fromJson(response);
    print("userRegister call back $res");
    return res;
  }

  static Future<BaseResp> getUserInfo() async {
    var url = "/user/v1/base-info";
    var response = await Http().get(url);
    var res = BaseResp.fromJson(response);
    return res;
  }

  static Future<BaseResp> bindRealName(params) async {
    var url = "/user/v1/realName";
    var response = await Http().put(url, data: params);
    var res = BaseResp.fromJson(response);
    return res;
  }

  static Future<BaseResp> updatePwd(params) async {
    var url = "/user/v1/modifyPwd";
    var response = await Http().put(url, data: params);
    var res = BaseResp.fromJson(response);
    return res;
  }

  static Future<BaseResp> getBankList(uid) async {
    var url = "/bank/list/$uid";
    var response = await Http().get(url);
    var res = BaseResp.fromJson(response);
    return res;
  }

  static Future<BaseResp> addBank(query) async {
    var url = "/bank/add";
    var response = await Http().post(url, data: query);
    var res = BaseResp.fromJson(response);
    return res;
  }

  static Future<BaseResp> getRechargeLists() async {
    var url = "/recharge";
    var response = await Http().get(url);
    var res = BaseResp.fromJson(response);
    return res;
  }

  static Future<BaseResp> postTiXian(params) async {
    var url = "/user/v1/withdraw";
    var response = await Http().post(url, data: params);
    var res = BaseResp.fromJson(response);
    return res;
  }

  static Future<BaseResp> getBanks() async {
    var url = "/bank/banks";
    var response = await Http().get(url);
    var res = BaseResp.fromJson(response);
    return res;
  }

}