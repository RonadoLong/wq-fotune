import 'package:wq_fotune/model/base_resp.dart';

import 'http_utils.dart';

class CommonApi {
  static Future<BaseResp> commonCarousels() async {
    var url = "common/v1/carousels";
    var response = await Http().get(url);
    var res = BaseResp.fromJson(response);
    return res;
  }

  //获取app版本
  static Future<BaseResp> getAppVersion(params) async {
    var url = "/common/v1/appVersion/$params";
    var response = await Http().get(url);
    var res = BaseResp.fromJson(response);
    return res;
  }

  /// 客服联系
  static Future<BaseResp> commonContact() async {
    var url = "/common/v1/contact";
    var response = await Http().get(url);
    var res = BaseResp.fromJson(response);
    return res;
  }

}
