import 'package:wq_fotune/model/base_resp.dart';

import 'HttpUtils.dart';

// ignore: non_constant_identifier_names
Future<BaseResp> GetStrategyList(params) async {
  var url = "/user/register";
  var response = await Http().post(url, data: params);
  var res = BaseResp.fromJson(response);
  return res;
}
