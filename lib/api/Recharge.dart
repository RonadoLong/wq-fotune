import 'package:wq_fotune/model/base_resp.dart';
import 'HttpUtils.dart';

/// 获取会员套餐
/// by heqingqing 2020/06/24
Future<BaseResp> Members() async {
  var url = "/user/members";
  var response = await Http().get(url);
  var res = BaseResp.fromJson(response);
  return res;
}


/// 支付方式
/// by heqingqing 2020/06/24
Future<BaseResp> PaymentMethods() async {
  var url = "/user/paymentMethods";
  var response = await Http().get(url);
  var res = BaseResp.fromJson(response);
  return res;
}
