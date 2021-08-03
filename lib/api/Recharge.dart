import 'package:wq_fotune/model/base_resp.dart';
import 'http_utils.dart';

class RechargeApi {
  /// 获取会员套餐
  /// by heqingqing 2020/06/24
  static Future<BaseResp> members() async {
    var url = "/user/members";
    var response = await Http().get(url);
    var res = BaseResp.fromJson(response);
    return res;
  }

  /// 支付方式
  /// by heqingqing 2020/06/24
  static Future<BaseResp> paymentMethods() async {
    var url = "/user/paymentMethods";
    var response = await Http().get(url);
    var res = BaseResp.fromJson(response);
    return res;
  }
}
