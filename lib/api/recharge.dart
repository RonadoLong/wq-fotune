import 'package:wq_fotune/model/base_resp.dart';
import 'http_utils.dart';

class RechargeApi {
  /// 获取会员套餐
  static Future<BaseResp> members() async {
    var url = "/user/v1/members";
    var response = await Http().get(url);
    var res = BaseResp.fromJson(response);
    return res;
  }

  /// 支付方式
  static Future<BaseResp> paymentMethods() async {
    var url = "/user/v1/paymentMethods";
    var response = await Http().get(url);
    var res = BaseResp.fromJson(response);
    return res;
  }
}
