import 'package:wq_fotune/model/base_resp.dart';

import 'http_utils.dart';

// ignore: non_constant_identifier_names
Future<BaseResp> RegisterUser(params) async {
  var url = "/user/register";
  var response = await Http().post(url, data: params);
  var res = BaseResp.fromJson(response);
  return res;
}

// backPwd
Future<BaseResp> ForgetPWD(params) async {
  var url = "/user/backPwd";
  var response = await Http().put(url, data: params);
  var res = BaseResp.fromJson(response);
  return res;
}

// ignore: non_constant_identifier_names
Future<BaseResp> PostCode(params) async {
  var url = "/user/send/validate-code";
  print(url + 'url');
  var response = await Http().post(url, data: params);
  print(response);
  var res = BaseResp.fromJson(response);
  print("PostCode call back $res");
  return res;
}

// ignore: non_constant_identifier_names
Future<BaseResp> Login(params) async {
  var url = "/user/login";
  var response = await Http().post(url, data: params);
  var res = BaseResp.fromJson(response);
  print("Login call back $res");
  return res;
}

Future<BaseResp> ForgetPassword(params) async {
  var url = "/user/forget/password";
  var response = await Http().put(url, data: params);
  var res = BaseResp.fromJson(response);
  print("ForgetPassword call back $res");
  return res;
}

Future<BaseResp> ResetPassword(params) async {
  var url = "/user/reset/password";
  var response = await Http().put(url, data: params);
  var res = BaseResp.fromJson(response);
  print("ForgetPassword call back $res");
  return res;
}

Future<BaseResp> ResetUser(params) async {
  var url = "/user/update";
  var response = await Http().put(url, data: params);
  var res = BaseResp.fromJson(response);
  print("ForgetPassword call back $res");
  return res;
}

Future<BaseResp> userRegister(params) async {
  var url = "/user/register";
  var response = await Http().post(url, data: params);
  var res = BaseResp.fromJson(response);
  print("userRegister call back $res");
  return res;
}

// ignore: non_constant_identifier_names
Future<BaseResp> getUserInfo() async {
  var url = "/user/base-info";
  var response = await Http().get(url);
  var res = BaseResp.fromJson(response);
  return res;
}

// ignore: non_constant_identifier_names
Future<BaseResp> BindRealName(params) async {
  var url = "/user/realName";
  var response = await Http().put(url, data: params);
  var res = BaseResp.fromJson(response);
  return res;
}

Future<BaseResp> UpdatePwd(params) async {
  var url = "/user/modifyPwd";
  var response = await Http().put(url, data: params);
  var res = BaseResp.fromJson(response);
  return res;
}

Future<BaseResp> GetBankList(uid) async {
  var url = "/bank/list/$uid";
  var response = await Http().get(url);
  var res = BaseResp.fromJson(response);
  return res;
}

Future<BaseResp> AddBank(query) async {
  var url = "/bank/add";
  var response = await Http().post(url, data: query);
  var res = BaseResp.fromJson(response);
  return res;
}

Future<BaseResp> GetRechargeLists() async {
  var url = "/recharge";
  var response = await Http().get(url);
  var res = BaseResp.fromJson(response);
  return res;
}

Future<BaseResp> PostTiXian(params) async {
  var url = "/user/withdraw";
  var response = await Http().post(url, data: params);
  var res = BaseResp.fromJson(response);
  return res;
}

Future<BaseResp> GetBanks() async {
  var url = "/bank/banks";
  var response = await Http().get(url);
  var res = BaseResp.fromJson(response);
  return res;
}
