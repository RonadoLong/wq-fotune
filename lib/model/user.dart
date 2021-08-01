
class UserResp {
  String msg;
  int code;
  User data;

  UserResp({
    this.msg,
    this.code,
    this.data,
  });

  UserResp.fromJson(Map<String, dynamic> json) {
    this.msg = json['msg'];
    this.code = json['code'];
    this.data = User.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['code'] = this.code;
    data['data'] = this.data.toJson();
    return data;
  }
}

class User {
  String user_id;
  String token;
  int expires_in;

  User({
    this.user_id,
    this.token,
    this.expires_in,
  });

  User.fromJson(Map<String, dynamic> json) {
    this.user_id = json['user_id'];
    this.token = json['token'];
    this.expires_in = json['expires_in'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.user_id;
    data['token'] = this.token;
    data['expires_in'] = this.expires_in;
    return data;
  }
}
