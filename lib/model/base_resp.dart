import 'dart:convert';


class BaseResp<T> extends Object {

  String msg;
  int code;
  T data;

  BaseResp({
    this.msg,
    this.code,
    this.data,
  });

  BaseResp.fromJson(Map<String, dynamic> json) {
    this.msg = json['msg'];
    this.code = json['code'];
    this.data = json['data'];
  }

  @override
  String toString() {
    return 'BaseResp{msg: $msg, code: $code, data: $data}';
  }
}
