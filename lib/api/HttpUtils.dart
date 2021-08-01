import 'package:dio/dio.dart';
import 'package:wq_fotune/global.dart';
import 'package:wq_fotune/model/user_info.dart';

const bool inProduction = const bool.fromEnvironment("dart.vm.product");
const PROHOST = "https://www.ifortune.io";
const DEVHOST = "http://192.168.3.58:9530";
String host = inProduction ? DEVHOST : DEVHOST;

class Http {
  static Http instance;
  static String token;
  static Dio _dio;
  static const CONTENT_TYPE_JSON = "application/json";
  static const CONTENT_TYPE_FORM = "application/x-www-form-urlencoded";

  BaseOptions _options;

  // ignore: missing_return
  static Future<Http> getInstance() async {
    print("getInstance");
    if (instance == null) {
      instance = new Http();
    }
  }

  Http() {
    _options = new BaseOptions(
      baseUrl: "$host/api/v1/",
      connectTimeout: 15000,
      receiveTimeout: 15000,
      sendTimeout: 15000,
      headers: {},
    );

    _dio = new Dio(_options);

    _dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) {
          print('${options.path}, ${options.uri}');
      UserInfo user = Global.getUserInfo();
      if (user != null) {
        options.headers["Authorization"] = user.token;
      }
      return options;
    }, onResponse: (Response response) {
          return response; // continue
    }, onError: (DioError e) {
      // ShowToast("请求失败，请重试");
      print("InterceptorsWrapper ====== err $e");
      return e;
    }));
  }

  // get 请求封装
  get(url, {options, cancelToken, data}) async {
    print('get::: url：$url');
    Response response;
    try {
      response =
          await _dio.get(url, queryParameters: data, cancelToken: cancelToken);
      return response.data == null ? response : response.data;
    } on DioError catch (e) {
      if (CancelToken.isCancel(e)) {
        print('get请求取消! ' + e.message);
      } else {
        print('get请求发生错误：$e');
      }
    }
    if (response == null) {
      return {"code": 500, "data": {}, "msg": "网络出错"};
    }
  }

  // post请求封装
  post(url, {options, cancelToken, data}) async {
    print('post请求::: url：$url ,body: $data');
    try {
      Response response = await _dio.post(url,
          data: data != null ? data : {}, cancelToken: cancelToken);
      return response.data;
    } on DioError catch (e) {
      if (CancelToken.isCancel(e)) {
        print('post请求取消! ' + e.message);
      } else {
        print('post请求发生错误：$e');
      }
    }
  }

  // post请求封装
  put(url, {options, cancelToken, data}) async {
    print('put请求::: url：$url ,body: $data');
    Response response;
    try {
      response = await _dio.put(url,
          data: data != null ? data : {}, cancelToken: cancelToken);
      return response.data;
    } on DioError catch (e) {
      if (CancelToken.isCancel(e)) {
        print('put请求取消! ' + e.message);
      } else {
        print('post请求发生错误：$e');
      }
    }
  }

  // delete请求封装
  delete(url, {options, cancelToken, data}) async {
    print('delete请求::: url：$url ,body: $data');
    Response response;
    try {
      response = await _dio.delete(url,
          data: data != null ? data : {}, cancelToken: cancelToken);
      return response.data;
    } on DioError catch (e) {
      if (CancelToken.isCancel(e)) {
        print('delete请求取消! ' + e.message);
      } else {
        print('delete请求发生错误：$e');
      }
    }
  }
}
